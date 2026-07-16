// Package lambda contains components for deploying to AWS Lambda
package lambda

import (
	sdk "github.com/nomatronio/derrick-plugin-sdk"
)

//go:generate protoc -I. -I../../../thirdparty/proto --go_out=paths=source_relative:. --go-grpc_out=paths=source_relative:. plugin.proto

// Options are the SDK options to use for instantiation for
// the Google Cloud Run plugin.
var Options = []sdk.Option{
	sdk.WithComponents(&Platform{}),
}
