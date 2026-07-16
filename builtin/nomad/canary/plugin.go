package canary

import (
	sdk "github.com/nomatronio/derrick-plugin-sdk"
)

//go:generate protoc -I. -I../../../thirdparty/proto --go_out=paths=source_relative:. --go-grpc_out=paths=source_relative:. plugin.proto

// Options are the SDK options to use for instantiation for
// the Nomad plugin.
var Options = []sdk.Option{
	sdk.WithComponents(&Releaser{}),
}
