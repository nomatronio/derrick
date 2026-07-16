package apply

import (
	"github.com/nomatronio/derrick-plugin-sdk"
)

//go:generate protoc -I. --go_out=paths=source_relative:. --go-grpc_out=paths=source_relative:. plugin.proto

// Options are the SDK options to use for instantiation for the plugin.
var Options = []sdk.Option{
	sdk.WithComponents(&Platform{}),
}
