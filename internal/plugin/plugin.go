package plugin

import (
	sdk "github.com/nomatronio/derrick-plugin-sdk"
	"github.com/nomatronio/derrick-plugin-sdk/component"
	dockerref "github.com/nomatronio/derrick/builtin/docker/ref"
	"github.com/nomatronio/derrick/builtin/nomad/canary"
	"github.com/nomatronio/derrick/builtin/packer"
	"github.com/nomatronio/derrick/internal/factory"

	"github.com/nomatronio/derrick/builtin/aws/alb"
	"github.com/nomatronio/derrick/builtin/aws/ami"
	"github.com/nomatronio/derrick/builtin/aws/ec2"
	"github.com/nomatronio/derrick/builtin/aws/ecr"
	awsecrpull "github.com/nomatronio/derrick/builtin/aws/ecr/pull"
	"github.com/nomatronio/derrick/builtin/aws/ecs"
	"github.com/nomatronio/derrick/builtin/aws/lambda"
	lambdaFunctionUrl "github.com/nomatronio/derrick/builtin/aws/lambda/function_url"
	"github.com/nomatronio/derrick/builtin/aws/ssm"
	"github.com/nomatronio/derrick/builtin/azure/aci"
	"github.com/nomatronio/derrick/builtin/consul"
	"github.com/nomatronio/derrick/builtin/docker"
	dockerpull "github.com/nomatronio/derrick/builtin/docker/pull"
	"github.com/nomatronio/derrick/builtin/exec"
	"github.com/nomatronio/derrick/builtin/files"
	"github.com/nomatronio/derrick/builtin/google/cloudrun"
	"github.com/nomatronio/derrick/builtin/k8s"
	k8sapply "github.com/nomatronio/derrick/builtin/k8s/apply"
	k8shelm "github.com/nomatronio/derrick/builtin/k8s/helm"
	"github.com/nomatronio/derrick/builtin/nomad"
	"github.com/nomatronio/derrick/builtin/nomad/jobspec"
	"github.com/nomatronio/derrick/builtin/null"
	"github.com/nomatronio/derrick/builtin/pack"
	"github.com/nomatronio/derrick/builtin/tfc"
	"github.com/nomatronio/derrick/builtin/vault"
)

var (
	// Builtins is the map of all available builtin plugins and their
	// options for launching them.
	Builtins = map[string][]sdk.Option{
		"files":                    files.Options,
		"pack":                     pack.Options,
		"docker":                   docker.Options,
		"docker-pull":              dockerpull.Options,
		"docker-ref":               dockerref.Options,
		"exec":                     exec.Options,
		"google-cloud-run":         cloudrun.Options,
		"azure-container-instance": aci.Options,
		"kubernetes":               k8s.Options,
		"kubernetes-apply":         k8sapply.Options,
		"helm":                     k8shelm.Options,
		"aws-ecs":                  ecs.Options,
		"aws-ecr":                  ecr.Options,
		"aws-ecr-pull":             awsecrpull.Options,
		"nomad":                    nomad.Options,
		"nomad-jobspec":            jobspec.Options,
		"nomad-jobspec-canary":     canary.Options,
		"aws-ami":                  ami.Options,
		"aws-ec2":                  ec2.Options,
		"aws-alb":                  alb.Options,
		"aws-ssm":                  ssm.Options,
		"aws-lambda":               lambda.Options,
		"lambda-function-url":      lambdaFunctionUrl.Options,
		"vault":                    vault.Options,
		"terraform-cloud":          tfc.Options,
		"null":                     null.Options,
		"consul":                   consul.Options,
		"packer":                   packer.Options,
	}

	// BaseFactories is the set of base plugin factories. This will include any
	// built-in or well-known plugins by default. This should be used as the base
	// for building any set of factories.
	BaseFactories = map[component.Type]*factory.Factory{
		component.MapperType:         mustFactory(factory.New((*interface{})(nil))),
		component.BuilderType:        mustFactory(factory.New(component.TypeMap[component.BuilderType])),
		component.RegistryType:       mustFactory(factory.New(component.TypeMap[component.RegistryType])),
		component.PlatformType:       mustFactory(factory.New(component.TypeMap[component.PlatformType])),
		component.ReleaseManagerType: mustFactory(factory.New(component.TypeMap[component.ReleaseManagerType])),
		component.ConfigSourcerType:  mustFactory(factory.New(component.TypeMap[component.ConfigSourcerType])),
		component.TaskLauncherType:   mustFactory(factory.New(component.TypeMap[component.TaskLauncherType])),
	}

	// ConfigSourcers are the list of built-in config sourcers. These will
	// eventually be moved out to exec-based plugins but for now we just
	// hardcode them. This is used by the CEB.
	ConfigSourcers = map[string]*Instance{
		"aws-ssm": {
			Component: &ssm.ConfigSourcer{},
		},
		"kubernetes": {
			Component: &k8s.ConfigSourcer{},
		},
		"null": {
			Component: &null.ConfigSourcer{},
		},
		"vault": {
			Component: &vault.ConfigSourcer{},
		},
		"terraform-cloud": {
			Component: &tfc.ConfigSourcer{},
		},
		"consul": {
			Component: &consul.ConfigSourcer{},
		},
		"packer": {
			Component: &packer.ConfigSourcer{},
		},
	}
)

func must(err error) {
	if err != nil {
		panic(err)
	}
}

func mustFactory(f *factory.Factory, err error) *factory.Factory {
	must(err)
	return f
}
