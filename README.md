# homebrew-earthly-staging

This repo holds the latest pre-release versions of earthly.
These versions are considered to be experimental.

To install the experimental version of earthly run:

    brew install earthly/earthly-staging/earthly && earthly bootstrap

## Automation details

brew packages are automatically built by the [test-and-publish.yml](.github/workflows/test-and-publish.yml) GitHub Actions script.
This script is automatically triggered on all branches which are named `release-v0.0.<seconds-since-epoch>`. The `release-v0.0.<seconds-since-epoch>`
branch is automatically created by a different [GitHub Actions script](https://github.com/earthly/earthly/blob/main/.github/workflows/staging-deploy.yml)
in the [github.com/earthly/earthly](https://github.com/earthly/earthly) repository

