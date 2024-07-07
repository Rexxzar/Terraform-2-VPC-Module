resource "aws_shield_protection" "example" {
  name         = "example"
  resource_arn = "arn:aws:elb:us-east-1:${data.aws_caller_identity.current.account_id}:eip-allocation/${aws_eip.eip.id}"

  tags = {
    Environment = "sheild protection for the elb"
  }
}