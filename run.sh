#!/bin/bash
# ! Requires real tabs !

set -e

function check_prereq {
	if ! command -v "$1" &> /dev/null; then
		echo "$1 is required, but it's currently missing. Please install it."
		exit 1
	fi
}

function check_gh {
	if ! gh auth status > /dev/null 2>&1; then
		echo "GitHub is not authenticated. Please login via gh auth login or via token export."
		exit 1
	fi
}

function setrepos {
	cd ./plans/initialize
	terraform init
	terraform plan
	terraform apply
	teams="$(terraform output -raw teams)"
	cd "$home"
}

function pushbulk {
	cd "$1/bulk"
	rm -rf .git
	for t in $teams; do
		git init
		git remote add origin "https://github.com/$GITHUB_OWNER/$t.git"
		git add .
		git commit -m "Initial data."
		git push --force origin main
		rm -rf .git
	done
	cd "$home"
}

function pushtpls {
	cd ./plans/push_templates
	terraform init
	export TF_VAR_directory="$1/templates"
	export TF_VAR_teams="$teams"
	terraform plan
	terraform apply
	cd "$home"
}

function writerepos {
	directory="$(realpath "$1")"
	pushbulk "$directory" 
	pushtpls "$directory"
}

check_prereq git        # git
check_prereq fzf        # fuzzy find
check_prereq jq         # cli json parser
check_prereq terraform  # iac platform
check_prereq gh         # github command line
check_gh

export GITHUB_OWNER="$(cat ./data/configuration.json | jq -r '.org')"
export TF_VAR_students_csv="$(realpath ./data/students.csv)"
export TF_VAR_config_json="$(realpath ./data/configuration.json)"
home="$(pwd)"

choice=$(fzf <<-EOF
			push team reassignments
			initialize the student repositories
			publish the full student repositories
			terraform destroy
			EOF
			)

case "$choice" in
	"initialize the student repositories")
		setrepos
		writerepos "./repositories/initial"
		;;
	"publish the full student repositories")
		setrepos
		writerepos "./repositories/full"
		;;
	"push team reassignments")
		setrepos
		;;
	"terraform destroy")
		cd ./plans/initialize
		terraform destroy
		;;
	*)
		echo "No choice selected, exiting..."
		exit 1
		;;
esac

echo "Complete!"