integration {
  name        = "CloudNative Buildpacks"
  description = "The Pack plugin creates a Docker image using CloudNative Buildpacks."
  identifier  = "derrick/pack"
  components  = ["builder"]
  flags       = ["builtin"]
  license {
    type = "MPL-2.0"
    url  = "https://github.com/nomatronio/derrick/blob/main/LICENSE"
  }
}
