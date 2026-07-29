package derrlabels

import "testing"

func TestApplyID(t *testing.T) {
	labels := map[string]string{}
	ApplyID(labels, "abc123")
	if labels[LegacyIDKey] != "abc123" {
		t.Fatalf("legacy id: got %q", labels[LegacyIDKey])
	}
	if labels[IDKey] != "abc123" {
		t.Fatalf("current id: got %q", labels[IDKey])
	}
}

func TestIDSelector(t *testing.T) {
	got := IDSelector("xyz")
	want := LegacyIDKey + "=xyz," + IDKey + "=xyz"
	if got != want {
		t.Fatalf("got %q want %q", got, want)
	}
}
