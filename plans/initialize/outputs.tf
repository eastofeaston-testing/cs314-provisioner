output "teams" {
    value = join("\n", [for i in module.team : i.name])
}