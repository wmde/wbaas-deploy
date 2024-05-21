# Debugging Backpressure in the QueryService Updater

This document is intended to give a general overview of the existing pipeline which feeds MediaWiki updates into the QueryService, as well as guidance on what to do when the queue is blocked or malfunctioning.

## Lifecycle of an update

When an update in MediaWiki is happening, the following steps will be taken until it's present in the QueryService:

1. Custom `wbstack` code in MediaWiki calls the Platform API's `/event/pageUpdate` endpoint, pushing information about the change. The Platform API persists these changes in the `event_page_updates` table.
2. The Platform API will repeatedly run the `CreateQueryserviceBatchesJob` which will:
	1. Filter all events from the `event_page_updates` table and select those with relevant namespace IDs (i.e. entities, properties, lexemes)
	2. Group these events by wiki domain and create sets of batches for each wiki. If a batch for a wiki already exists, try to append new items to these batches if possible.
3. The QueryService Updater repeatedly polls the `/qs/getBatches` endpoint exposed by the Platform API. When a batch is dispensed by the Platform API, it is marked as pending and won't be returned unless this marker is removed again. The QueryService Updater will now feed the batch's items into the QueryService itself.
4. When the QueryService Updater is done processing a batch, it will signal success or failure to the Platform API which will then update the Batch accordingly.
5. Batches that failed processing will be retried at most 3 times before being marked as failed permanently.
6. Already processed batches and page updates that are older than a month will be pruned from the database in cleanup jobs.

## Possible failure scenarios

Currently, feature health is measured by counting the number of unprocessed batches in the Platform API.
A healthy system will rarely see this value go above a value in the range between 15 and 50.
If it goes above this, it could be caused by the following:

### Failures in Platform API

If the Platform API is ingesting events, but fails to follow the expected protocol when exchanging data with the updater, the number of batches grows continuously.
This could be caused by the following (non-exhaustive) list of problems:

- The batch payload schemas expected by Platform API and the QueryService Updater have diverged
- Unrelated changes to the HTTP stack in Laravel are making the `/qs/getBatches` endpoint error out
- The Platform API fails to successfully mark batches as done, even when receiving a signal from the QueryService Updater
- The Platform API erroneously omits batches that should be processed, returning `[]`

### Failures in the QueryService Updater

If the QueryService Updater is polling the Platform API, but fails to process the batches in some unexpected way, it might never signal success / failure back to the Platform API.
This means none of these batches will ever be marked as `done` or `failed` and the total will grow until the issue is resolved.
This could be caused by the following (non-exhaustive) list of problems:

- The entities referenced by the batches cause the updater to come to a halt and stall. This means it will also never poll for new items, making the number of items in the backlog grow.
- The Updater fails to connect to the Platform API for networking reasons or bad configuration

### Failures in the QueryService

The QueryService itself is mostly opaque to us, however there are scenarios where it can cause the pipeline to become congested.
This could be caused by the following (non-exhaustive) list of problems:

- The QueryService is busy serving requests from other clients, failing to process updates in a timely manner
- Bugs in the QueryService cause it to become unresponsive

## Resolving a congested updater

When the pipeline is congested, there's a number of common steps to take in order to resolve the situation.

### Analyzing the distribution of items in the queue

Having access to a Tinker shell, you can use the following query to find out whether blockage is coming from a single wiki or if there is a general problem:

```console
> QsBatch::where(['done' => 0, 'failed' => 0])->get()->countBy('wiki_id')
= Illuminate\Support\Collection {#52487
    all: [
      721 => 3,
      1055 => 1,
    ],
  }
```

### Inspecting the batches currently being processed

To inspect the next batch that would be dispensed when the QueryService Updater polls, run the following query:

```console
> QsBatch::where([['done', '=',  0], ['failed', '=', 0], ['pending_since', '<>', null]])->get()
= Illuminate\Database\Eloquent\Collection {#52462
    all: [
      App\QsBatch {#52463
        id: 3085493,
        wiki_id: 448,
        entityIds: "Q47186,Q47210,Q49375,Q49377,Q49398,Q49413,Q140162,Q140918,Q159762,Q160048",
        done: 0,
        created_at: "2024-05-21 12:42:54",
        updated_at: "2024-05-21 12:42:59",
        pending_since: "2024-05-21 12:42:59",
        processing_attempts: 0,
        failed: 0,
      },
    ],
  }
```

Important fields to look at are:

- How many `processing_attempts` are there?
- For how long is the batch `pending`
- How big is the batch? Is the list of items in `entityIds` unusually long?

### Manually marking batches as failed

In case there are batches in the queue that fail to process and make the Updater break, it's advisable to manually mark these as failed by setting `failed => 1`.
For example, to mark all pending batches for a single wiki as failed run:

```console
> QsBatch::where(['wiki_id' => 999999])->update(['failed' => 1])
```

This will prevent the Platform API from ever dispensing any of these batches again.

### Restarting the QueryService Updater

In order to achieve a full restart of all QueryService Updater replicas, either:

- delete all replica pods manually using `kubectl`
- scale down the service to 0, then scale back up

### Restarting the QueryService

It's always safe to restart the QueryService itself by deleting the pod and have Kubernetes recreate it.
Restarting the QueryService will also mean that hanging updates are pruned from the Updater as it will fail on the dropped network connection.
This is also safe as batches will be marked as retryable afterwards and will be dispensed again.
