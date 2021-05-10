package config

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestDockerTargetImage(t *testing.T) {
	conf := Initialize()
	assert.Equal(t, "hadenlabs/pre-commit-hooks", conf.Docker.TargetImage)
}

func TestDockerTag(t *testing.T) {
	conf := Initialize()
	assert.NotEmpty(t, conf.Docker.Tag)
}

func TestDockerImageTag(t *testing.T) {
	conf := Initialize()
	assert.NotEmpty(t, conf.Docker.ImageTag())
}

func TestDockerImageTagLatest(t *testing.T) {
	conf := Initialize()
	assert.NotEmpty(t, conf.Docker.ImageTagLatest())
}

func TestDockerTagLatest(t *testing.T) {
	conf := Initialize()
	assert.Equal(t, "latest", conf.Docker.TagLatest)
}
