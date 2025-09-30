# Claude Code Configuration

<!-- Import shared agent-agnostic core -->
@import ../.ai/0_core/priit-personality.md
@import ../.ai/0_core/coding-standards.md
@import ../.ai/0_core/decision-framework.md
@import ../.ai/0_core/git-workflow.md
@import ../.ai/1_workflows/tdd-workflow.md
@import ../.ai/1_workflows/pre-commit-protocol.md

## Specialized Agents

I have a team of specialized AI agents in `.ai/2_agents/` for specific workflows.
When tackling complex tasks, suggest using the appropriate agent if one exists.
Agents handle their own code quality standards - don't duplicate those rules here.

Available agents:
- **Constructor Conway** (spring-hex-bootstrapper) - Hexagonal architecture project bootstrapper
- **Valdis the Translator** (jira-to-spec) - Translates Jira tasks into crystal-clear technical specs
- **Rex the Red-Green-Refactor** (spring-hex-tdd-developer) - TDD specialist for Spring Boot
- **Judge Dredd Code** (code-reviewer) - Rigorous code reviewer with zero tolerance for violations
- **Dr. Debugsworth McFixit** (test-fixer) - Test failure diagnostician and fixer extraordinaire

To use an agent with Claude Code:
```
"Use the Constructor Conway agent to bootstrap a new Spring Boot project"
"Delegate to Rex to implement this feature with TDD"
"Have Judge Dredd review this PR"
```

## Spec-Kit Integration

Follow the spec-driven development workflow when appropriate:
- Read about it: `../.ai/1_workflows/spec-driven-workflow.md`
- Templates: `../.ai/3_specs/`
- Alignment guide: `../.ai/0_core/spec-kit-alignment.md`

**When to use specs:**
- 🔴 Always Ask First actions - MUST have spec
- 🟡 Collaborative Actions - SHOULD have spec
- 🟢 Autonomous Actions - Can skip spec

**Spec locations:**
- Project specs: `specs/NNN-feature/` (spec.md, plan.md, tasks.md)
- Constitution: `constitution.md` at project root

## Claude-Specific Features

### Task Tool for Agent Delegation
Use the Task tool to delegate to specialized agents:
- Architecture decisions → architecture-agent (if available in project)
- Complex implementations → Use Rex the Red-Green-Refactor
- Code reviews → Use Judge Dredd Code
- Test fixes → Use Dr. Debugsworth McFixit

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

### Commit & PR Workflow
- Create commits with proper format (see git-workflow.md)
- Include Co-Authored-By: Claude <noreply@anthropic.com>
- Never use --no-verify flag
- Push branches with -u flag when needed
- Create PRs using gh pr create

### Code References
When referencing code, use `file_path:line_number` format:
```
The error handling is in src/services/auth.ts:45
```
