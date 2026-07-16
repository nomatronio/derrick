package function_url

import "github.com/nomatronio/derrick-plugin-sdk/component"

func (r *Release) URL() string { return r.Url }

var _ component.Release = (*Release)(nil)
