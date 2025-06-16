locals {
  range_sprints   = { for i in range(var.sprint_count) : i => i }
  base_start      = join("", [var.sprint_start_day, "T", var.sprint_start_time, "Z"])
  base_end        = join("", [var.sprint_start_day, "T", var.sprint_end_time, "Z"])
  delta           = var.sprint_open_days + var.sprint_buffer_days
  zero_break_week = var.break_week - 1
}

resource "time_offset" "starts" {
  for_each     = local.range_sprints
  base_rfc3339 = local.base_start
  offset_days  = each.value > local.zero_break_week ? each.value * local.delta + 7 : each.value * local.delta
}

resource "time_offset" "ends" {
  for_each     = local.range_sprints
  base_rfc3339 = local.base_end
  offset_days  = each.value >= local.zero_break_week ? each.value * local.delta + 7 + var.sprint_open_days : each.value * local.delta + var.sprint_open_days
}

resource "github_actions_organization_variable" "this" {
  variable_name = "sprints"
  visibility    = "private"
  value         = join("\n", [for i in local.range_sprints : join(",", [i + 1, formatdate("YYYY.MM.DD.hh.mm", time_offset.starts[i].rfc3339), formatdate("YYYY.MM.DD.hh.mm", time_offset.ends[i].rfc3339)])])
}