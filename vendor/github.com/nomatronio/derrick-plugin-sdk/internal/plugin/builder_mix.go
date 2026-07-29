package plugin

import (
	"github.com/nomatronio/derrick-plugin-sdk/component"
)

type mix_Builder_Authenticator struct {
	component.Authenticator
	component.ConfigurableNotify
	component.Builder
	component.Documented
}
