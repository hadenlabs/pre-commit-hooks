package test

import (
	"testing"

	"strings"

	"github.com/gruntwork-io/terratest/modules/docker"
	"github.com/stretchr/testify/assert"
)

const imageTag string = "hadenlabs/pre-commit-hooks:latest"

func TestPreCommitHooksBuildSuccess(t *testing.T) {
	otherOptions := []string{}

	buildOptions := &docker.BuildOptions{
		Tags:         []string{imageTag},
		OtherOptions: otherOptions,
	}

	docker.Build(t, "../", buildOptions)
	opts := &docker.RunOptions{
		Command: []string{
			"bash", "-c",
			"compgen -c", "|",
			"sort -u",
		},
		Remove: true,
	}
	outputListApps := docker.Run(t, imageTag, opts)
	assert.NotEmpty(t, outputListApps, outputListApps)
}

func TestPreCommitHooksValidatePreCommitSuccess(t *testing.T) {
	otherOptions := []string{}
	expectApps := []string{
		"pre-commit",
	}

	buildOptions := &docker.BuildOptions{
		Tags:         []string{imageTag},
		OtherOptions: otherOptions,
	}

	docker.Build(t, "../", buildOptions)
	opts := &docker.RunOptions{
		Command: []string{
			"bash", "-c",
			"compgen -c", "|",
			"sort -u",
		},
		Remove: true,
	}
	outputListApps := docker.Run(t, imageTag, opts)
	assert.NotEmpty(t, outputListApps, outputListApps)
	assert.Subset(t, strings.Split(outputListApps, "\n"), expectApps)
}

func TestPreCommitHooksValidateTerraformSuccess(t *testing.T) {
	otherOptions := []string{}
	expectApps := []string{
		"terraform",
		"terraform-docs",
		"tflint",
		"tfsec",
		"checkov",
	}

	buildOptions := &docker.BuildOptions{
		Tags:         []string{imageTag},
		OtherOptions: otherOptions,
	}

	docker.Build(t, "../", buildOptions)
	opts := &docker.RunOptions{
		Command: []string{
			"bash", "-c",
			"compgen -c", "|",
			"sort -u",
		},
		Remove: true,
	}
	outputListApps := docker.Run(t, imageTag, opts)
	assert.NotEmpty(t, outputListApps, outputListApps)
	assert.Subset(t, strings.Split(outputListApps, "\n"), expectApps)
}

func TestPreCommitHooksValidateTerragruntSuccess(t *testing.T) {
	otherOptions := []string{}
	expectApps := []string{
		"terragrunt",
	}

	buildOptions := &docker.BuildOptions{
		Tags:         []string{imageTag},
		OtherOptions: otherOptions,
	}

	docker.Build(t, "../", buildOptions)
	opts := &docker.RunOptions{
		Command: []string{
			"bash", "-c",
			"compgen -c", "|",
			"sort -u",
		},
		Remove: true,
	}
	outputListApps := docker.Run(t, imageTag, opts)
	assert.NotEmpty(t, outputListApps, outputListApps)
	assert.Subset(t, strings.Split(outputListApps, "\n"), expectApps)
}

func TestPreCommitHooksValidateGoSuccess(t *testing.T) {
	otherOptions := []string{}
	expectApps := []string{
		"gocritic",
		"gocyclo",
		"goimports",
		"golangci-lint",
		"golint",
	}

	buildOptions := &docker.BuildOptions{
		Tags:         []string{imageTag},
		OtherOptions: otherOptions,
	}

	docker.Build(t, "../", buildOptions)
	opts := &docker.RunOptions{
		Command: []string{
			"bash", "-c",
			"compgen -c", "|",
			"sort -u",
		},
		Remove: true,
	}
	outputListApps := docker.Run(t, imageTag, opts)
	assert.NotEmpty(t, outputListApps, outputListApps)
	assert.Subset(t, strings.Split(outputListApps, "\n"), expectApps)
}

func TestPreCommitHooksValidateLeaksSuccess(t *testing.T) {
	otherOptions := []string{}
	expectApps := []string{
		"gitleaks",
	}

	buildOptions := &docker.BuildOptions{
		Tags:         []string{imageTag},
		OtherOptions: otherOptions,
	}

	docker.Build(t, "../", buildOptions)
	opts := &docker.RunOptions{
		Command: []string{
			"bash", "-c",
			"compgen -c", "|",
			"sort -u",
		},
		Remove: true,
	}
	outputListApps := docker.Run(t, imageTag, opts)
	assert.NotEmpty(t, outputListApps, outputListApps)
	assert.Subset(t, strings.Split(outputListApps, "\n"), expectApps)
}
