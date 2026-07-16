// Package ssm contains components for syncing configuration with AWS SSM.
package ssm

import (
	"github.com/nomatronio/derrick-plugin-sdk"
)

// Options are the SDK options to use for instantiation for this plugin.
var Options = []sdk.Option{
	sdk.WithComponents(&ConfigSourcer{}),
}
