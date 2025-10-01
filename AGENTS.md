# AI Agents Guide

<!--
Context-Optimized Declaration:
This is an agents.md compliant file focusing on HOW to use agents.
See constitution.md for project values (WHY) and vision (WHAT).
-->

## Metadata
- **Updated by:** Architect Anya
- **Date:** 2025-10-01
- **Reason:** agents.md spec compliance, remove duplication, add metadata

## Purpose
Practical guide for AI assistants on HOW to use specialized agents in this dotfiles repository. Focuses on discovery, invocation, and workflow coordination.

## Agent Discovery

### Available Agents
Agents are organized in `.ai/3_agents/` by workflow phase:

**Speccing** (Requirements → Specs):
- `conversational-spec.md` - Socrates the Questioner - Refines vague ideas through dialogue
- `jira-to-spec.md` - Valdis the Translator - Translates Jira tasks into technical specs

**Planning** (Specs → Implementation Plans):
- `planner.md` - Decomposer Dale - Breaks specs into actionable plans and tasks

**Engineering** (Build Features):
- `spring-hex-bootstrapper.md` - Constructor Conway - Hexagonal architecture bootstrapper
- `spring-hex-tdd-developer.md` - Rex the Red-Green-Refactor - TDD for Spring Boot
- `dotfiles-developer.md` - Script Shepherd Shane - Shell scripts & dotfiles specialist
- `ai-dotfiles-architect.md` - Architect Anya - AI configuration architect

**Quality** (Review & Fix):
- `code-reviewer.md` - Judge Dredd Code - Rigorous code reviewer
- `test-fixer.md` - Dr. Debugsworth McFixit - Test failure diagnostician

### Finding Agent Details
```bash
# List all agents
ls .ai/3_agents/*/

# Read agent definition
cat .ai/3_agents/2_engineering/dotfiles-developer.md
```

## Agent Invocation

### Claude Code Task Tool
Delegate to specialized agents using the Task tool:

```
"Create spec from conversation about Ansible migration" → Socrates
"Translate PROJ-789 to technical spec" → Valdis
"Create implementation plan for specs/PROJ-789/spec.md" → Dale
"Implement specs/PROJ-789/ using Shane" → Shane (dotfiles)
"Have Judge Dredd review src/install/brew.sh" → Dredd
"Fix failing test: test_git_config_valid" → Dr. Debugsworth
```

### Direct Agent Reading
When YOU need to act as an agent:

1. **Read the agent definition:**
   ```bash
   cat .ai/3_agents/2_engineering/dotfiles-developer.md
   ```

2. **Follow the agent's process**
3. **Load required context** (agent imports core patterns)

## Workflow Coordination

### Standard Flow
```
User Request
    ↓
Socrates/Valdis (if spec needed)
    ↓
specs/NNN-feature/spec.md created
    ↓
Decomposer Dale
    ↓
specs/NNN-feature/plan.md & tasks.md created
    ↓
Shane/Rex/Anya (implementation)
    ↓
Judge Dredd (review)
    ↓
Dr. Debugsworth (if tests fail)
```

### Handoff Points
- **Spec → Plan:** Dale reads spec.md, creates plan.md + tasks.md
- **Plan → Build:** Shane/Rex reads plan.md + tasks.md, implements
- **Build → Review:** Dredd reads implementation, issues approval/rejection
- **Review → Fix:** Dr. Debugsworth reads failures, implements fixes

### When to Skip Agents
Per `.ai/0_core/decision-framework.md`:
- 🟢 **Autonomous:** Simple changes (typo fixes, comments) - proceed directly
- 🟡 **Collaborative:** Medium complexity (refactoring) - use agents
- 🔴 **Always Ask:** Breaking changes, architecture - always use agents

## Agent Context Loading

### What Agents Auto-Import
All agents automatically load:
- `constitution.md` - Project values and vision
- `.ai/0_core/priit-personality.md` - Communication style
- `.ai/0_core/coding-standards.md` - Code quality standards
- `.ai/0_core/decision-framework.md` - When to ask vs. act

### What You Must Load
When acting as an agent, explicitly read:
- Agent definition: `.ai/3_agents/[phase]/[agent-name].md`
- Relevant workflows: `.ai/1_workflows/*.md`
- Tech stack context: `.ai/2_tech_stacks/tech-stack-[domain].md`
- Task spec: `specs/[TASK_ID]/*.md`

## Anti-Patterns

**DON'T:**
- ❌ Duplicate agent instructions in AGENTS.md (read from `.ai/3_agents/`)
- ❌ Mix WHY/WHAT (constitution.md) with HOW (AGENTS.md)
- ❌ Skip quality checklists when acting as agent
- ❌ Assume context - always verify what agent imports

**DO:**
- ✅ Discover agents via filesystem (`ls .ai/3_agents/`)
- ✅ Read agent.md files for latest instructions
- ✅ Follow agent's restrictions absolutely
- ✅ Update specs/tasks.md after completing work

## Tool-Specific Notes

### Claude Code
- Use Task tool for agent delegation
- Use TodoWrite for complex multi-step tasks
- Persist completed todos to specs/tasks.md

### Other AI Tools (Copilot/Gemini/Cursor)
- Read agent.md files directly (agent-agnostic markdown)
- Follow agent process manually
- Maintain same quality standards

## References

**For detailed processes, see:**
- `.ai/1_workflows/spec-driven-workflow.md` - When to use specs
- `.ai/1_workflows/tdd-workflow.md` - Red-Green-Refactor process
- `.ai/1_workflows/pre-commit-protocol.md` - Git commit flow

**For tech context:**
- `.ai/2_tech_stacks/` - Domain-specific technology guides

---

*This file explains HOW to use agents. See `constitution.md` for WHY we have these agents and WHAT values guide them.*
