integration {
  name        = "Nomad"
  description = "The Nomad plugin deploys a Docker container to a Nomad cluster. It also launches on-demand runners to do operations remotely."
  identifier  = "derrick/nomad"
  components  = ["platform", "task"]
  flags       = ["builtin"]
  license {
    type = "MPL-2.0"
    url  = "https://github.com/nomatronio/derrick/blob/main/LICENSE"
  }
}
