# User Administration
## Changing an email address
Currently the Platform UI does not offer a way for users to manually change the email address associated with their wikibase.cloud account.
In order to change their email address, they have to reach out via the contact form and an engineer has to run the [ChangeEmail Command](https://github.com/wbstack/api/blob/main/app/Console/Commands/User/ChangeEmail.php):
```
 $ kubectl exec -ti deployments/api-app-backend -- php artisan wbs-user:change-email --from=foobar@foo.foo --to=barbar@bar.com
Successfully changed user email from 'foobar@foo.foo' to 'barbar@bar.com'
Note: a verification mail was sent to the new address ('barbar@bar.com').
```

As the output suggests, the user then has to verify this new email address. The old one is now not longer used.

