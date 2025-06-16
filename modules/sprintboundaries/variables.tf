variable "sprint_count" {
  type    = number
  default = 5
}

variable "sprint_open_days" {
  type    = number
  default = 17
}

variable "sprint_buffer_days" { # releases are locked during buffer window
  type    = number
  default = 4
}

variable "break_week" { # break week, e.g. spring break, adds add'l 7 days to sprint.
  type    = number
  default = 3
}

variable "sprint_start_time" {
  type    = string
  default = "08:00:00"
}

variable "sprint_end_time" {
  type    = string
  default = "18:59:00"
}

variable "sprint_start_day" {
  type    = string
  default = "2025-01-20"
}