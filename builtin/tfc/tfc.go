// Package tfc contains components for syncing outputs of states from Terraform Cloud
package tfc

import (
	sdk "github.com/nomatronio/derrick-plugin-sdk"
)

// Options are the SDK options to use for instantiation for this plugin.
var Options = []sdk.Option{
	sdk.WithComponents(&ConfigSourcer{}),
}
