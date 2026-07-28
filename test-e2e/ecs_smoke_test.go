package test

import (
	"fmt"
	"strings"
	"testing"
)

var (
	// this one uses python instead of node just for kicks
	ecsTestDir = fmt.Sprintf("%s/aws/aws-ecs/python", examplesRootDir)
)

func TestDerrickEcsInstall(t *testing.T) {
	wp := NewBinary(t, wpBinary, ecsTestDir)
	stdout, stderr, err := wp.RunRaw("install", "-platform=ecs", "-accept-tos", fmt.Sprintf("-ecs-server-image=%s", wpServerImage), fmt.Sprintf("-ecs-odr-image=%s", wpOdrImage))

	if err != nil {
		t.Errorf("unexpected error installing server to ecs: %s", err)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output installing server to ecs: %s", stderr)
	}

	if !strings.Contains(stdout, "Derrick server successfully installed and configured!") {
		t.Errorf("No success message detected after ecs server install:\n%s", stdout)
	}
}

func TestDerrickEcsUp(t *testing.T) {
	wp := NewBinary(t, wpBinary, ecsTestDir)
	stdout, stderr, err := wp.RunRaw("init")

	if err != nil {
		t.Errorf("unexpected error initializing derrick project: %s", err)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output initializing derrick project: %s", stderr)
	}

	if !strings.Contains(stdout, "Project initialized!") {
		t.Errorf("No success message detected after initializing project:\n%s", stdout)
	}

	stdout, stderr, err = wp.RunRaw("up")

	if err != nil {
		t.Errorf("unexpected error deploying derrick project: %s", err)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output deploying derrick project: %s", stderr)
	}

	if !strings.Contains(stdout, "The deploy was successful!") {
		t.Errorf("No success message detected after deploying project:\n%s", stdout)
	}
}

func TestDerrickEcsUpgrade(t *testing.T) {
	wp := NewBinary(t, wpBinary, ecsTestDir)
	stdout, stderr, err := wp.RunRaw("server", "upgrade", "-platform=ecs", "-auto-approve", fmt.Sprintf("-ecs-server-image=%s", wpServerImageUpgrade), fmt.Sprintf("-ecs-odr-image=%s", wpOdrImageUpgrade), "-snapshot=false")

	if err != nil {
		t.Errorf("unexpected error upgrading server in ecs: %s", err)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output upgrading server in ecs: %s", stderr)
	}

	if !strings.Contains(stdout, "Derrick has finished upgrading the server") {
		t.Errorf("No success message detected after ecs server install:\n%s", stdout)
	}
}

func TestDerrickEcsUpAfterUpgrade(t *testing.T) {
	wp := NewBinary(t, wpBinary, ecsTestDir)
	stdout, stderr, err := wp.RunRaw("up")

	if err != nil {
		t.Errorf("unexpected error deploying derrick project: %s", err)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output deploying derrick project: %s", stderr)
	}

	if !strings.Contains(stdout, "The deploy was successful!") {
		t.Errorf("No success message detected after deploying project:\n%s", stdout)
	}
}

func TestDerrickEcsDestroy(t *testing.T) {
	wp := NewBinary(t, wpBinary, ecsTestDir)
	stdout, stderr, err := wp.RunRaw("destroy")

	if err != nil {
		t.Errorf("unexpected error destroying derrick project: %s", err)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output destroying derrick project: %s", stderr)
	}

	if !strings.Contains(stdout, "Destroy successful!") {
		t.Errorf("No success message detected after destroying project:\n%s", stdout)
	}
}

func TestDerrickEcsUninstall(t *testing.T) {
	wp := NewBinary(t, wpBinary, ecsTestDir)
	stdout, stderr, err := wp.RunRaw("server", "uninstall", "-platform=ecs", "-auto-approve", "-snapshot=false")

	if err != nil {
		t.Errorf("unexpected error uninstalling derrick server: %s", err)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output uninstalling derrick server: %s", stderr)
	}

	if !strings.Contains(stdout, "Derrick server successfully uninstalled") {
		t.Errorf("No success message detected after uninstalling server:\n%s", stdout)
	}
}
