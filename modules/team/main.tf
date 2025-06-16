locals {
  tno = try(format("t%s", tonumber(var.team)), format("%s", var.team))
}

resource "github_team" "this" {
  name        = local.tno
  description = format("Team %s", local.tno)
  privacy     = "closed"
}

resource "github_team_membership" "this" {
  for_each = var.members
  team_id  = github_team.this.id
  username = each.value
  role     = "member"
}