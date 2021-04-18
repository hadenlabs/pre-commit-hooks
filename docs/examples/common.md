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
      - id: go-lint
      - id: go-cyclo
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
