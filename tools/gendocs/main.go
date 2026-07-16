package main

import (
	"os"

	"github.com/nomatronio/derrick/internal/cli"
)

func main() {
	cli.ExposeDocs = true
	os.Exit(cli.Main([]string{"waypoint", "cli-docs"}))
}
