package test

import (
	"os"
	"testing"
)

func TestRunRawFiltersProtoStderr(t *testing.T) {
	binaryPath := os.Getenv("DERRICK_BINARY")
	if binaryPath == "" {
		t.Skip("DERRICK_BINARY not set")
	}

	wp := NewBinary(t, binaryPath, t.TempDir())
	_, stderr, err := wp.RunRaw("version")
	if err != nil {
		t.Fatalf("version failed: %v stderr=%q", err, stderr)
	}
	if stderr != "" {
		t.Fatalf("expected filtered stderr to be empty, got: %q", stderr)
	}
}
