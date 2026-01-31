# AGENTS (OpenTofu / infra/)

This file defines conventions for the infrastructure-as-code content under `infra/`.
OpenTofu (`tofu`) is the preferred CLI, but the configuration is also compatible with
the Terraform CLI (`terraform`) as a drop-in replacement when necessary.

Read the repository root `AGENTS.md` first for project-wide expectations, then use this
document for all OpenTofu/Terraform-specific behavior.

## Scope and Layout

- All `.tf` files currently live directly under `infra/`:
  - `infra/main.tf` (root module entry point; currently placeholder).
  - `infra/variables.tf` (input variable definitions).
  - `infra/output.tf` (output definitions).
- `infra/README.md` should describe the purpose of the infrastructure, modules, and
  any environment- or workspace-specific details. Keep it up to date.

## Tooling and Commands

All commands below assume you run them from within `infra/` unless noted otherwise.

### Initialization
- `tofu init` initializes the working directory for OpenTofu.
- If OpenTofu is not available and you must use Terraform, run `terraform init`
  instead. Treat both as mutually exclusive in a given environment.

### Formatting and basic validation
- `tofu fmt` formats all HCL files according to standard style. Do this before
  committing changes.
- `tofu validate` performs a basic static validation of the configuration.

From the repository root, the equivalent Terraform-style commands are:

- `terraform -chdir=infra fmt -write=true`
- `terraform -chdir=infra validate`

### Running a Single Check (Targeted Verification)
- After editing one or more `.tf` files, run `tofu validate` in `infra/` as the
  minimum verification step.
- For a more thorough dry-run on the current configuration, run `tofu plan`
  (or `terraform plan` if OpenTofu is not available) and review the proposed
  changes before applying anything.

There is no dedicated unit test harness yet; `validate` and `plan` are the
canonical "single test" equivalents for this directory.

### Planning and applying
- Prefer to run `tofu plan` with an explicit output file, such as
  `tofu plan -out=tfplan`, and share the plan file or its summary with
  reviewers instead of running `apply` directly.
- Do not run `tofu apply` or `terraform apply` against shared or production
  infrastructure without explicit human approval and a linked issue or ticket.
- For experiments, use isolated workspaces or backends (for example,
  `tofu workspace new dev-<name>`) so state is not shared unintentionally.

## Style and Structure

- Always rely on `tofu fmt`/`terraform fmt` for formatting; avoid manual
  alignment or spacing tweaks that fight the formatter.
- Use `snake_case` for variable, local, and output names.
- Group configuration logically: providers, backends, variables, locals,
  resources, data sources, and outputs should be easy to locate.
- Add short comments above non-trivial resources, variables, and outputs to
  explain intent, not implementation details.

## Security and Secrets

- Never hard-code credentials, tokens, or private data directly in `.tf` files.
- Use input variables, environment variables, or external secret stores for
  sensitive values. Document the expected inputs in `infra/README.md`.
- If you must include example values, prefix variable names with `example_`
  and make them obviously non-sensitive.

## Diagnostics and Debugging

- Use `TF_LOG=DEBUG` and `TF_LOG_PATH=tofu-debug.log` temporarily when
  investigating provider issues. Do not commit log files.
- When a plan or apply behaves unexpectedly, capture the exact command and
  any relevant environment variables and record them in `infra/README.md` or
  an associated issue.

## Review Checklist for infra/ Changes

1. Run `tofu fmt` (or `terraform fmt`) in `infra/` and ensure there are no
   formatting changes left unstaged.
2. Run `tofu validate` after your edits to confirm the configuration remains
   syntactically and semantically valid.
3. For behavior-changing updates, run `tofu plan` and review the proposed
   changes with a human reviewer before any `apply`.
4. Update `infra/README.md` with any new modules, inputs, or outputs you add
   so future agents understand the intent of the infrastructure.
