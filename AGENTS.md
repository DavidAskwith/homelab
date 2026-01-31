# AGENTS.md

This repository is a curated Ansible configuration and infrastructure project. Every human and agent working here must stay aligned with the upstream Ansible Creator guidance (https://raw.githubusercontent.com/ansible/ansible-creator/refs/heads/main/docs/agents.md) while also honoring the repository-specific policies below.

## Scope of This File

- This top-level file only documents project-wide conventions that apply across Ansible configuration and infrastructure code.
- Ansible-specific instructions live in `config/AGENTS.md`.
- OpenTofu/Terraform-specific infrastructure instructions live in `infra/AGENTS.md`.
- When in doubt, read this file first, then consult the most relevant technology-specific file.

## Project Layout and Ownership

- `config/` owns the majority of Ansible playbooks, inventories, collections, and supporting YAML such as `ansible.cfg`, `ansible-navigator.yml`, and the `devfile` used by container-based dev environments. See `config/AGENTS.md` for details.
- `infra/` contains OpenTofu/Terraform scaffolding for the physical or virtual laboratory infrastructure (currently placeholders). Treat it as a separate IaC subsystem and follow `infra/AGENTS.md`.
- When present, collection content lives under `config/collections/ansible_collections/homlab/config/` and follows the Ansible collection layout expected by `ansible-galaxy` and `ansible-lint`.
- Version control is centralized at the repository root; do not relocate this `AGENTS.md` from `/home/david/repos/homelab/`.

## Cursor & Copilot Instructions

- No `.cursor/` or `.cursorrules` directories exist in this repository.
- No `.github/copilot-instructions.md` file is present.
- There are therefore no additional Cursor or GitHub Copilot policy layers beyond what is written in this `AGENTS.md` and the technology-specific `AGENTS.md` files in `config/` and `infra/`.

## Common Git & Workflow Practices

- Keep commits focused; aim for one logical change per commit so reviewers can understand intent.
- Prefer opening feature branches off `main`; avoid force-pushing branches that others may be using.
- Before opening a pull request, run the linters and tests described in `config/AGENTS.md` and `infra/AGENTS.md` for any areas you touched.
- Use descriptive commit messages that emphasize intention rather than implementation (for example, `document playbook orchestration` instead of `misc updates`).
- Do not rewrite history on `main`; follow the standard GitHub pull-request workflow.

## Cross-Cutting Documentation Expectations

- When you add new capabilities or workflows, update the relevant technology-specific `AGENTS.md` (`config/` or `infra/`) rather than overloading this root file.
- Keep READMEs up to date: every new role, collection, or infrastructure module should have at least a short Purpose and Usage section.
- When documenting tests, always include the exact commands needed to reproduce them (including environment variables such as `ANSIBLE_CONFIG`, `ANSIBLE_STDOUT_CALLBACK`, or `TF_LOG`).
- Mention any changes to `AGENTS.md` (root or technology-specific) in the nearest README so future agents know when and why guidance evolved.

## Security & Secret-Handling Principles

- Never commit real credentials, private keys, tokens, or cloud account details to this repository.
- Prefer external secret stores or local, unversioned files (for example, Vault password files or environment variable exports) over plaintext values in tracked YAML or HCL.
- Use explicit `example_`-prefixed variable names for any non-sensitive sample secrets you must include for tests or documentation.
- Treat inventory-like configuration, variable files, and Terraform/OpenTofu variables as potentially sensitive even in test environments.
- See `config/AGENTS.md` for Ansible Vault and inventory-specific practices, and `infra/AGENTS.md` for infrastructure variable and backend guidance.

## Collaboration, Reviews, and Communication

- Align on the upstream Ansible Creator agents guidance first, then apply the more specific rules from `config/AGENTS.md` or `infra/AGENTS.md` as appropriate.
- During reviews, check that new or modified automation includes an obvious way to run linting and a targeted test (for example, a dedicated playbook or `tofu validate`/`plan` path) and that the commands are documented.
- Prefer small, reviewable pull requests. If a change must be large, add a short design note or checklist to the description so reviewers understand scope and risk.
- Capture important operational decisions (for example, backend choices, inventory structure, or state layout) in the appropriate README alongside a link back to the relevant `AGENTS.md` section.

## When in Doubt

- If guidance seems contradictory between this file and a technology-specific `AGENTS.md`, prefer the more specific file and add a clarifying note there rather than guessing.
- If you are still unsure after reading all three `AGENTS.md` files, leave a small `TODO` comment in the relevant code or playbook and record the open question in the closest README.
- When introducing a new tool, framework, or workflow, add a short section to the appropriate `AGENTS.md` so future agents have a single place to look for expectations.
