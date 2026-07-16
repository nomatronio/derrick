// Package cloudrun contains components for deploying to Google Cloud Run.
package cloudrun

import (
	sdk "github.com/nomatronio/derrick-plugin-sdk"
)

//go:generate protoc -I. -I../../../thirdparty/proto/opaqueany --go_out=paths=source_relative:. --go-grpc_out=paths=source_relative:. plugin.proto

// Options are the SDK options to use for instantiation for
// the Google Cloud Run plugin.
var Options = []sdk.Option{
	sdk.WithComponents(&Platform{}, &Releaser{}),
}
