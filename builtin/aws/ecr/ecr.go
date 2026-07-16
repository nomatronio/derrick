package ecr

import (
	"github.com/nomatronio/derrick-plugin-sdk"
)

//go:generate protoc -I ../../../.. --go_out=../../../.. --go-grpc_out=../../../.. waypoint/builtin/aws/ecr/plugin.proto

// Options are the SDK options to use for instantiation.
var Options = []sdk.Option{
	sdk.WithComponents(&Registry{}),
	sdk.WithMappers(ECRImageMapper),
}
