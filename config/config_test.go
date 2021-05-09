package config

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestInitialize(t *testing.T) {
	conf := Initialize()
	assert.Equal(t, "hadenlabs/pre-commit-hooks", conf.image)
}

func TestNewConfig(t *testing.T) {
	assert.Equal(t, &Config{}, New())
}
