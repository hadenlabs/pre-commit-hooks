package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/docker"
	"github.com/hadenlabs/pre-commit-hooks/config"
	"github.com/stretchr/testify/assert"
)

func TestPreCommitHooksRunPreCommitSuccess(t *testing.T) {
	conf := config.Initialize()
	imageTag := conf.Docker.ImageTagLatest()
	otherOptions := []string{}
	buildOptions := &docker.BuildOptions{
		Tags:         []string{imageTag},
		OtherOptions: otherOptions,
	}

	docker.Build(t, "../../", buildOptions)
	opts := &docker.RunOptions{
		Command: []string{
			"bash", "-c",
			"pre-commit -V",
		},
		Remove: true,
	}
	outputPreCommit := docker.Run(t, imageTag, opts)
	assert.NotEmpty(t, outputPreCommit, outputPreCommit)
}
