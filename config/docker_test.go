package config

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestDockerTargetImage(t *testing.T) {
	conf := Initialize()
	assert.Equal(t, "hadenlabs/pre-commit-hooks", conf.Docker.TargetImage)
}
