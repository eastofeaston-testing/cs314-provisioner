variable "team_id" {
  type    = string
  default = ""
}

variable "attach_team" {
  type    = bool
  default = false
}

variable "members" {
  type    = set(string)
  default = [""]
}

variable "add_members_variable" {
  type    = bool
  default = false
}

variable "name" {
  type = string
}

variable "visibility" {
  type    = string
  default = "private"
}