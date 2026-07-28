integration {
  name        = "Azure Container Instance"
  description = "The Azure ACI plugin deploys a container to Azure Container Instances."
  identifier  = "derrick/azure-container-instance"
  components  = ["platform"]
  flags       = ["builtin"]
  license {
    type = "MPL-2.0"
    url  = "https://github.com/nomatronio/derrick/blob/main/LICENSE"
  }
}
