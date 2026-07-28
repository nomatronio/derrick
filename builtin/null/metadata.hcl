integration {
  name        = "Null"
  description = "The Null plugin is used for testing and experimentation with the different plugin components."
  identifier  = "derrick/null"
  components  = ["config-sourcer", "builder", "platform", "release-manager"]
  flags       = ["builtin"]
  license {
    type = "MPL-2.0"
    url  = "https://github.com/nomatronio/derrick/blob/main/LICENSE"
  }
}
