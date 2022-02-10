# homebrew-earthly-staging

This repo holds the latest pre-release versions of earthly.
These versions are considered to be experimental.

To install the experimental version of earthly run:

    brew install earthly/earthly-staging/earthly && earthly bootstrap

## Automation details

brew packages are automatically built by the [test-and-publish.yml](.github/workflows/test-and-publish.yml) GitHub Actions script.
This script is automatically triggered on all branches which are named `release-v0.<seconds-since-epoch>.<short-git-sha-in-decimal>`. These branches are automatically created by a different [GitHub Actions script](https://github.com/earthly/earthly/blob/main/.github/workflows/staging-deploy.yml)
in the [github.com/earthly/earthly](https://github.com/earthly/earthly) repository

### Converting short-git-sha-in-decimal to hex

Due to Semantic Versioning, the corresponding git commit sha was encoded as a decimal value of the patch-field. To convert the decimal value back to a hex git branch, you can run the following at your terminal:

    printf '%x\n' <short-git-sha-in-decimal>


Take for example release `earthly-0.1644526854.89274345`, running `printf '%x\n' 89274345` on the terminal will display `55237e9`, which can be viewed at `https://github.com/earthly/earthly/commit/55237e9`
