integration {
  name        = "AWS AMI"
  description = "The AWS AMI plugin searches for and returns an existing AMI, to be deployed as an EC2."
  identifier  = "derrick/aws-ami"
  components  = ["builder"]
  flags       = ["builtin"]
  license {
    type = "MPL-2.0"
    url  = "https://github.com/nomatronio/derrick/blob/main/LICENSE"
  }
}
