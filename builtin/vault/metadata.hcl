integration {
  name        = "Vault"
  description = "The Vault plugin reads configuration values from Vault."
  identifier  = "derrick/vault"
  components  = ["config-sourcer"]
  flags       = ["builtin"]
  license {
    type = "MPL-2.0"
    url  = "https://github.com/nomatronio/derrick/blob/main/LICENSE"
  }
}
