integration {
  name        = "AWS EC2"
  description = "The AWS EC2 plugin deploys an AWS AMI as a virtual machine, running on AWS EC2."
  identifier  = "derrick/aws-ec2"
  components  = ["platform"]
  flags       = ["builtin"]
  license {
    type = "MPL-2.0"
    url  = "https://github.com/nomatronio/derrick/blob/main/LICENSE"
  }
}
