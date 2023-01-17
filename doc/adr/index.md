# Architecture Decision Records

This directory collects Architecture Decision Records, as outlined by Michael Nygard in his article: http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions

Architecture (understood widely) decisions should be documented in the ADR format.

A template for this repository is provided here: [template](./NNNN-adr-template.md)

ADRs related to possible changed, superseded or any other outdated decisions should NOT be removed from the directory.
Superseding decisions should reference ADRs they're changing or overriding.

Current ADRs include:

<!-- toc-start -->
- [1) Use GKE for MariaDB logical backups](0001-use-gke-backup-for-maria-logical-backups.md)
- [2) Version Terraform Modules with Git](0002-version-terraform-modules-with-git.md)
- [3) Use two clusters](0003-number-of-clusters.md)
- [4) No new chart cuts just for a new image version ](0004-no-new-chart-for-image-bumps.md)
- [5) Commit Hash based reference to UI image ](0005-ui-by-commit-hash.md)
- [6) Production as the configuration base case for helmfile values ](0006-helmfile-base-values.md)
<!-- toc-end -->

---

To update the TOC, you can run `./update-toc` from within this directory.
