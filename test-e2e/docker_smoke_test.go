package test

import (
	"fmt"
	"strings"
	"testing"
)

var (
	dockerTestDir         = fmt.Sprintf("%s/docker/go", examplesRootDir)
	dockerMultiAppTestDir = fmt.Sprintf("%s/docker/go-multiapp", examplesRootDir)
)

func TestDerrickDockerInstall(t *testing.T) {
	wp := NewBinary(t, wpBinary, dockerTestDir)
	stdout, stderr, err := wp.RunRaw("install", "-platform=docker", "-accept-tos", fmt.Sprintf("-docker-server-image=%s", wpServerImage), fmt.Sprintf("-docker-odr-image=%s", wpOdrImage))

	if err != nil {
		t.Errorf("unexpected error installing server to docker: %s\nstderr: %s", err, stderr)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output installing server to docker: %s", stderr)
	}

	if !strings.Contains(stdout, "Derrick server successfully installed and configured!") {
		t.Errorf("No success message detected after docker server install:\n%s", stdout)
	}
}

func TestDerrickDockerUp(t *testing.T) {
	wp := NewBinary(t, wpBinary, dockerTestDir)
	stdout, stderr, err := wp.RunRaw("init")

	if err != nil {
		t.Errorf("unexpected error initializing derrick project: %s\nstderr: %s", err, stderr)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output initializing derrick project: %s", stderr)
	}

	if !strings.Contains(stdout, "Project initialized!") {
		t.Errorf("No success message detected after initializing project:\n%s", stdout)
	}

	stdout, stderr, err = wp.RunRaw("up")

	if err != nil {
		t.Errorf("unexpected error deploying derrick project: %s\nstderr: %s", err, stderr)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output deploying derrick project: %s", stderr)
	}

	if !strings.Contains(stdout, "The deploy was successful!") {
		t.Errorf("No success message detected after deploying project:\n%s", stdout)
	}
}

func TestDerrickDockerMultiAppUp(t *testing.T) {
	wp := NewBinary(t, wpBinary, dockerMultiAppTestDir)
	stdout, stderr, err := wp.RunRaw("init")

	if err != nil {
		t.Errorf("unexpected error initializing derrick project: %s\nstderr: %s", err, stderr)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output initializing derrick project: %s", stderr)
	}

	if !strings.Contains(stdout, "Project initialized!") {
		t.Errorf("No success message detected after initializing project:\n%s", stdout)
	}

	stdout, stderr, err = wp.RunRaw("up")

	if err != nil {
		t.Errorf("unexpected error deploying derrick project: %s\nstderr: %s", err, stderr)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output deploying derrick project: %s", stderr)
	}

	if !strings.Contains(stdout, "The deploy was successful!") {
		t.Errorf("No success message detected after deploying project:\n%s", stdout)
	}
}

func TestDerrickDockerUpgrade(t *testing.T) {
	wp := NewBinary(t, wpBinary, dockerTestDir)
	stdout, stderr, err := wp.RunRaw("server", "upgrade", "-platform=docker", "-auto-approve", fmt.Sprintf("-docker-server-image=%s", wpServerImageUpgrade), fmt.Sprintf("-docker-odr-image=%s", wpOdrImageUpgrade), "-snapshot=false")

	if err != nil {
		t.Errorf("unexpected error upgrading server in docker: %s\nstderr: %s", err, stderr)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output upgrading server in docker: %s", stderr)
	}

	if !strings.Contains(stdout, "Derrick has finished upgrading the server") {
		t.Errorf("No success message detected after docker server install:\n%s", stdout)
	}
}

func TestDerrickDockerUpAfterUpgrade(t *testing.T) {
	wp := NewBinary(t, wpBinary, dockerTestDir)
	stdout, stderr, err := wp.RunRaw("up")

	if err != nil {
		t.Errorf("unexpected error deploying derrick project: %s\nstderr: %s", err, stderr)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output deploying derrick project: %s", stderr)
	}

	if !strings.Contains(stdout, "The deploy was successful!") {
		t.Errorf("No success message detected after deploying project:\n%s", stdout)
	}
}

func TestDerrickDockerMultiAppUpAfterUpgrade(t *testing.T) {
	wp := NewBinary(t, wpBinary, dockerMultiAppTestDir)
	stdout, stderr, err := wp.RunRaw("init")

	if err != nil {
		t.Errorf("unexpected error initializing derrick project: %s\nstderr: %s", err, stderr)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output initializing derrick project: %s", stderr)
	}

	if !strings.Contains(stdout, "Project initialized!") {
		t.Errorf("No success message detected after initializing project:\n%s", stdout)
	}

	stdout, stderr, err = wp.RunRaw("up")

	if err != nil {
		t.Errorf("unexpected error deploying derrick project: %s\nstderr: %s", err, stderr)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output deploying derrick project: %s", stderr)
	}

	if !strings.Contains(stdout, "The deploy was successful!") {
		t.Errorf("No success message detected after deploying project:\n%s", stdout)
	}
}

func TestDerrickDockerDestroy(t *testing.T) {
	wp := NewBinary(t, wpBinary, dockerTestDir)
	stdout, stderr, err := wp.RunRaw("destroy", "-auto-approve")

	if err != nil {
		t.Errorf("unexpected error destroying derrick project: %s\nstderr: %s", err, stderr)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output destroying derrick project: %v", stderr)
	}

	if !strings.Contains(stdout, "Destroy successful!") {
		t.Errorf("No success message detected after destroying project:\n%s", stdout)
	}
}

func TestDerrickDockerDestroyMultiApp(t *testing.T) {
	wp := NewBinary(t, wpBinary, dockerMultiAppTestDir)
	stdout, stderr, err := wp.RunRaw("destroy", "-auto-approve")

	if err != nil {
		t.Errorf("unexpected error destroying derrick project: %s\nstderr: %s", err, stderr)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output destroying derrick project: %v", stderr)
	}

	if !strings.Contains(stdout, "Destroy successful!") {
		t.Errorf("No success message detected after destroying project:\n%s", stdout)
	}
}

func TestDerrickDockerUninstall(t *testing.T) {
	wp := NewBinary(t, wpBinary, dockerTestDir)
	stdout, stderr, err := wp.RunRaw("server", "uninstall", "-platform=docker", "-auto-approve", "-snapshot=false")

	if err != nil {
		t.Errorf("unexpected error uninstalling derrick server: %s\nstderr: %s", err, stderr)
	}

	if stderr != "" {
		t.Errorf("unexpected stderr output uninstalling derrick server: %s", stderr)
	}

	if !strings.Contains(stdout, "Derrick server successfully uninstalled") {
		t.Errorf("No success message detected after uninstalling server:\n%s", stdout)
	}
}
