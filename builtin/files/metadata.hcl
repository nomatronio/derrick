integration {
  name        = "Files"
  description = "The Files plugin generates a value representing a path on disk, and can copy them to a specific directory."
  identifier  = "derrick/files"
  components  = ["builder", "registry"]
  flags       = ["builtin"]
  license {
    type = "MPL-2.0"
    url  = "https://github.com/nomatronio/derrick/blob/main/LICENSE"
  }
}
