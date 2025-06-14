# Proof-of-concept CS314 Terraform Provisioner / All-in-One Ops Tool

This is a proof-of-concept provisioner for CS314 at Colorado State University.

## Why this over current methods?

The current method relies on docs that get outdated as soon as new tools are written. Rather than digging through code, common needs can be listed. Additionally, a powerful local state can keep track of drift and apply changes as needed, e.g. team switches.

Current scripts can be added as legacy options if maintaining state via Terraform is impossible.

## Prerequisites

- terraform
- jq
- git
- gh
- fzf

## How to run

`sh run.sh`

This will provide a sample of runs that can be used.

## Further explanation

Benefits of using Terraform over other uses:
- Extremely power state system can detect drift.
  - E.g., blowing up a team only requires replacing the
- Templated data support, filled via map.
  - Easily set t## and port numbers on deploy.  
- Versioned provider ecosystem. 

Downsides of using Terraform:
- State can be challenging to share.
  - Without state sharing, there is a risk of clobbering. However, this *should* fail if no state exists, based on testing.  
  - Two options: only one person does the provisioning (bus-factor bottleneck), cloud storage of the state (minimal, non-zero cost).
    - Common cloud options: HCP, S3 bucket
- `terraform destroy` might rm -rf the entire semester
  - Failing exits. A [destroy-time provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax#destroy-time-provisioners) might be a good safety lock.  

To-do's:
- [ ] Add organizational variable for Sprint start/finish times.
- [ ] Add [GitHub Projects](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_project).
- [ ] Add 't50' consideration — solo jail for toxic team members used FA24/SP25.
   - **Currently would clobber all other teams' projects.**
     - Naive outputs used for bulk `git push --force origin main`.
   - Diff between terraform output pre-plan and post-apply should be able to selectively build those repos.
- [ ] Investigate Slack providers
  - Favorable outlook. 
  - Initial look at [tfslack/slack](https://registry.terraform.io/providers/tfstack/slack/latest/docs) appears to have the tools in place for something sensible. Detect emails in the Slack —> assign to teams.
- [ ] Investigate Postman providers
  - Unfavorable outlook.
  - Nothing seems to easily link this. If this is the only manual thing, so be it.
  - Provider developers have run into the same issue I have — the Postman API is not very good.
