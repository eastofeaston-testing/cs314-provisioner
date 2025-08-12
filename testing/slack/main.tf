# resource "slack_user_group" "this" {
#   name        = var.name
#   description = format("%s's team", var.name)
#   handle      = var.name
#   channels    = [var.name]
# }

data "slack_conversations" "this" {
  # depends_on = [slack_user_group.this]
  exclude_archived = false
  types            = ["public_channel", "private_channel"]
}

data "slack_users" "all" {
}

output "conversations" {
  value = {for i in data.slack_conversations.this.conversations : i.name => i.id}
  # value = data.slack_conversations.this.conversations
}

output "users" {
  value = [for i in data.slack_users.all.users : i.profile.email if i.profile.email != ""]
}