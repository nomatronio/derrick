integration {
  name        = "Helm"
  description = "The Helm plugin deploys to Kubernetes from a Helm chart. The Helm chart can be a local path or a chart in a repository."
  identifier  = "derrick/helm"
  components  = ["platform"]
  flags       = ["builtin"]
  license {
    type = "MPL-2.0"
    url  = "https://github.com/nomatronio/derrick/blob/main/LICENSE"
  }
}
