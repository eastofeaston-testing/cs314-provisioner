resource "slack_conversation" "this" {
#   for_each = toset(["t11", "t12", "t13"])
#   name              = each.value
  name = "my-channel"
  is_private        = false
  is_archived       = false
#   permanent_members = ["USLACKBOT", "U0923E1HLCW", "U0923T4D82H"]
  adopt_existing_ channel             = true
  action_on_destroy = "none"
}