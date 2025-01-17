terraform {
  backend "s3" {
    bucket = "react-app-bucket01"
    key = "backend/terraform.tfstate"
    region = "us-east-1"
    dynamodb_endpoint = "react-app-backend-tf"
  }
}
