package singleprocess

import (
	"context"

	"github.com/nomatronio/derrick/internal/server/boltdbstate"
	pb "github.com/nomatronio/derrick/pkg/server/gen"
)

func testServiceImpl(impl pb.DerrickServer) *Service {
	return impl.(*Service)
}

func testStateInmem(impl pb.DerrickServer) *boltdbstate.State {
	return testServiceImpl(impl).state(context.Background()).(*boltdbstate.State)
}
