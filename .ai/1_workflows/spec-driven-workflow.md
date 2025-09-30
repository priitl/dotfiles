# Spec-Driven Development Workflow

Integration of [GitHub Spec-Kit](https://github.com/github/spec-kit) patterns with Priit's AI-first development environment.

## Overview

Spec-Driven Development (SDD) makes **specifications executable**. Instead of code being the source of truth, the **specification** becomes the source of truth.

## The Four Phases

```
SPECIFY → PLAN → BUILD → VERIFY
```

### Phase 1: SPECIFY
**Goal**: Define WHAT to build

**Artifacts Created**:
- `spec.md` - Feature specification
- `constitution.md` - Project principles (once per project)

**Process**:
1. Start with user story or requirement
2. Fill out spec template (`.ai/3_specs/spec-template.md`)
3. Include requirements, acceptance criteria, success metrics
4. If vague, run clarification phase (ask AI to generate questions)

**Tools**:
- Manual: Copy template, fill in by hand
- With Spec-Kit: `specify new "feature description"`
- With Valdis: "Translate JIRA-123 into a spec using the template"

### Phase 2: PLAN
**Goal**: Define HOW to build

**Artifacts Created**:
- `plan.md` - Implementation plan
- `tasks.md` - Task breakdown
- `research.md` - Technical decisions (optional)
- `data-model.md` - Data structures (optional)

**Process**:
1. AI reads `spec.md` + `constitution.md`
2. AI creates phased implementation plan
3. AI breaks down into atomic tasks
4. AI identifies risks and dependencies

**Tools**:
- With Spec-Kit: `specify plan`
- Manual prompt: "Read spec.md and constitution.md, create implementation plan using plan-template.md"

### Phase 3: BUILD
**Goal**: Implement the solution with TDD

**Artifacts Created**:
- Source code
- Tests (unit, integration, E2E)
- Documentation updates

**Process**:
1. For each task in `tasks.md`:
   - Delegate to Rex for TDD implementation
   - Write test first (Red)
   - Implement code (Green)
   - Refactor (Refactor)
   - Update task status to 🟢
2. Commit with tracking ID
3. Push feature branch

**Tools**:
- Delegate to Rex: "Implement Task 1 from tasks.md using TDD"
- Update progress: "Mark Task 1 as complete in tasks.md"

### Phase 4: VERIFY
**Goal**: Validate against spec

**Artifacts Created**:
- Test results
- Code review feedback
- Acceptance sign-off

**Process**:
1. Run all tests (pre-commit hooks enforce)
2. Delegate to Judge Dredd for code review
3. Verify acceptance criteria from `spec.md` are met
4. Validate constitution.md compliance
5. Create PR with spec reference

**Tools**:
- Judge Dredd: "Review this PR against specs/001-auth/spec.md"
- Manual: Check each acceptance criterion manually

## Integration with Your Agents

### 🌉 Valdis the Translator
**Use in**: SPECIFY phase
**Purpose**: Convert Jira/requirements into spec.md
**Example**: "Valdis, translate JIRA-456 into a spec using the template at .ai/3_specs/spec-template.md"

### 🦖 Rex the Red-Green-Refactor
**Use in**: BUILD phase
**Purpose**: TDD implementation of tasks
**Example**: "Rex, implement Task 3 from tasks.md following strict TDD"

### ⚖️ Judge Dredd Code
**Use in**: VERIFY phase
**Purpose**: Review code against spec and constitution
**Example**: "Judge Dredd, review this code against specs/001-auth/spec.md and constitution.md"

### 🔬 Dr. Debugsworth McFixit
**Use in**: BUILD/VERIFY phase
**Purpose**: Fix failing tests while maintaining spec compliance
**Example**: "Dr. McFixit, these tests are failing. Spec is at specs/001-auth/spec.md"

### 🏗️ Constructor Conway
**Use in**: SPECIFY phase (project setup)
**Purpose**: Bootstrap project using constitution.md
**Example**: "Conway, bootstrap a new Spring Boot project using constitution.md principles"

## Example: Complete Feature Flow

### Feature: Add User Authentication

```bash
# 1. SPECIFY Phase
mkdir -p specs/001-user-auth
cp ~/.ai/3_specs/spec-template.md specs/001-user-auth/spec.md

# Edit spec.md with requirements
# Or delegate to Valdis
"Valdis, convert JIRA-789 (user authentication) into specs/001-user-auth/spec.md"

# 2. PLAN Phase
"Read specs/001-user-auth/spec.md and constitution.md.
Create an implementation plan at specs/001-user-auth/plan.md using the template.
Include task breakdown in specs/001-user-auth/tasks.md"

# AI generates:
# - plan.md (architecture, phases, risks)
# - tasks.md (T1-T10 with dependencies)
# - research.md (tech decisions)

# 3. BUILD Phase (TDD with Rex)
git checkout -b 001-user-auth

"Rex, implement Task 1 from specs/001-user-auth/tasks.md using TDD"
# Rex writes test first (RED)
# Rex implements code (GREEN)
# Rex refactors (REFACTOR)

"Mark Task 1 as complete in tasks.md"

# Repeat for each task
"Rex, implement Task 2..."
"Rex, implement Task 3..."

# 4. VERIFY Phase
git add .
git commit -m "feat(JIRA-789): Implement user authentication

See specs/001-user-auth/spec.md for requirements

Co-Authored-By: Claude <noreply@anthropic.com>"

"Judge Dredd, review this code against:
- specs/001-user-auth/spec.md
- constitution.md
Check all acceptance criteria are met"

# Create PR
gh pr create --base main --title "feat: User authentication (001)" \
  --body "Implements specs/001-user-auth/spec.md

All acceptance criteria verified."
```

## Directory Structure

### Recommended Project Layout
```
your-project/
├── constitution.md              # Project principles (root)
├── specs/                       # All feature specs
│   ├── 001-user-auth/
│   │   ├── spec.md
│   │   ├── plan.md
│   │   ├── tasks.md
│   │   └── research.md
│   ├── 002-payment-flow/
│   │   ├── spec.md
│   │   ├── plan.md
│   │   ├── tasks.md
│   │   ├── data-model.md
│   │   └── contracts/
│   │       └── payment-api.yaml
│   └── 003-admin-dashboard/
│       └── spec.md
├── src/                         # Source code
├── tests/                       # Tests
└── docs/                        # Other documentation
```

## Tips for Success

### ✅ Do This
1. **Write constitution.md first** - Set principles before coding
2. **Start with small specs** - Get comfortable with the workflow
3. **Keep specs updated** - Specs evolve, keep them current
4. **Link artifacts** - Reference spec.md from plan.md, plan.md from tasks.md
5. **Use status indicators** - 🔵🟡🟢🔴 for visual tracking
6. **Commit specs with code** - Version control everything

### ❌ Avoid This
1. **Don't skip the spec** - "Quick fix" turns into undocumented mess
2. **Don't write code before plan** - Planning saves debugging time
3. **Don't ignore constitution** - It exists for a reason
4. **Don't let specs go stale** - Update when requirements change
5. **Don't mix multiple features** - One spec per feature/branch
6. **Don't commit broken specs** - Specs should always be valid

## Benefits for You, Priit

### 🎯 Alignment with Your Style
- **TDD-first**: Specs naturally lead to test-first development
- **Quality gates**: Constitution enforces your pre-commit discipline
- **Clear intent**: Specs make AI understand what you actually want
- **Buddy-cop vibe**: You write specs, AI implements them

### 🚀 Enhanced Workflows
- **Better delegation**: "Rex, implement from spec" is clearer than explaining each time
- **Consistent quality**: Constitution ensures standards across all features
- **Audit trail**: Specs + tasks = complete history of decisions
- **Project onboarding**: New devs/agents read constitution, understand project

### 💪 Productivity Gains
- **Less rework**: Spec catches issues before coding
- **Parallel work**: Multiple agents work on different tasks simultaneously
- **Context preservation**: Specs survive across sessions
- **Knowledge capture**: Why decisions were made, documented

## When to Use Spec-Driven

### ✅ Best For
- New features (greenfield development)
- Complex changes requiring planning
- Multi-phase implementations
- Team projects (shared understanding)
- Compliance-heavy work (audit trail needed)

### ⚠️ Overkill For
- One-line bug fixes
- Trivial typo corrections
- Dependency updates
- Quick experiments

Use your 🟢🟡🔴 decision framework:
- 🟢 **Autonomous actions**: Skip specs
- 🟡 **Collaborative actions**: Consider specs
- 🔴 **Ask first actions**: ALWAYS use specs

## Resources

- Templates: `~/.ai/3_specs/`
- GitHub Spec-Kit: https://github.com/github/spec-kit
- Your agents: `~/.ai/2_agents/`
- This workflow: `~/.ai/1_workflows/spec-driven-workflow.md`
