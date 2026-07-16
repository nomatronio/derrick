package docker

import (
	sdk "github.com/nomatronio/derrick-plugin-sdk"
)

//go:generate protoc -I. -I../../thirdparty/proto/opaqueany --go_out=paths=source_relative:. --go-grpc_out=paths=source_relative:. plugin.proto

const platformName = "docker"

// Options are the SDK options to use for instantiation.
var Options = []sdk.Option{
	sdk.WithComponents(&Builder{}, &Registry{}, &Platform{}, &TaskLauncher{}),
	// sdk.WithMappers(PackImageMapper),
}
