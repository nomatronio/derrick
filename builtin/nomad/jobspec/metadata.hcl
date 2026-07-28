integration {
  name        = "Nomad Jobspec"
  description = "The Nomad Jobspec plugin deploys to a Nomad cluster from a pre-existing Nomad job specification file."
  identifier  = "derrick/nomad-jobspec"
  components  = ["platform"]
  flags       = ["builtin"]
  license {
    type = "MPL-2.0"
    url  = "https://github.com/nomatronio/derrick/blob/main/LICENSE"
  }
}
