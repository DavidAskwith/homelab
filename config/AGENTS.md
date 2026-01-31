<!--# cspell: ignore SSOT CMDB -->
# AGENTS (Ansible / config/)

This file captures all Ansible-specific practices for content under `config/`. Read the
repository root `AGENTS.md` first for project-wide conventions, then use this document as
the single source of truth for Ansible behavior.

All practices and instructions described by the upstream Ansible Creator agents
documentation must be followed:

https://raw.githubusercontent.com/ansible/ansible-creator/refs/heads/main/docs/agents.md

## Scope and Layout

- All playbooks, inventories, and related configuration live under `config/`.
- When present, collections live under `config/collections/ansible_collections/homlab/config/`.
- The default inventory is `config/inventory/hosts.yml`.
- The primary configuration file is `config/ansible.cfg`.

## Setup & Environment Entry Points

- Recommended: `cd config` before running any `ansible-playbook` or `ansible-navigator`
  commands so relative paths in `ansible.cfg` resolve correctly.
- Alternative: run from the repository root but set `ANSIBLE_CONFIG=config/ansible.cfg`
  and use fully qualified paths such as `config/site.yml` and
  `config/inventory/hosts.yml`.
- `ansible.cfg` already sets `inventory`, `host_vars_inventory`, `group_vars_inventory`,
  `verbosity`, and `remote_user`. Do not override these casually; if you must, document
  why in a nearby README and, if appropriate, here.

## Build / Lint / Test Commands

All commands below assume you run them from within `config/` unless noted otherwise.

### Install collections
- If `collections/requirements.yml` is present, run
  `ansible-galaxy collection install -r collections/requirements.yml` to install or
  update required collections. Run whenever `collections/requirements.yml` changes or
  after a clean checkout.

### Smoke tests / full playbook runs
- `ansible-playbook site.yml --check --diff` runs a dry-run of the canonical
  configuration against the default inventory configured in `ansible.cfg`.
- `ansible-playbook linux_playbook.yml --check --diff` and
  `ansible-playbook network_playbook.yml --check --diff` exercise OS- and
  network-specific entry points.

From the repository root, the equivalent commands are:

- `ANSIBLE_CONFIG=config/ansible.cfg ansible-playbook config/site.yml --check --diff`
- `ANSIBLE_CONFIG=config/ansible.cfg ansible-playbook config/linux_playbook.yml --check --diff`
- `ANSIBLE_CONFIG=config/ansible.cfg ansible-playbook config/network_playbook.yml --check --diff`

### Linting
- `ansible-lint config` is the primary lint job and matches the CI workflow
  configured in `.github/workflows/tests.yml`.
- To scope linting, point `ansible-lint` directly at paths, for example:
  - `ansible-lint inventory/group_vars/all.yml`
  - `ansible-lint collections/ansible_collections/homlab/config/roles/run/tasks/main.yml`

### Running a Single Test (Targeted Verification)
- For a single playbook: `ansible-playbook argspec_validation_plays.yml -i
  inventory/argspec_validation_inventory.yml -e message=hello --check --diff`
  validates the argument-spec validation examples using the sample inventory and
  required variables.
- For a single role:
  - Create a small test playbook under the role, for example
    `collections/ansible_collections/homlab/config/roles/run/tests/playbook.yml` that
    imports the role and targets `hosts: localhost` with `connection: local`.
  - Run `ansible-playbook collections/ansible_collections/homlab/config/roles/run/tests/playbook.yml --check --diff`.
- For lint-only verification of a single file or role, run `ansible-lint` on that
  path, e.g. `ansible-lint collections/ansible_collections/homlab/config/roles/run`.

## Coding Standards and Style

### YAML formatting
- Use two-space indentation everywhere; tabs are forbidden.
- Keep lines at or below roughly 100 characters where practical.
- Quote strings that could be misinterpreted as booleans or numbers (for example
  `version: "011"`, `ports: "12345"`). Use bare `true`/`false` only when you
  intentionally want booleans.
- Use `|` for multiline text that must preserve newlines and `>` for wrapped text
  that should collapse to a single line at runtime.
- Ensure every YAML file starts with `---` and ends with a trailing newline.

### Imports and includes
- Prefer `import_playbook` and `import_tasks` for static orchestration so that
  structure is visible at parse time.
