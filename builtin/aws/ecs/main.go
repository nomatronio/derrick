package ecs

import (
	sdk "github.com/nomatronio/derrick-plugin-sdk"
)

//go:generate protoc -I. -I../../../thirdparty/proto --go_out=paths=source_relative:. --go-grpc_out=paths=source_relative:. plugin.proto

const platformName = "aws-ecs"

// Options are the SDK options to use for instantiation.
var Options = []sdk.Option{
	sdk.WithComponents(&Platform{}, &TaskLauncher{}),
}
