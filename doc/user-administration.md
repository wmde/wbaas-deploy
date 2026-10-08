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

## Checking if user email exists in api db and/or wiki db
[User/ CheckEmail command](https://github.com/wbstack/api/blob/5fafbcee36df22422d8dc85eb32c1549cff3357a/app/Console/Commands/User/CheckUserEmailExist.php)
```
$ kubectl exec -ti deployments/api-queue-default -- php artisan wbs-user:check-email wbcuser@mail.com notfounduser@mail.com
FOUND: wbcuser@mail.com in location.user
---------------------------------------------------
NOT FOUND: notfounduser@mail.com
---------------------------------------------------
```
This command expects an email or a list of emails separated by space

