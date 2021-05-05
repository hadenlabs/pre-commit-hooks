package test

import (
	"testing"

	"strings"

	"github.com/gruntwork-io/terratest/modules/docker"
	"github.com/stretchr/testify/assert"
)

func TestPreCommitHooksBuildSuccess(t *testing.T) {
	tag := "hadenlabs/pre-commit-hooks:latest"
	otherOptions := []string{}

	buildOptions := &docker.BuildOptions{
		Tags:         []string{tag},
		OtherOptions: otherOptions,
	}

	docker.Build(t, "../", buildOptions)
	opts := &docker.RunOptions{
		Command: []string{
			"bash", "-c",
			"compgen -c", "|",
			"sort -u",
		},
	}
	outputListApps := docker.Run(t, tag, opts)
	assert.NotEmpty(t, outputListApps, outputListApps)
}

func TestPreCommitHooksValidateTerraformSuccess(t *testing.T) {
	tag := "hadenlabs/pre-commit-hooks:latest"
	otherOptions := []string{}
	expectApps := []string{
		"terraform",
		"terraform-docs",
		"tflint",
		"tfsec",
		"checkov",
	}

	buildOptions := &docker.BuildOptions{
		Tags:         []string{tag},
		OtherOptions: otherOptions,
	}

	docker.Build(t, "../", buildOptions)
	opts := &docker.RunOptions{
		Command: []string{
			"bash", "-c",
			"compgen -c", "|",
			"sort -u",
		},
	}
	outputListApps := docker.Run(t, tag, opts)
	assert.NotEmpty(t, outputListApps, outputListApps)
	assert.Subset(t, strings.Split(outputListApps, "\n"), expectApps)
}

func TestPreCommitHooksValidateTerragruntSuccess(t *testing.T) {
	tag := "hadenlabs/pre-commit-hooks:latest"
	otherOptions := []string{}
	expectApps := []string{
		"terragrunt",
	}

	buildOptions := &docker.BuildOptions{
		Tags:         []string{tag},
		OtherOptions: otherOptions,
	}

	docker.Build(t, "../", buildOptions)
	opts := &docker.RunOptions{
		Command: []string{
			"bash", "-c",
			"compgen -c", "|",
			"sort -u",
		},
	}
	outputListApps := docker.Run(t, tag, opts)
	assert.NotEmpty(t, outputListApps, outputListApps)
	assert.Subset(t, strings.Split(outputListApps, "\n"), expectApps)
}

func TestPreCommitHooksValidateGoSuccess(t *testing.T) {
	tag := "hadenlabs/pre-commit-hooks:latest"
	otherOptions := []string{}
	expectApps := []string{
		"gocritic",
		"gocyclo",
		"goimports",
		"golangci-lint",
		"golint",
	}

	buildOptions := &docker.BuildOptions{
		Tags:         []string{tag},
		OtherOptions: otherOptions,
	}

	docker.Build(t, "../", buildOptions)
	opts := &docker.RunOptions{
		Command: []string{
			"bash", "-c",
			"compgen -c", "|",
			"sort -u",
		},
	}
	outputListApps := docker.Run(t, tag, opts)
	assert.NotEmpty(t, outputListApps, outputListApps)
	assert.Subset(t, strings.Split(outputListApps, "\n"), expectApps)
}
