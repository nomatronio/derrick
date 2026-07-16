package singleprocess

import (
	"context"

	"github.com/hashicorp/go-hclog"
	configpkg "github.com/nomatronio/derrick/pkg/config"
	pb "github.com/nomatronio/derrick/pkg/server/gen"
	"github.com/nomatronio/derrick/pkg/server/hcerr"
)

func (s *Service) DerrickHclFmt(
	ctx context.Context,
	req *pb.DerrickHclFmtRequest,
) (*pb.DerrickHclFmtResponse, error) {
	result, err := configpkg.Format(req.DerrickHcl, "<input>")
	if err != nil {
		return nil, hcerr.Externalize(
			hclog.FromContext(ctx),
			err,
			"failed to format waypoint hcl",
		)
	}

	return &pb.DerrickHclFmtResponse{DerrickHcl: result}, nil
}
