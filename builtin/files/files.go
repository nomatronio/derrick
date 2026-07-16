// Package files contains a component for validating local files.
package files

import (
	"github.com/nomatronio/derrick-plugin-sdk"
)

//go:generate protoc -I. --go_out=paths=source_relative:. --go-grpc_out=paths=source_relative:. plugin.proto

// Options are the SDK options to use for instantiation for
// the Files plugin.
var Options = []sdk.Option{
	sdk.WithComponents(&Builder{}, &Registry{}),
}
