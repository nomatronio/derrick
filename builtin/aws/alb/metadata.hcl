integration {
  name        = "AWS Application Load Balancer"
  description = "The AWS ALB plugin releases applications deployed to AWS by attaching target groups to an ALB."
  identifier  = "derrick/aws-alb"
  components  = ["release-manager"]
  flags       = ["builtin"]
  license {
    type = "MPL-2.0"
    url  = "https://github.com/nomatronio/derrick/blob/main/LICENSE"
  }
}
