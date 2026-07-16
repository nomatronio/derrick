package ptypes

import (
	validation "github.com/go-ozzo/ozzo-validation/v4"
	"github.com/nomatronio/derrick/internal/pkg/validationext"
	pb "github.com/nomatronio/derrick/pkg/server/gen"
)

// ValidateCreateHostnameRequest
func ValidateCreateHostnameRequest(v *pb.CreateHostnameRequest) error {
	return validationext.Error(validation.ValidateStruct(v,
		validation.Field(&v.Target, validation.Required),
	))
}
