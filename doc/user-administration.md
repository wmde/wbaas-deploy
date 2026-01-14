# User Administration
Currently the Platform UI only offers limited ways for a user to manage their wikibase.cloud user account, and manual intervention becomes necessary upon request. For certain scenarios we created code to perform these actions, in order to reduce mistakes and inconsistent database states.

## Changing an Email Address
[User/ChangeEmail Command](https://github.com/wbstack/api/blob/main/app/Console/Commands/User/ChangeEmail.php)
```
$ kubectl exec -ti deployments/api-app-backend -- php artisan wbs-user:change-email --from=foobar@foo.foo --to=barbar@bar.com
Successfully changed user email from 'foobar@foo.foo' to 'barbar@bar.com'
Note: a verification mail was sent to the new address ('barbar@bar.com').
```

As the output suggests, the user then has to verify this new email address. The old one is now not longer used.

## Disabling a User Account
[User/Disable Command](https://github.com/wbstack/api/blob/main/app/Console/Commands/User/Disable.php)
```
$ kubectl exec -ti deployments/api-app-backend -- php artisan wbs-user:disable --email='mail@example.com'
Successfully disabled user account with email 'mail@example.com' (id: '2')
Information about email and password hash was deleted.
```

- This will delete their email address and password hash, so they won't be able to log in anymore
- It will fail if the user still has accessible wikis associated with their account and will list the wikis
  - In this case verify, that these wikis should get removed and try again after that

## Soft-Deleting a Wiki
[Wiki/Delete Command](https://github.com/wbstack/api/blob/main/app/Console/Commands/Wiki/Delete.php)
```
$ kubectl exec -ti deployments/api-app-backend -- php artisan wbs-wiki:delete domain 'fjdsjkfdskjfdskjfds.wbaas.dev'
Success!
```

- This Commands first argument defines the key it should look for in the database via the second argument
  - Domain is recommended, as there is less potential for mistakes then with numeral IDs

### Restoring a Soft-Deleted Wiki
In case you need to restore a soft-deleted wiki, there currently is not a ready Command there yet for this, and it is recommended to create one if ever needed. However, in emergencies it can also be achieved via `artisan tinker`. A session could look like this:

```
$ kubectl exec -ti deployments/api-app-backend -- php artisan tinker
Psy Shell v0.12.0 (PHP 8.2.29 — cli) by Justin Hileman

# Verify wiki information
> Wiki::withTrashed()->firstWhere('domain', 'fjdsjkfdskjfdskjfds.wbaas.dev')
[!] Aliasing 'Wiki' to 'App\Wiki' for this Tinker session.
= App\Wiki {#7518
    id: 7,
    domain: "fjdsjkfdskjfdskjfds.wbaas.dev",
    sitename: "fdfs",
    deleted_at: "2025-11-06 17:27:49",
    created_at: "2025-11-06 17:26:52",
    updated_at: "2025-11-06 17:27:49",
    description: null,
    is_featured: 0,
    wiki_deletion_reason: null,
    +domain_decoded: "fjdsjkfdskjfdskjfds.wbaas.dev",
  }

# Restore the soft-deleted wiki
> Wiki::withTrashed()->firstWhere('domain', 'fjdsjkfdskjfdskjfds.wbaas.dev')->restore()
= true

# Verify again, notice that `deleted_at` is now null
> Wiki::firstWhere('domain', 'fjdsjkfdskjfdskjfds.wbaas.dev') 
= App\Wiki {#6537
    id: 7,
    domain: "fjdsjkfdskjfdskjfds.wbaas.dev",
    sitename: "fdfs",
    deleted_at: null,
    created_at: "2025-11-06 17:26:52",
    updated_at: "2025-11-06 17:29:24",
    description: null,
    is_featured: 0,
    wiki_deletion_reason: null,
    +domain_decoded: "fjdsjkfdskjfdskjfds.wbaas.dev",
  }
```

## Checking if user email exists in api db and/or wiki db
[User/ CheckEmail command](https://github.com/wbstack/api/blob/5fafbcee36df22422d8dc85eb32c1549cff3357a/app/Console/Commands/User/CheckUserEmailExist.php)
```
$ kubectl exec -ti deployments/api-app-backend -- php artisan wbs-user:check-email wbcuser@mail.com notfounduser@mail.com
FOUND: wbcuser@mail.com in location.user
---------------------------------------------------
NOT FOUND: notfounduser@mail.com
---------------------------------------------------
```
This command expects an email or a list of emails separated by space

