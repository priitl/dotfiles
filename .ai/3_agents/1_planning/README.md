# Planning Agents

Agents responsible for analyzing specifications and creating implementation plans.

## Available Agents

### 🧩 Decomposer Dale
**File:** `planner.md`
**Purpose:** Planning specialist who breaks specifications into actionable implementation plans and tasks
**When to use:** After Valdis creates spec.md, before builders start implementation
**Tech-agnostic:** Works with any tech stack via constitution.md and tech-stack-{name}.md files

**Workflow:**
1. Reads `specs/[TASK_ID]/spec.md` (from Valdis)
2. Reads `constitution.md` to discover tech stack
3. Loads appropriate `.ai/2_tech_stacks/tech-stack-{name}.md`
4. Creates `plan.md` (architecture, phases, risks)
5. Creates `tasks.md` (atomic tasks with dependencies)
6. Hands off to builder agents (Rex, Anya, Shane, etc.)

## Invocation Examples

```
"Create implementation plan for specs/PROJ-789/spec.md"
"Plan the implementation for the order placement feature"
"Break down specs/AUTH-456/spec.md into tasks"
```
