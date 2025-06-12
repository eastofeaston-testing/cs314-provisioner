locals {
    files = fileset(var.directory, "**")
    list_teams = toset(split("\n", var.teams))
    joint = {for pair in setproduct(local.files, local.list_teams) : "${pair[0]}.${pair[1]}" => pair } 
}

data "github_repository" "this" {
    for_each = local.list_teams
    name = each.value
}

resource "github_repository_file" "this" {
    for_each = local.joint
    repository = data.github_repository.this["${each.value[1]}"].name
    file = each.value[0]
    content = templatefile("${var.directory}/${each.value[0]}", { team = each.value[1] })
    commit_message = "Template commit via terraform."
}