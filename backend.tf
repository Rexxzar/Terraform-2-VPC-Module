terraform {
  backend "s3" {
    bucket = "awesomebucketeyad"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}