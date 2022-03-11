# wbaas-deploy

## Configuring the cluster

- Requires "Workload Identity" to be enabled https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
  - takes about 5 minutes to enable on the cluster

- Requires Node pool "Enable GKE Metadata Server" feature
  - manually enable Workload Identity on existing node pools after you enable Workload Identity on the cluster.
  - https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#option_2_node_pool_modification


Setup using
    - https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest/submodules/workload-identity ?


AFAIK:

1. Enable Workload identity
2. Connect a GSA to a K8_SA
3. This K8_SA should be the default runner of workloads (configure the clusters node-pools) https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#authenticating_to
4. ** Caution: Modifying the node pool immediately enables Workload Identity for any workloads running in the node pool. This prevents the workloads from using the Compute Engine default service account and might result in disruptions.** https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#option_1_node_pool_creation_with_recommended
5. Test it out https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#verify_the_setup