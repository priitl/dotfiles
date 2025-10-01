# Spec-Kit Alignment Guide

How to align your current workflow with GitHub Spec-Kit patterns.

## Core Approach: Spec-Kit Simplified

### Adopt from Spec-Kit
✅ **specs/** folder structure - Feature-centric organization
✅ **Simple file names** - spec.md, plan.md, tasks.md inside feature folders
✅ **Constitution at root** - Project principles
✅ **Feature numbering** - 001-feature-name pattern

## Recommended Folder Structure

```
your-project/
├── constitution.md                    # Project principles (Spec-Kit)
│
├── specs/                             # Feature specifications (Spec-Kit)
│   ├── 001-user-auth/
│   │   ├── spec.md                   # What to build
│   │   ├── plan.md                   # How to build
│   │   └── tasks.md                  # Task breakdown with status
│   ├── 002-payment/
│   │   ├── spec.md
│   │   ├── plan.md
│   │   └── tasks.md
│   └── 003-dashboard/
│       ├── spec.md
│       └── plan.md
│
└── src/                               # Source code
```

## Feature-Level Tracking

**Location:** `specs/NNN-feature/tasks.md`

**Purpose:** Detailed task breakdown per feature

**Format:**
```markdown
# Tasks: User Authentication

## T1: Setup Auth Module
**Status**: 🟢 Complete
**Dependencies**: None
**Acceptance Criteria**:
- [x] NestJS module created
- [x] Folder structure follows hexagonal pattern

## T2: Implement JWT Service
**Status**: 🟡 In Progress
**Dependencies**: T1
**Acceptance Criteria**:
- [x] Token generation
- [ ] Token validation
- [ ] Refresh token logic
```

## File Naming Convention

### Spec Files (Simple, Spec-Kit style)
```
specs/001-user-auth/spec.md
specs/001-user-auth/plan.md
specs/001-user-auth/tasks.md
```

### Rationale
- **Specs** are feature-centric, don't need dates (git tracks history)
- Simple names make navigation easier
- Feature numbering provides ordering

## TodoWrite Integration

### Use TodoWrite For:
- ✅ In-session task tracking (ephemeral)
- ✅ Multi-step operations (3+ steps)
- ✅ Quick task breakdown during active work

### Persist to tasks.md:
After completing work with TodoWrite, **sync to tasks.md**:

```
"Update specs/001-user-auth/tasks.md with completed tasks:
- T1: Complete ✅
- T2: Complete ✅
- T3: In Progress 🟡"
```

## Workflow Integration

### SPECIFY Phase
```bash
# 1. Create feature folder (Spec-Kit pattern)
mkdir -p specs/001-user-auth

# 2. Copy spec template
cp ~/.ai/4_specs/spec-template.md specs/001-user-auth/spec.md

# 3. Fill in requirements
# (Or delegate to Valdis)
```

### PLAN Phase
```bash
# 4. Generate plan
"Read specs/001-user-auth/spec.md and constitution.md,
create plan.md and tasks.md using templates from ~/.ai/4_specs/"
```

### BUILD Phase
```bash
# 5. Use TodoWrite for session tasks
TodoWrite: [
  "Implement T1 from specs/001-user-auth/tasks.md",
  "Write tests for T1",
  "Refactor T1"
]

# 6. Update tasks.md when TodoWrite complete
"Update specs/001-user-auth/tasks.md:
- T1: 🟢 Complete
- T2: 🟡 In Progress"
```

### VERIFY Phase
```bash
# 7. Review against spec
"Judge Dredd, review against specs/001-user-auth/spec.md"
```

## Migration Guide

### Setting Up Spec-Kit Structure

**Step 1: Create specs/ folder**
```bash
mkdir -p specs
# Create or copy constitution.md to project root if needed
```

**Step 2: Set up first feature**
```bash
mkdir -p specs/001-feature-name
cp ~/.ai/4_specs/spec-template.md specs/001-feature-name/spec.md
cp ~/.ai/4_specs/plan-template.md specs/001-feature-name/plan.md
cp ~/.ai/4_specs/tasks-template.md specs/001-feature-name/tasks.md
```

## Tool Support

### With Spec-Kit CLI
```bash
# Install
uv tool install spec-kit

# Works with specs/ folder
cd your-project
specify new "Add payment processing"
# Creates specs/002-payment/ with spec.md
```

### Without Spec-Kit CLI (Manual)
```bash
# Create feature manually
mkdir -p specs/003-dashboard
cp ~/.ai/4_specs/spec-template.md specs/003-dashboard/spec.md

# Edit spec, ask AI to generate plan
"Read specs/003-dashboard/spec.md, create plan.md and tasks.md"
```

## Summary: Spec-Kit Benefits

### Key Advantages
- Simple, clean structure
- AI-friendly (standard pattern)
- Feature isolation
- Works with Spec-Kit CLI
- Git tracks all history
- Easy to navigate and maintain
