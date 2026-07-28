integration {
  name        = "Exec"
  description = "The Exec plugin executes any command to perform a deploy. This enables the use of pre-existing deployment tools."
  identifier  = "derrick/exec"
  components  = ["platform"]
  flags       = ["builtin"]
  license {
    type = "MPL-2.0"
    url  = "https://github.com/nomatronio/derrick/blob/main/LICENSE"
  }
}
