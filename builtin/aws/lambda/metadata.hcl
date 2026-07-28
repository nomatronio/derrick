integration {
  name        = "AWS Lambda"
  description = "The AWS Lambda plugin deploys OCI images as functions to AWS Lambda."
  identifier  = "derrick/aws-lambda"
  components  = ["platform"]
  flags       = ["builtin"]
  license {
    type = "MPL-2.0"
    url  = "https://github.com/nomatronio/derrick/blob/main/LICENSE"
  }
}
