terraform {
  backend "s3" {
    bucket         = "aeternity-terraform-states"
    key            = "ae-mainnet-api.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}

# Default provider
provider "aws" {
  version = "2.16.0"
  region  = "us-east-1"
}

provider "aws" {
  version = "2.16.0"
  region  = "us-west-2"
  alias   = "us-west-2"
}

provider "aws" {
  version = "2.16.0"
  region  = "eu-north-1"
  alias   = "eu-north-1"
}
