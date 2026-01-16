# Managing anubis botstopper secrets

We use BotStopper instead of the default Anubis image To display a more professional loading image during bot detection,https://phabricator.wikimedia.org/T402205
we replaced the default Anubis image with BotStopper, as recommended in the Anubis documentation. https://anubis.techaro.lol/docs/admin/botstopper/

Given that the bostopper image is stored in a private GitHub Container Registry, Kubernetes need credentials to pull the image. 
For this we generate a GitHub classic access token that we provide to kubernetes as a kubernetes image pull secret. 

To generate a new GitHub access token we need a GitHub account that has access to the botstopper container image. https://phabricator.wikimedia.org/T402205#11460380

