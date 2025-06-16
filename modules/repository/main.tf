resource "github_repository" "this" {
  name        = var.name
  description = format("%s's repository for work", var.name)
  auto_init   = true
  visibility  = var.visibility
}

resource "github_team_repository" "this" {
  count      = var.attach_team ? 1 : 0
  team_id    = var.team_id
  repository = github_repository.this.name
  permission = "push"
}

resource "github_actions_variable" "this" {
  count         = var.add_members_variable ? 1 : 0
  repository    = github_repository.this.name
  variable_name = "netids"
  value         = join(",", var.members)
}