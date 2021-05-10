package config

import (
	"github.com/hadenlabs/pre-commit-hooks/internal/errors"
	"github.com/hadenlabs/pre-commit-hooks/internal/version"
)

const tagLatest string = "latest"

// Config struct field.
type Config struct {
	Docker Docker
	App    App
}

// Configurer methods for config.
type Configurer interface {
	ReadConfig() (*Config, error)
}

// ReadConfig read values and files for config.
func (c *Config) ReadConfig() (*Config, error) {
	tag := version.Short()
	c.Docker.TargetImage = targetImage
	c.Docker.Tag = tag
	c.Docker.TagLatest = tagLatest
	c.App.Version = tag
	return c, nil
}

// Initialize new instance.
func Initialize() *Config {
	conf := New()
	conf, err := conf.ReadConfig()
	if err != nil {
		panic(errors.Wrap(err, errors.ErrorReadConfig, ""))
	}
	return conf
}

// New create config.
func New() *Config {
	return &Config{}
}
