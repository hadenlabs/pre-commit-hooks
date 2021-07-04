<!--


  ** DO NOT EDIT THIS FILE
  **
  ** 1) Make all changes to `README.yaml`
  ** 2) Run`make readme` to rebuild this file.
  **
  ** (We maintain HUNDREDS of open source projects. This is how we maintain our sanity.)
  **


  -->

 

 [![Latest Release](https://img.shields.io/github/release/hadenlabs/pre-commit-hooks)](https://github.com/hadenlabs/pre-commit-hooks/releases) [![Lint](https://img.shields.io/github/workflow/status/hadenlabs/pre-commit-hooks/lint-code)](https://github.com/hadenlabs/pre-commit-hooks/actions?workflow=lint-code) [![CI](https://img.shields.io/github/workflow/status/hadenlabs/pre-commit-hooks/ci)](https://github.com/hadenlabs/pre-commit-hooks/actions?workflow=ci) [![Test](https://img.shields.io/github/workflow/status/hadenlabs/pre-commit-hooks/test)](https://github.com/hadenlabs/pre-commit-hooks/actions?workflow=test) [![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit) [![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow)](https://conventionalcommits.org) [![KeepAChangelog](https://img.shields.io/badge/Keep%20A%20Changelog-1.0.0-%23E05735)](https://keepachangelog.com)

# pre-commit-hooks

 This repository is a collection of Git hooks to be used with the
[pre-commit](https://pre-commit.com/) framework. 




## Features
- [Terraform](https://github.com/terraform-linters/tflint)
- [TodoCheck](https://github.com/preslavmihaylov/todocheck)
- [Go](https://golang.org)
- [Markdown](https://github.com/tcort/markdown-link-check)
- [Shellcheck](https://github.com/koalaman/shellcheck)
- [Hadolint](https://github.com/hadolint/hadolint)








## TODO


* [chore: implement hook gnu make](https://github.com/hadenlabs/pre-commit-hooks/issues/2)







## Installation
### Base

1. Install [pre-commit](https://pre-commit.com/). E.g. `brew install pre-commit`
### MacOS

1. Install [Terraform](https://www.terraform.io/), [TFLint](https://github.com/terraform-linters/tflint), [Go](https://golang.org/), [markdown-link-check](https://github.com/tcort/markdown-link-check), [shellcheck](https://github.com/koalaman/shellcheck). E.g

```shell script
  brew install terraform \
      tflint \
      go \
      golangci/tap/golangci-lint \
      shellcheck && \
      yarn global add markdown-link-check
```
### Linux




## Usage


Create a `.pre-commit-config.yaml` inside your repositories and add the desired list of hooks.
Please see the [documentation](https://pre-commit.com/#usage) for further information.


```yaml
  repos:
    - repo: https://github.com/hadenlabs/pre-commit-hooks
      rev: 0.2.0
      hooks:
        - id: terraform-fmt
        - id: terraform-validate
        - id: markdown-link-check
        - id: go-fmt

```

Once you created the configuration file inside your repository, you must run `pre-commit install` to activate the hooks.
That's it, pre-commit will now listen for changes in your files and run the checks accordingly.






## Examples

### Example: Run All Hooks

```shell script
pre-commit run --all-files
```

### Example: Run A Specific Hook

```shell script
pre-commit run terraform-validate --all-files
```

### terraform:

```yaml
repos:
  - repo: https://github.com/hadenlabs/pre-commit-hooks
    rev: 0.2.0
    hooks:
      - id: terraform-fmt
      - id: terraform-validate
      - id: terraform-docs
        args:
          - '--output-file=docs/include/terraform.md'
          - '--output-mode=replace'
          - '--sort-by-type'
      - id: terraform-docs-replace
      - id: terraform-tflint
      - id: terraform-tfsec
      - id: checkov
```

### terragrunt:

```yaml
repos:
  - repo: https://github.com/hadenlabs/pre-commit-hooks
    rev: 0.2.0
    hooks:
      - id: terragrunt-fmt
      - id: terraform-validate
```

### markdown:

```yaml
repos:
  - repo: https://github.com/hadenlabs/pre-commit-hooks
    rev: 0.2.0
    hooks:
      - id: markdown-link-check
        args:
          - '--config=markdown-config.json'
```

### shell:

```yaml
repos:
  - repo: https://github.com/hadenlabs/pre-commit-hooks
    rev: 0.2.0
    hooks:
      - id: shellcheck
```

### Go:

```yaml
repos:
  - repo: https://github.com/hadenlabs/pre-commit-hooks
    rev: 0.2.0
    hooks:
      - id: go-fmt
      - id: go-imports
      - id: go-vet
      - id: golint
      - id: gocyclo
      - id: validate-toml
      - id: no-go-testing
      - id: golangci-lint
      - id: go-critic
      - id: go-unit-tests
      - id: go-build
      - id: go-mod-tidy
      - id: go-mod-vendor
```

### check:

```yaml
repos:
  - repo: https://github.com/hadenlabs/pre-commit-hooks
    rev: 0.2.0
    hooks:
      - id: todocheck
```

### grep:

```yaml
repos:
  - repo: https://github.com/hadenlabs/pre-commit-hooks
    rev: 0.2.0
    hooks:
      - id: do-not-commit
```

### docker:

```yaml
repos:
  - repo: https://github.com/hadenlabs/pre-commit-hooks
    rev: 0.2.0
    hooks:
      - id: hadolint
```

### docker-compose:

```yaml
repos:
  - repo: https://github.com/hadenlabs/pre-commit-hooks
    rev: 0.2.0
    hooks:
      - id: docker-compose-check
```

### gitleaks:

```yaml
repos:
  - repo: https://github.com/hadenlabs/pre-commit-hooks
    rev: 0.2.0
    hooks:
      - id: gitleaks
        args:
          - --path=.
          - --repo-config-path=.github/linters/.gitleaks.toml
          - --verbose
```









## Help

**Got a question?**

File a GitHub [issue](https://github.com/hadenlabs/pre-commit-hooks/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/hadenlabs/pre-commit-hooks/issues) to report any bugs or file feature requests.

### Development

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

1.  **Fork** the repo on GitHub
2.  **Clone** the project to your own machine
3.  **Commit** changes to your own branch
4.  **Push** your work back up to your fork
5.  Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to rebase the latest changes from "upstream" before making a pull request!

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)](https://semver.org/).

Using the given version number of `MAJOR.MINOR.PATCH`, we apply the following constructs:

1. Use the `MAJOR` version for incompatible changes.
1. Use the `MINOR` version when adding functionality in a backwards compatible manner.
1. Use the `PATCH` version when introducing backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- In the context of initial development, backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is
  increased. (Initial development)
- In the context of pre-release, backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is
  increased. (Pre-release)




## Copyright

Copyright © 2018-2021 [Hadenlabs](https://hadenlabs.com)



## Trademarks

All other trademarks referenced herein are the property of their respective owners.






## License

The code and styles are licensed under the LGPL-3.0 license [See project license.](LICENSE).



## Don't forget to 🌟 Star 🌟 the repo if you like pre-commit-hooks

[Your feedback is appreciated](https://github.com/hadenlabs/pre-commit-hooks/issues)