- Use `include_tasks` only when dynamic behavior (for example, conditional imports)
  is required.
- Keep imports near the top of a playbook or task file, grouped by type
  (roles first, then tasks). Separate imports from ad-hoc tasks with a blank line.

### Module usage and task naming
- Every task must have a clear `name` using imperative verbs, such as
  `- name: Deploy web configuration`.
- Prefer fully qualified collection names like `ansible.builtin.copy` instead of
  bare module names, especially in shared roles and libraries.
- Avoid `command`/`shell` unless there is no suitable module. When you must use
  them, add `changed_when` and `check_mode`-friendly guards.
- Prefer small, focused tasks instead of large, multi-purpose ones; this improves
  idempotency and reviewability.

### Variables, types, and naming conventions
- Use `snake_case` for all variable names (`load_balancer_ip`, not `lbIp`).
- Define default values in `defaults/main.yml` for each role; use `vars/` only
  when higher precedence is absolutely required.
- Avoid `register` unless the value is actually used. Remove temporary registers
  before merging or gate them with verbosity checks.
- Prefer lists and dictionaries over comma-separated strings; when structures
  become complex, consider using YAML blocks for clarity.

### Roles and task structure
- Keep the standard role layout: `tasks/`, `handlers/`, `files/`, `templates/`,
  `defaults/`, and `vars/`. Create empty directories when you know future work
  will populate them.
- Start every tasks file with `---` and group related tasks with blank lines.
- Handlers should have descriptive names and, when shared, use explicit
  `listen` keys so they can be triggered from multiple roles.

### Error handling, idempotency, and recovery
- Use `block` / `rescue` / `always` blocks when a group of tasks shares common
  error handling or cleanup behavior.
- Use `failed_when` to refine error conditions but avoid hiding real failures.
- Guard non-idempotent actions with `creates`, `removes`, or explicit state
  checks combined with `when:` conditions.
- Only use `ignore_errors: true` with an accompanying comment and, when
  practical, a `register` + follow-up assertion so that issues are visible.

### Testing, tags, and automation
- Tag logical groups of tasks (for example, `tags: deploy_config`) so you can
  run targeted subsets with `ansible-playbook ... -t deploy_config`.
- Reserve special tags like `ci`, `smoke`, and `cleanup` for automation hooks.
- When adding tests for a role, put them under `tests/` inside the role with
  playbooks that target `localhost` using `connection: local`.

### Logging and observability
- Use `ansible.builtin.debug` only when necessary to understand complex logic.
  Guard noisy debug output behind `when: ansible_verbosity | int > 2`.
- Mark tasks that handle secrets with `no_log: true` to avoid leaking
  credentials into logs.
- When debugging idempotency or logic issues, temporarily set
  `ANSIBLE_STDOUT_CALLBACK=debug` and remove or reset it when finished.

### Inventory and secrets
- Prefer to keep Vault password files and similar secrets outside the
  repository. Reference them with `ANSIBLE_VAULT_PASSWORD_FILE` or external
  secret stores.
- Inventory and variable files under `inventory/`, `group_vars/`, and
  `host_vars/` should avoid plaintext secrets. If a non-sensitive sample value
  is required, prefix the variable name with `example_` and document its use in
  a README.
- Use `ansible-inventory --graph` after changing inventory layout to confirm
  hosts and groups resolve as expected.

## Troubleshooting and debugging

- Use `ansible-playbook ... --check --diff -vvv` on a narrow scope (for example,
  a single playbook or role test) when you need detailed module output.
- Limit `ansible.builtin.setup` facts gathering to the minimum required by using
  `gather_subset` filters; this speeds up repeated runs.
- Keep a local copy of `ansible-creator.log` (generated by the tooling) when
  debugging template or generator issues and consult it before filing upstream
  bugs.

## Review checklist for Ansible changes

1. Run `ansible-lint` on the paths you modified (or on all of `config/` for
   broad changes).
2. Run at least one `ansible-playbook ... --check --diff` command that exercises
   the new or changed behavior.
3. Ensure new roles or major changes have updated READMEs with example usage
   and any important variables documented.
4. Confirm that inventory and secret-handling conventions remain consistent
   with the guidelines above.
