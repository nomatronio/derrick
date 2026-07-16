package cli

import (
	"context"

	"github.com/posener/complete"

	"github.com/nomatronio/derrick-plugin-sdk/terminal"
	clientpkg "github.com/nomatronio/derrick/internal/client"
	"github.com/nomatronio/derrick/internal/clierrors"
	"github.com/nomatronio/derrick/internal/pkg/flag"
	pb "github.com/nomatronio/derrick/pkg/server/gen"
)

type ConfigSyncCommand struct {
	*baseCommand
}

func (c *ConfigSyncCommand) Run(args []string) int {
	// Initialize. If we fail, we just exit since Init handles the UI.
	if err := c.Init(
		WithArgs(args),
		WithFlags(c.Flags()),
		WithMultiAppTargets(),
	); err != nil {
		return 1
	}

	err := c.DoApp(c.Ctx, func(ctx context.Context, app *clientpkg.App) error {
		app.UI.Output("Synchronizing application %q configuration with Derrick server...",
			app.Ref().Application, terminal.WithHeaderStyle())

		sg := app.UI.StepGroup()
		defer sg.Wait()

		step := sg.Add("Synchronizing configuration variables and pipeline configs...")
		defer step.Abort()

		jobResult, err := app.ConfigSync(ctx, &pb.Job_ConfigSyncOp{})
		if err != nil {
			app.UI.Output(clierrors.Humanize(err), terminal.WithErrorStyle())
			return ErrSentinel
		}

		step.Update("Configuration variables synchronized!")
		step.Done()

		if jobResult.PipelineConfigSync != nil && len(jobResult.PipelineConfigSync.SyncedPipelines) > 0 {
			step := sg.Add("Configuration for pipelines synchronized!")
			step.Done()

			// Extra space
			app.UI.Output("")
			for name, ref := range jobResult.PipelineConfigSync.SyncedPipelines {
				pipelineRef, ok := ref.Ref.(*pb.Ref_Pipeline_Owner)
				if !ok {
					app.UI.Output("failed to convert pipeline ref", terminal.WithErrorStyle())
					return ErrSentinel
				}

				app.UI.Output("✔ Pipeline %q (%s) synchronized!", name, pipelineRef.Owner.Project, terminal.WithInfoStyle())
			}
		}

		step = sg.Add("Application configuration for %q synchronized successfully with Derrick server!", app.Ref().Application)
		step.Done()

		return nil
	})
	if err != nil {
		return 1
	}

	return 0
}

func (c *ConfigSyncCommand) Flags() *flag.Sets {
	return c.flagSet(flagSetOperation, nil)
}

func (c *ConfigSyncCommand) AutocompleteArgs() complete.Predictor {
	return complete.PredictNothing
}

func (c *ConfigSyncCommand) AutocompleteFlags() complete.Flags {
	return c.Flags().Completions()
}

func (c *ConfigSyncCommand) Synopsis() string {
	return "Synchronize declared variables and pipeline configs in a derrick.hcl"
}

func (c *ConfigSyncCommand) Help() string {
	return formatHelp(`
Usage: derrick config sync [options]

  Synchronize declared application configuration in the derrick.hcl file
  for existing and new deployments.

  Conflicting configuration keys will be overwritten. Configuration keys
  that do not exist in the derrick.hcl file but exist on the server will not
  be deleted.

` + c.Flags().Help())
}
