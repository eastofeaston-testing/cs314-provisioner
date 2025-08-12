terraform {
  required_providers {
    slack = {
      source = "tfstack/slack"
    }
  }
}

provider "slack" {
  api_token = var.slack_api_token
}