terraform {
  required_providers {
    slack = {
      source  = "pablovarela/slack"
      version = "~> 1.0"
    }
  }
  required_version = ">= 0.13"
}

# Configure Slack Provider
provider "slack" {
  token = var.slack_api_token
}