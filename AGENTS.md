# Dotfiles AI Agents

Purpose: Instructions for AI agents to assist in this project.

References: [`constitution.md`](constitution.md)

---

## Agent Roles and Tasks

| Agent | Phase | Role | Invocation |
|-------|-------|------|------------|
| **Socrates the Questioner** | Speccing | Refines vague ideas into detailed specs | `/specify` or `/clarify` |
| **Valdis the Translator** | Speccing | Translates Jira tasks into technical specs | `/specify` |
| **Founding Father Franklin** | Speccing | Bootstraps project constitution | `/constitution` |
| **Decomposer Dale** | Planning | Breaks specs into actionable tasks | `/plan` or `/tasks` |
| **Inspector Insight** | Quality Gate | Analyzes specification consistency | `/analyze` |
| **Constructor Conway** | Engineering | Spring Boot project bootstrapper | `/bootstrap` |
| **Rex the Red-Green-Refactor** | Engineering | Spring Boot TDD specialist | `/implement` |
| **Script Shepherd Shane** | Engineering | Shell script & dotfiles specialist | `/implement` |
| **Architect Anya** | Engineering | AI configuration architect | `/implement` |
| **Judge Dredd Code** | Quality | Code reviewer | `/review` |
| **Dr. Debugsworth McFixit** | Quality | Test failure fixer | `/fix` |

---

## Invocation Instructions

**Spec-Driven Workflow Commands:**
```bash
/constitution                    # Franklin - Bootstrap project constitution
/specify "Add payment feature"   # Socrates/Valdis - Create specification
/clarify                         # Socrates - Refine vague requirements
/plan                            # Dale - Create implementation plan
/tasks                           # Dale - Generate task breakdown
/analyze                         # Insight - Analyze spec consistency
/bootstrap                       # Conway - Bootstrap Spring Boot project
/implement                       # Rex/Shane/Anya - Execute implementation
/review                          # Judge Dredd - Code review
/fix                             # Dr. Debugsworth - Fix failures
```

---

## Agent Context

All agents automatically load from `~/.ai/`:

- **0_core/** - Personality, standards, decision framework
- **1_workflows/** - TDD, git, pre-commit, spec-driven
- **2_templates/** - Spec templates (spec.md, plan.md, tasks.md)
- **3_commands/** - Spec-kit workflow commands
- **4_tech_stacks/** - Shell patterns, Spring patterns, AI patterns
- **5_agents/** - Specialized agent definitions

---

## Build and Test Commands

```bash
./install.sh                           # Install
bats tests/install.bats                # Run all tests
bats tests/install.bats -f "pattern"   # Specific test
shellcheck install.sh                  # Lint
```

**CI:** GitHub Actions runs macOS + Linux tests on every push.

---

## Development Tips

### Add Shell Script
1. Write BATS test: `tests/feature.bats`
2. Implement function
3. Run: `bats tests/feature.bats`
4. Lint: `shellcheck script.sh`

### Fix Failing Test
1. `bats tests/install.bats -f "test name"`
2. Fix implementation or test
3. Verify: `bats tests/install.bats`
4. Test idempotency (run twice)

### Add Agent
1. Check `.ai/5_agents/` structure
2. Identify phase: 0_speccing/1_planning/2_engineering/3_quality
3. Follow existing pattern (80-100 lines, concise)
4. Reference workflows from `.ai/1_workflows/`
5. Link to command in `.ai/3_commands/` if applicable

---

## Code Style Quick Reference

```bash
#!/usr/bin/env bash
set -euo pipefail  # MANDATORY

backup_file() {     # snake_case
    local file="$1" # snake_case
    [[ -z "$file" ]] && { echo "Error" >&2; return 1; }
}

readonly DEFAULT="value"  # UPPER_CASE
```

See [`constitution.md`](constitution.md) for complete standards.

---

## PR Checklist

**Tests:**
- [ ] BATS pass: `bats tests/install.bats`
- [ ] macOS CI passes
- [ ] Linux CI passes
- [ ] New code has tests
- [ ] Idempotency verified

**Quality:**
- [ ] shellcheck passes
- [ ] No `--no-verify` used
- [ ] Functions in `lib/` if reusable
- [ ] Error handling present
- [ ] Inputs validated

**Platform:**
- [ ] Works on macOS
- [ ] Works on Linux
- [ ] Uses `uname -s` detection

**Git:**
- [ ] Commit explains "why"
- [ ] Pre-commit hooks passed
- [ ] Atomic commits

---

## Environment Setup Notes

**Prerequisites:** macOS/Linux, Git 2.40+, one AI tool

```bash
git clone <repo-url> ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh
source ~/.zshrc
```

**Install BATS:**
```bash
# macOS
brew install bats-core bats-support bats-assert

# Linux
git clone https://github.com/bats-core/bats-core.git
cd bats-core && ./install.sh /usr/local
```

---

## Decision Framework

🟢 **Do:** Fix lint/tests, add coverage, docs, typos
🟡 **Propose:** Refactoring, features, architecture
🔴 **Ask:** Security, deletion, integrations, business logic

See [`constitution.md`](constitution.md) Article IV for details.
