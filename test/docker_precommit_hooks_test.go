package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/docker"
	"github.com/stretchr/testify/assert"
)

func TestPreCommitHooks011Success(t *testing.T) {
	tag := "hadenlabs/pre-commit-hooks:0.1.1"
	otherOptions := []string{
		"--no-cache",
	}
	buildOptions := &docker.BuildOptions{
		Tags:         []string{tag},
		OtherOptions: otherOptions,
	}

	docker.Build(t, "../", buildOptions)

	opts := &docker.RunOptions{
		Command: []string{
			"golangci-lint",
		},
	}
	output := docker.Run(t, tag, opts)
	assert.NotEmpty(t, output, output)
}
