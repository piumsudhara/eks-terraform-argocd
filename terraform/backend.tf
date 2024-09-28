terraform {
  backend "s3" {
    bucket         = "pium-tf-argo"
    key            = "tfargo/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "tf-argo-lock"
  }
}
