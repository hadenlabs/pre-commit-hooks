package config

const (
	targetImage string = "hadenlabs/pre-commit-hooks"
)

// Docker struct field.
type Docker struct {
	TargetImage string
	Tag         string
}
