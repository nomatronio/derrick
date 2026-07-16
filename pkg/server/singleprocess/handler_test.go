package singleprocess

import (
	"context"
	"math/rand"
	"testing"
	"time"

	"github.com/nomatronio/derrick/pkg/server"
	pb "github.com/nomatronio/derrick/pkg/server/gen"
	"github.com/nomatronio/derrick/pkg/serverhandler/handlertest"
	"github.com/nomatronio/derrick/pkg/serverstate"
)

func init() {
	// Seed our test randomness
	rand.Seed(time.Now().UnixNano())
}

type OSSTestServerImpl struct {
	service *Service
}

func (o *OSSTestServerImpl) State(ctx context.Context) serverstate.Interface {
	return o.service.state(ctx)
}

// TestHandlers run the service handler tests that depend exclusively on the protobuf
// interfaces.
func TestHandlers(t *testing.T) {
	handlertest.Test(t, func(t *testing.T) (pb.DerrickClient, handlertest.TestServerImpl) {
		impl := TestImpl(t)

		client := server.TestServer(t, impl)

		return client, &OSSTestServerImpl{service: impl.(*Service)}
	}, nil)
}
