package test

import (
	"strings"
	"testing"
)

func TestFilterBenignStderr(t *testing.T) {
	t.Parallel()

	cases := []struct {
		name   string
		stderr string
		want   string
	}{
		{
			name:   "empty",
			stderr: "",
			want:   "",
		},
		{
			name:   "single proto warning",
			stderr: `WARNING: proto: file "plugin.proto" is already registered`,
			want:   "",
		},
		{
			name:   "proto warning with non-breaking space",
			stderr: "WARNING: proto:\u00a0file \"plugin.proto\" is already registered",
			want:   "",
		},
		{
			name: "multiple proto warnings lf",
			stderr: strings.Repeat(`WARNING: proto: file "plugin.proto" is already registered`+"\n", 3),
			want:   "",
		},
		{
			name: "multiple proto warnings crlf",
			stderr: strings.Repeat(`WARNING: proto: file "plugin.proto" is already registered`+"\r\n", 3),
			want:   "",
		},
		{
			name: "proto warning with related lines",
			stderr: `WARNING: proto: file "plugin.proto" is already registered
	previously from: github.com/foo
	currently from: github.com/bar
See https://developers.google.com/protocol-buffers/docs/reference/go/faq#namespace-conflict
`,
			want: "",
		},
		{
			name:   "real error preserved",
			stderr: "ERROR: something went wrong\nWARNING: proto: file \"plugin.proto\" is already registered\n",
			want:   "ERROR: something went wrong",
		},
	}

	for _, tc := range cases {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()
			got := filterBenignStderr(tc.stderr)
			if got != tc.want {
				t.Fatalf("filterBenignStderr() = %q, want %q", got, tc.want)
			}
		})
	}
}
