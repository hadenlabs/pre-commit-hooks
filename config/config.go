package config

import (
	"github.com/hadenlabs/pre-commit-hooks/internal/errors"
)

const (
	imageName string = "hadenlabs/pre-commit-hooks"
)

// Config struct field.
type Config struct {
	image string
}

// Configurer methods for config.
type Configurer interface {
	ReadConfig() (*Config, error)
}

// ReadConfig read values and files for config.
func (c *Config) ReadConfig() (*Config, error) {
	c.image = imageName
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
