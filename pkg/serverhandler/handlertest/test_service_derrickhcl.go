package handlertest

import (
	"context"
	"testing"

	"github.com/stretchr/testify/require"

	pb "github.com/nomatronio/derrick/pkg/server/gen"
)

func init() {
	tests["waypoint_hcl"] = []testFunc{
		TestServiceDerrickHclFmt,
	}
}

func TestServiceDerrickHclFmt(t *testing.T, factory Factory) {
	ctx := context.Background()

	// Create our server
	client, _ := factory(t)

	t.Run("basic formatting", func(t *testing.T) {
		require := require.New(t)

		const input = `
project="foo"
`

		const output = `
project = "foo"
`

		// Create, should get an ID back
		resp, err := client.DerrickHclFmt(ctx, &pb.DerrickHclFmtRequest{
			DerrickHcl: []byte(input),
		})
		require.NoError(err)
		require.NotNil(resp)

		// Let's write some data
		require.Equal(string(resp.DerrickHcl), output)
	})
}
