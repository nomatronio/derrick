{
  description = "HashiCorp Derrick SDK";

  inputs.derrick.url = "github:hashicorp/derrick";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils, derrick }:
    flake-utils.lib.eachDefaultSystem (system: {
        # Just use the exact same shell environment as Derrick.
        devShell = derrick.devShell.${system};
      }
    );
}
