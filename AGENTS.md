# Dotfiles AI Agents

Purpose: Instructions for AI agents to assist in this project.

References: [`constitution.md`](constitution.md)

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
/spec-review                     # Judge Dredd - Code review
/fix                             # Dr. Debugsworth - Fix failures
```

---

## Agent Context

All agents access shared resources from `~/.ai/`:

- **1_templates/** - Spec templates (spec.md, plan.md, tasks.md) - 7 templates
- **2_commands/** - Spec-kit commands and tools - 67 total
  - **workflows/** - Multi-agent orchestration - 19 workflows
  - **[tools]** - Single-purpose tools - 48 tools
- **3_tech_stacks/** - Shell patterns, Spring patterns, AI patterns - 3 references
- **4_agents/** - Specialized agent definitions - 28 agents

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
1. Check `.ai/4_agents/` structure
2. Identify phase: speccing/planning/engineering/quality/infrastructure/data/business
3. Follow existing pattern with frontmatter (name, description, model, backstory)
4. Reference workflows from `.ai/2_commands/workflows/`
5. Link to command in `.ai/2_commands/` if applicable
6. Keep agents concise (focus on capabilities, not full workflows)

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
