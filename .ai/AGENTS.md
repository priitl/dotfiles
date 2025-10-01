# AI Agents Guide (Template)

<!--
Context-Optimized Declaration:
This is an agents.md compliant template showing HOW to structure agent guides.
Copy to project root and customize for your specific agents.
-->

## Metadata
- **Updated by:** Architect Anya
- **Date:** 2025-10-01
- **Reason:** Template reduction per agents.md spec, remove agent listings

## Purpose
Template for creating agents.md compliant agent guides. Shows structure for HOW to use agents. Copy this to your project root and customize.

## Template Structure

### 1. Agent Discovery Section
Show HOW to discover agents in your project:

```markdown
## Agent Discovery

### Available Agents
Agents are organized in `.ai/3_agents/` by [your-organization]:

**[Phase/Category Name]:**
- `[agent-file].md` - [Agent Name] - [One-line description]

### Finding Agent Details
```bash
# List all agents
ls .ai/3_agents/*/

# Read agent definition
cat .ai/3_agents/[phase]/[agent-name].md
```
```

### 2. Agent Invocation Section
Show HOW to invoke agents:

```markdown
## Agent Invocation

### [Your AI Tool] Method
```
"[User request example]" → [Agent Name]
```

### Direct Agent Reading
1. Read agent definition: `cat .ai/3_agents/[agent].md`
2. Follow agent's process
3. Load required context
```

### 3. Workflow Coordination Section
Show HOW agents work together:

```markdown
## Workflow Coordination

### Standard Flow
```
[Phase 1 Agent]
    ↓
[Artifact created]
    ↓
[Phase 2 Agent]
```

### Handoff Points
- **[Phase] → [Phase]:** [Agent] reads [input], creates [output]
```

### 4. Context Loading Section
Show WHAT agents auto-load:

```markdown
## Agent Context Loading

### What Agents Auto-Import
- `constitution.md` - Project values
- `.ai/0_core/*.md` - Core patterns

### What You Must Load
- Agent definition
- Relevant workflows
- Tech stack context
```

### 5. Anti-Patterns Section

```markdown
## Anti-Patterns

**DON'T:**
- ❌ Duplicate agent instructions in AGENTS.md
- ❌ Mix WHY/WHAT with HOW

**DO:**
- ✅ Discover agents via filesystem
- ✅ Read agent.md for latest instructions
```

## Key Principles

1. **HOW not WHY/WHAT**
   - AGENTS.md = practical usage guide
   - constitution.md = values and vision

2. **Discovery over Listing**
   - Show HOW to find agents (`ls .ai/3_agents/`)
   - Don't list all details (they change)
   - Point to source of truth (agent.md files)

3. **Tool-Agnostic Base**
   - Core instructions work across AI tools
   - Add tool-specific sections as needed

4. **Workflow Focused**
   - Emphasize agent coordination
   - Show handoff points clearly

5. **Context Clarity**
   - Explicit about what's auto-loaded
   - Clear about what must be read

## Customization Checklist

When adapting this template:

- [ ] Add metadata (updated by, date, reason)
- [ ] Add context-optimized declaration at top
- [ ] List your agents by relevant organization
- [ ] Describe your agent invocation method
- [ ] Map your workflow with handoff points
- [ ] Document what your agents auto-import
- [ ] Keep file under 150 lines
- [ ] Remove this customization section from final version

## Size Guidelines

**Target:** 100-150 lines for project-specific AGENTS.md

**Token efficiency:**
- Focus on HOW to use (not full agent descriptions)
- Point to source files (don't duplicate)
- Use examples over exhaustive lists
- Keep workflow diagrams ASCII-simple

## Specialized AI Agents

This project uses specialized agents from `~/.ai/3_agents/`:

**Workflow: Spec → Plan → Build → Verify**

1. **Speccing** - Use when requirements unclear:
   - Socrates: Refines vague ideas into specs
   - Valdis: Translates Jira to specs

2. **Planning** - Use after spec complete:
   - Decomposer Dale: Creates implementation plan

3. **Engineering** - Use for implementation:
   - Rex: Spring Boot with TDD
   - Shane: Shell scripts with BATS
   - Anya: AI configuration
   - Conway: Bootstrap Spring projects

4. **Quality** - Use for review:
   - Judge Dredd: Code review
   - Dr. McFixit: Fix test failures

**Invoking agents (Claude Code):**
```
"Use Socrates to help me spec this feature"
"Have Decomposer Dale create a plan from specs/001/"
"Use Rex to implement this with TDD"
"Have Judge Dredd review the code"
```

See `~/.ai/3_agents/` for detailed agent definitions.

---

*This template shows structure. Customize all sections for your project.*
