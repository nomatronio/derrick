package epinject

const (
	// EntrypointPath is the path where the Derrick entrypoint binary is
	// injected into container images.
	EntrypointPath = "/derrick-entrypoint"

	// LegacyEntrypointPath is the pre-rename path still recognized for
	// backwards compatibility with existing images.
	LegacyEntrypointPath = "/waypoint-entrypoint"
)

// IsEntrypoint reports whether path is a known Derrick entrypoint binary path.
func IsEntrypoint(path string) bool {
	return path == EntrypointPath || path == LegacyEntrypointPath
}

// HasEntrypoint reports whether entrypoint begins with a known Derrick
// entrypoint binary path.
func HasEntrypoint(entrypoint []string) bool {
	return len(entrypoint) > 0 && IsEntrypoint(entrypoint[0])
}
