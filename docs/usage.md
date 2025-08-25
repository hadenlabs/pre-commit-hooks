# How to use this project

Create a `.pre-commit-config.yaml` inside your repositories and add the desired list of hooks. Please see the [documentation](https://pre-commit.com/#usage) for further information.

```yaml
repos:
  - repo: https://github.com/hadenlabs/pre-commit-hooks
    rev: 0.4.0
    hooks:
      - id: terraform-fmt
      - id: terraform-validate
      - id: markdown-link-check
      - id: go-fmt
```

Once you created the configuration file inside your repository, you must run `pre-commit install` to activate the hooks. That's it, pre-commit will now listen for changes in your files and run the checks accordingly.
