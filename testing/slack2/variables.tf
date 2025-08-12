variable "name" {
    type = string
    default = "t11"
}

variable "slack_api_token" {
  type        = string
  description = "The API token for authenticating with Slack"
  default = null
}