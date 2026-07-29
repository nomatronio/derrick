package plugin

import (
	"github.com/nomatronio/derrick-plugin-sdk/component"
)

type mix_Registry_Authenticator struct {
	component.Authenticator
	component.ConfigurableNotify
	component.Registry
	component.Documented
	component.RegistryAccess
}
