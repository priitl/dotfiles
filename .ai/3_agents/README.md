# Agent-Agnostic Specialized Agents

Agents work across multiple AI tools (Claude, Copilot, Gemini, Cursor) following the **Translate → Plan → Build → Verify** workflow.

## Agent Categories

### 0️⃣ Speccing
Agents that convert requirements into technical specifications.
- **Valdis the Translator** - Jira tasks → Technical specs
- **Socrates the Questioner** - Conversational requirements gathering

[View Speccing Agents →](./0_speccing/)

### 1️⃣ Planning
Agents that create implementation plans from specifications.
- **Decomposer Dale** - Breaks specs into actionable plans and tasks

[View Planning Agents →](./1_planning/)

### 2️⃣ Engineering
Agents that build features following tech-specific patterns.
- **Rex the Red-Green-Refactor** - Spring Boot TDD specialist
- **Architect Anya** - AI configuration architect
- **Script Shepherd Shane** - Dotfiles & shell script developer
- **Constructor Conway** - Spring Boot project bootstrapper

[View Engineering Agents →](./2_engineering/)

### 3️⃣ Quality
Agents that review code and fix issues.
- **Judge Dredd Code** - Rigorous code reviewer
- **Dr. Debugsworth McFixit** - Test failure diagnostician

[View Quality Agents →](./3_quality/)

## Workflow Overview

```
┌─────────────────────────────────────────────────────────┐
│                  TRANSLATE PHASE                        │
│  Jira Task → Valdis → spec.md (+ placeholder files)    │
└─────────────────────┬───────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────────┐
│                   PLAN PHASE                            │
│  spec.md → Decomposer Dale → plan.md + tasks.md        │
└─────────────────────┬───────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────────┐
│                   BUILD PHASE                           │
│  plan + tasks → Builder (Rex/Anya/Shane) → Code + Tests│
└─────────────────────┬───────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────────────┐
│                  VERIFY PHASE                           │
│  Code → Judge Dredd → Review Feedback                   │
└─────────────────────────────────────────────────────────┘
```

## Using These Agents

### With Claude Code
```bash
# Full workflow
"Create spec from Jira task PROJ-789"  # Valdis
"Create implementation plan for specs/PROJ-789/spec.md"  # Decomposer Dale
"Implement specs/PROJ-789/ using Rex"  # Rex (Spring) / Anya (AI) / Shane (dotfiles)
"Have Judge Dredd review this implementation"  # Judge Dredd
```

### With GitHub Copilot
Agents are available as context patterns. Reference them in your prompts:
```
# Create a new project following Constructor Conway patterns
# Implement following Rex's TDD workflow
```

### With Gemini/Cursor
Import agent specifications and reference them in your workflow.

## Tech Stack Support

Agents adapt to different tech stacks via:
- **constitution.md** (declares tech stack at project root)
- **.ai/2_tech_stacks/tech-stack-{name}.md** (tech-specific patterns)

### Available Tech Stacks
- `tech-stack-spring.md` - Spring Boot, Hexagonal Architecture
- `tech-stack-dotfiles.md` - Shell scripts, BATS testing
- `tech-stack-ai.md` - AI configuration systems

### Adding New Tech Stacks
1. Create `.ai/2_tech_stacks/tech-stack-{name}.md`
2. Define architecture patterns, testing frameworks, conventions
3. Add `tech_stack: {name}` to project's `constitution.md`
4. Decomposer Dale will auto-load the tech stack context

## Agent Development Guidelines

When creating new agents:
1. **Keep them tool-agnostic** (no tool-specific commands)
2. **Define clear responsibilities** and scope
3. **Include backstory** for personality/consistency
4. **Specify input/output** formats
5. **Document when to use** vs. when not to use
6. **Place in appropriate category** (0_speccing, 1_planning, 2_engineering, 3_quality)

See [Architect Anya](./2_engineering/ai-dotfiles-architect.md) for creating new agents.

---

**Organization:** Singularity Works
**Philosophy:** Agent-agnostic, modular, test-driven, Unix-inspired
