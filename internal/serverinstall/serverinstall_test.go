package serverinstall

import (
	"testing"

	"github.com/nomatronio/derrick/internal/installutil"
)

func TestDeriveDefaultODRImage(t *testing.T) {
	tests := []struct {
		name        string
		serverImage string
		want        string
		wantErr     bool
	}{
		{
			"Short name (does not add docker.io/library)",
			"nomatronio/derrick:latest",
			"nomatronio/derrick-odr:latest",
			false,
		},
		{
			"Alpha",
			"ghcr.io/nomatronio/derrick/alpha:latest",
			"ghcr.io/nomatronio/derrick/alpha-odr:latest",
			false,
		},
		{
			"Custom registry with port (doesn't get confused by multiple colons)",
			"my.registry:5000/nomatronio/derrick:latest",
			"my.registry:5000/nomatronio/derrick-odr:latest",
			false,
		},
		{
			"Custom registry with port and no tag returns error (doesn't see the port as a tag)",
			"my.registry:5000/nomatronio/derrick",
			"",
			true,
		},
		{
			"No tag returns an error",
			"nomatronio/derrick",
			"",
			true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := installutil.DeriveDefaultODRImage(tt.serverImage)
			if (err != nil) != tt.wantErr {
				t.Errorf("DeriveDefaultODRImage() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if got != tt.want {
				t.Errorf("DeriveDefaultODRImage() got = %v, want %v", got, tt.want)
			}
		})
	}
}
