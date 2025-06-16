locals {
  configuration = jsondecode(file(var.config_json))
  students      = { for i in csvdecode(file(var.students_csv)) : i.studentidnumber => i }
  teams         = setunion(toset([for i in local.students : i.team]), toset(local.configuration.override_repos))
}

module "onboarding" {
  for_each = toset([for i in local.students : i.GitHub if i.GitHub != ""])
  source   = "../../modules/onboarding"
  username = each.value
}

module "sprintboundaries" {
  source = "../../modules/sprintboundaries"
}


module "team" {
  depends_on = [module.onboarding]
  for_each   = local.teams
  source     = "../../modules/team"
  team       = each.value
  members    = toset([for i in local.students : i.GitHub if i.team == each.value && i.GitHub != ""])
}

module "repository" {
  for_each             = module.team
  source               = "../../modules/repository"
  name                 = each.value.name
  attach_team          = true
  team_id              = each.value.team_id
  members              = [for i in local.students : i.NetID if i.team == each.value.team]
  add_members_variable = length([for i in local.students : i.NetID if i.team == each.value.team]) != 0
}