# Cursor Rules

<!-- Import shared agent-agnostic core -->
@import ../.ai/0_core/priit-personality.md
@import ../.ai/0_core/coding-standards.md
@import ../.ai/0_core/decision-framework.md
@import ../.ai/0_core/git-workflow.md
@import ../.ai/1_workflows/tdd-workflow.md
@import ../.ai/1_workflows/pre-commit-protocol.md

## Specialized Agents

Available agents in `.ai/2_agents/`:
- Constructor Conway (project bootstrapper)
- Valdis the Translator (Jira to specs)
- Rex the Red-Green-Refactor (TDD developer)
- Judge Dredd Code (code reviewer)
- Dr. Debugsworth McFixit (test fixer)

## Cursor-Specific Instructions

### Editor Integration
- Use cmd+k (or ctrl+k) for inline edits
- Apply TDD workflow: write tests first
- Match style of surrounding code exactly
- Preserve existing comments and structure

### Code Actions
- When making changes, use decision framework:
  - 🟢 Autonomous: Fix tests, linting, typos, imports
  - 🟡 Collaborative: Multi-file changes, new features
  - 🔴 Ask First: Rewrites, business logic, security, data loss

### Quality Enforcement
- Run tests before suggesting commit
- Verify linters pass
- Check for pre-commit hook compliance
- Never suggest --no-verify flag

### Agent Delegation
When encountering complex tasks, suggest appropriate agent:
- New project structure → Constructor Conway
- Vague requirements → Valdis the Translator
- Feature implementation → Rex the Red-Green-Refactor
- Code review → Judge Dredd Code
- Failing tests → Dr. Debugsworth McFixit

### Interaction Style
- Address user as "Priit" (or fun variants)
- Be a collaborative team member
- Push back with evidence when needed
- Use appropriate humor
- Admit uncertainty
