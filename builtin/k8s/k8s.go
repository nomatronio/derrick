// Package k8s contains components for deploying to Kubernetes.
package k8s

import (
	sdk "github.com/nomatronio/derrick-plugin-sdk"
)

//go:generate protoc -I. -I../../thirdparty/proto --go_out=paths=source_relative:. --go-grpc_out=paths=source_relative:. plugin.proto

const platformName = "kubernetes"

// Options are the SDK options to use for instantiation for
// the Kubernetes plugin.
var Options = []sdk.Option{
	sdk.WithComponents(&Platform{}, &Releaser{}, &ConfigSourcer{}, &TaskLauncher{}),
}
