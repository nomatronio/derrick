package derrlabels

// Deployment label keys used to identify Derrick-managed resources.
// Legacy Waypoint keys are retained for compatibility with existing deployments.
const (
	LegacyIDKey    = "waypoint.hashicorp.com/id"
	LegacyNonceKey = "waypoint.hashicorp.com/nonce"

	IDKey    = "derrick.hashicorp.com/id"
	NonceKey = "derrick.hashicorp.com/nonce"
)

// ApplyID sets both legacy and current ID labels on the given label map.
func ApplyID(labels map[string]string, id string) {
	if labels == nil {
		return
	}
	labels[LegacyIDKey] = id
	labels[IDKey] = id
}

// ApplyNonce sets both legacy and current nonce labels on the given label map.
func ApplyNonce(labels map[string]string, nonce string) {
	if labels == nil {
		return
	}
	labels[LegacyNonceKey] = nonce
	labels[NonceKey] = nonce
}

// IDSelector returns a label selector that matches either legacy or current ID.
func IDSelector(id string) string {
	return LegacyIDKey + "=" + id + "," + IDKey + "=" + id
}
