integration {
  name        = "Consul"
  description = "The Consul plugin reads configuration values from the Consul KV store."
  identifier  = "derrick/consul"
  components  = ["config-sourcer"]
  flags       = ["builtin"]
  license {
    type = "MPL-2.0"
    url  = "https://github.com/nomatronio/derrick/blob/main/LICENSE"
  }
}
