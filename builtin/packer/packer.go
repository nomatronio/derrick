package packer

import (
	sdk "github.com/nomatronio/derrick-plugin-sdk"
)

var Options = []sdk.Option{
	sdk.WithComponents(&ConfigSourcer{}),
}
