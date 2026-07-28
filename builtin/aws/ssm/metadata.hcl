integration {
  name        = "AWS SSM"
  description = "The AWS SSM plugin reads configuration values from the AWS SSM Parameter Store."
  identifier  = "derrick/aws-ssm"
  components  = ["config-sourcer"]
  flags       = ["builtin"]
  license {
    type = "MPL-2.0"
    url  = "https://github.com/nomatronio/derrick/blob/main/LICENSE"
  }
}
