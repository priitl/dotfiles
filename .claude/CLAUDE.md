# Claude Code Configuration

<!-- Import shared agent-agnostic core -->
@import ../.ai/0_core/priit-personality.md
@import ../.ai/0_core/coding-standards.md
@import ../.ai/0_core/decision-framework.md
@import ../.ai/1_workflows/git-workflow.md
@import ../.ai/1_workflows/tdd-workflow.md
@import ../.ai/1_workflows/pre-commit-protocol.md

## Specialized Agents

I have a team of specialized AI agents in `.ai/3_agents/` for specific workflows.
When tackling complex tasks, suggest using the appropriate agent if one exists.
Agents handle their own code quality standards - don't duplicate those rules here.

Available agents (organized by workflow phase):

**Speccing** (Requirements → Specs):
- **Archivist Aurora** (project-bootstrapper) - Generates AGENTS.md + constitution.md for projects
- **Valdis the Translator** (jira-to-spec) - Translates Jira tasks into technical specs
- **Socrates the Questioner** (conversational-spec) - Refines vague ideas into specs through dialogue

**Planning** (Specs → Implementation Plans):
- **Decomposer Dale** (planner) - Breaks specs into actionable plans and tasks

**Engineering** (Build Features):
- **Constructor Conway** (spring-hex-bootstrapper) - Hexagonal architecture project bootstrapper
- **Rex the Red-Green-Refactor** (spring-hex-tdd-developer) - TDD specialist for Spring Boot
- **Script Shepherd Shane** (dotfiles-developer) - Shell script & dotfiles specialist
- **Architect Anya** (ai-dotfiles-architect) - AI configuration architect

**Quality** (Review & Fix):
- **Judge Dredd Code** (code-reviewer) - Rigorous code reviewer with zero tolerance for violations
- **Dr. Debugsworth McFixit** (test-fixer) - Test failure diagnostician and fixer

To use agents with Claude Code:
```
"Bootstrap documentation for ~/Projects/my-project"  # Archivist Aurora
"Help me spec out migrating to Ansible"  # Socrates
"Create spec from Jira task PROJ-789"  # Valdis
"Create implementation plan for specs/PROJ-789/spec.md"  # Decomposer Dale
"Implement specs/PROJ-789/ using Shane"  # Shane (dotfiles) or Rex (Spring)
"Have Judge Dredd review this implementation"  # Judge Dredd
```

## Spec-Kit Integration

Follow the spec-driven development workflow when appropriate:
- Read about it: `../.ai/1_workflows/spec-driven-workflow.md`
- Templates: `../.ai/4_specs/`
- Alignment guide: `../.ai/0_core/spec-kit-alignment.md`

**When to use specs:**
- 🔴 Always Ask First actions - MUST have spec
- 🟡 Collaborative Actions - SHOULD have spec
- 🟢 Autonomous Actions - Can skip spec

**Spec locations:**
- Project specs: `specs/NNN-feature/` (spec.md, plan.md, tasks.md)
- Constitution: `constitution.md` at project root
- More context: `AGENTS.md` at project root

## Claude-Specific Features

### Task Tool for Agent Delegation
Use the Task tool to delegate to specialized agents:
- Requirements clarification → Use Socrates the Questioner
- Planning → Use Decomposer Dale
- Spring Boot implementation → Use Rex the Red-Green-Refactor
- Dotfiles implementation → Use Script Shepherd Shane
- AI config work → Use Architect Anya
- Code reviews → Use Judge Dredd Code
- Test failures → Use Dr. Debugsworth McFixit

### Todo Management (TodoWrite)
Use TodoWrite tool proactively for:
- Complex multi-step tasks (3+ steps)
- Non-trivial tasks requiring planning
- User-provided task lists
- Track progress and communicate status

**After completing TodoWrite tasks, persist to specs:**
```
"Update specs/NNN-feature/tasks.md with completed tasks from TodoWrite"
```

### Code References
When referencing code, use `file_path:line_number` format:
```
The error handling is in src/services/auth.ts:45
```
