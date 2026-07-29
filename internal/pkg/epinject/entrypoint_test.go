package epinject

import "testing"

func TestHasEntrypoint(t *testing.T) {
	tests := []struct {
		name       string
		entrypoint []string
		want       bool
	}{
		{
			name:       "derrick entrypoint",
			entrypoint: []string{EntrypointPath, "bundle", "exec"},
			want:       true,
		},
		{
			name:       "legacy waypoint entrypoint",
			entrypoint: []string{LegacyEntrypointPath, "bundle", "exec"},
			want:       true,
		},
		{
			name:       "unrelated entrypoint",
			entrypoint: []string{"/bin/sh", "-c"},
			want:       false,
		},
		{
			name:       "empty entrypoint",
			entrypoint: nil,
			want:       false,
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			if got := HasEntrypoint(tc.entrypoint); got != tc.want {
				t.Fatalf("HasEntrypoint(%v) = %v, want %v", tc.entrypoint, got, tc.want)
			}
		})
	}
}
