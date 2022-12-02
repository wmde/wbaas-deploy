# Updates

Generally we want to have a strategy of updating components and dependencies here in a timely manner.

We would like to ship all security updates ASAP and give higher priority to more critical issues.

We would also like to ship non-security updates quickly. Given how fast moving the cloud landscape is rapid updates prevent us from then needing to do massive updates in one go.

## Dependencies of Helm Releases that we own
Most of the dependencies that we own are reasonably well covered by GitHub dependabot updates however we still need to review and merge these.

The procedure for this is fairly simple.
1. Checkout the dependabot PR
2. Read the changelog if existant
3. Make any necessary updates to our code that calls these dependencies
4. Test this in a local development environment
5. Merge the PR and release the component
6. Test the component on staging
7. Deploy to production

## Helm releases directly from a 3rd party

These are currently not checked or updated by dependabot and must be found and created by us manually.
