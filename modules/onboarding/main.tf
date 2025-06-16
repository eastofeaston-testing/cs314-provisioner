data "github_membership" "this" {
  username = var.username
}

resource "github_membership" "this" {
  count                = data.github_membership.this.state == "active" ? 0 : 1
  username             = var.username
  role                 = "member"
  downgrade_on_destroy = var.prevent_delete
}