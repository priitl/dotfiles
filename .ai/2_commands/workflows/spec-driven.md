---
description: Complete spec-driven workflow: Spec → Plan → Build → Verify
---

Execute the complete Spec-Driven Development workflow with multi-agent orchestration:

[Extended thinking: This workflow implements the four-phase spec-driven development process: SPECIFY → PLAN → BUILD → VERIFY. Specifications become the source of truth, enabling clear delegation to specialized agents and maintaining an audit trail of decisions. The workflow supports both manual and AI-assisted specification creation, with validation gates between phases to ensure quality.]

## Overview

Spec-Driven Development makes specifications executable. Instead of code being the source of truth, the **specification** becomes the source of truth, enabling:
- Clear AI delegation through documented requirements
- Audit trail of decisions and rationale
- Consistency across team members and AI agents
- Validation against stated objectives

## Feature Input

Feature to implement using spec-driven approach: $ARGUMENTS

## Phase 1: SPECIFY - Define WHAT to Build

### Determine Specification Approach

**Manual Specification**:
1. Create feature directory: `specs/NNN-feature-name/`
2. Copy spec template from `.ai/1_templates/spec-template.md`
3. Fill in sections: Overview, Requirements, Acceptance Criteria, Success Metrics
4. Review for completeness and clarity

**AI-Assisted Specification**:
- Use Task tool with subagent_type="business-analyst"
- Prompt: "Analyze requirements for: $ARGUMENTS. Generate comprehensive specification covering: overview, functional requirements, non-functional requirements, acceptance criteria, success metrics, risks, and constraints. Use structured format suitable for technical implementation."
- Output: Draft specification document

### Clarification Phase (if needed)

If specification is incomplete or vague:
- Use Task tool with subagent_type="business-analyst"
- Prompt: "Review specification for: $ARGUMENTS. Identify ambiguities, missing requirements, undefined edge cases, and unclear acceptance criteria. Generate 5-10 targeted clarification questions."
- Address questions and update specification

### Validation Checkpoint: SPECIFY Phase

- [ ] Specification document exists at `specs/NNN-feature/spec.md`
- [ ] All sections completed (Overview, Requirements, Acceptance Criteria)
- [ ] Success metrics defined and measurable
- [ ] Acceptance criteria are testable
- [ ] No major ambiguities or missing requirements
- [ ] Constitution.md exists at project root (or create if first feature)

**GATE**: Do not proceed to PLAN phase until all checkpoints pass.

## Phase 2: PLAN - Define HOW to Build

### Architecture Design

Use Task tool with subagent_type="backend-architect"
Prompt: "Read specification at specs/NNN-feature/spec.md and constitution.md. Design technical architecture for: $ARGUMENTS. Include:
- Component breakdown and responsibilities
- Technology stack decisions with rationale
- API endpoints and contracts (if applicable)
- Data model and schema changes
- Integration points with existing systems
- Security and performance considerations
Output implementation plan following the plan template structure."

### Task Breakdown

Use Task tool with subagent_type="backend-architect"
Prompt: "Based on the implementation plan at specs/NNN-feature/plan.md, break down work into atomic tasks. Create specs/NNN-feature/tasks.md with:
- Phase-organized tasks (Setup, Tests, Core, Integration, Polish)
- Clear task descriptions with file paths
- Dependencies between tasks (sequential vs parallel)
- Effort estimates
- Risk indicators
Use task template format with checkboxes for tracking."

### Optional: Research & Data Modeling

**If feature requires technical decisions**:
- Use Task tool with subagent_type="backend-architect"
- Prompt: "Research technical decisions for: $ARGUMENTS. Document in specs/NNN-feature/research.md: technology choices, trade-offs, benchmarks, recommendations."

**If feature has complex data structures**:
- Use Task tool with subagent_type="backend-architect"
- Prompt: "Design data model for: $ARGUMENTS. Document in specs/NNN-feature/data-model.md: entities, relationships, validation rules, migrations."

### Validation Checkpoint: PLAN Phase

- [ ] Implementation plan exists at `specs/NNN-feature/plan.md`
- [ ] Task breakdown exists at `specs/NNN-feature/tasks.md`
- [ ] All tasks have clear acceptance criteria
- [ ] Dependencies between tasks are identified
- [ ] Technology choices are documented with rationale
- [ ] Plan addresses all requirements from spec.md
- [ ] Risks are identified with mitigation strategies

**GATE**: Do not proceed to BUILD phase until all checkpoints pass.

## Phase 3: BUILD - Implement with TDD

### Development Mode Selection

**Choose your approach**:

**Option A: TDD-First Development (Recommended)**
- Use Task tool with subagent_type="tdd-orchestrator"
- Prompt: "Implement feature using strict TDD for: $ARGUMENTS. Read specs/NNN-feature/spec.md, specs/NNN-feature/plan.md, and specs/NNN-feature/tasks.md. Execute tasks in order following red-green-refactor cycle:
  1. Write failing test (RED)
  2. Implement minimal code to pass (GREEN)
  3. Refactor while keeping tests green (REFACTOR)
  4. Mark task as complete in tasks.md
  Ensure all acceptance criteria from spec.md are covered by tests."

**Option B: Traditional Development**
1. For each task in tasks.md:
   - Use Task tool with appropriate language agent (e.g., "python-pro", "typescript-pro")
   - Prompt: "Implement Task [N] from specs/NNN-feature/tasks.md. Follow plan at specs/NNN-feature/plan.md. Write tests before implementation."
   - Update task status in tasks.md
2. Commit incrementally with reference to spec

**Option C: Automated Implementation**
- Use Task tool with subagent_type="backend-architect"
- Prompt: "Execute all tasks from specs/NNN-feature/tasks.md in order. For each task: implement, test, verify against spec.md requirements. Report progress and mark completed tasks."

### Progress Tracking

During BUILD phase:
- Mark tasks as 🟢 (completed), 🟡 (in progress), 🔴 (blocked)
- Update tasks.md after each completed task
- Commit code with spec reference: `feat(NNN): description\n\nSee specs/NNN-feature/spec.md`
- Run tests continuously to maintain green state

### Validation Checkpoint: BUILD Phase

- [ ] All tasks in tasks.md marked as completed
- [ ] All tests pass (unit, integration, e2e)
- [ ] Code coverage meets project standards (typically 80%+)
- [ ] No TODO comments or mock implementations remain
- [ ] Code follows constitution.md principles
- [ ] All acceptance criteria from spec.md have passing tests

**GATE**: Do not proceed to VERIFY phase until all checkpoints pass.

## Phase 4: VERIFY - Validate Against Specification

### Code Review

Use Task tool with subagent_type="code-reviewer"
Prompt: "Perform comprehensive code review for: $ARGUMENTS. Review against:
- Specification requirements at specs/NNN-feature/spec.md
- Architecture plan at specs/NNN-feature/plan.md
- Project principles at constitution.md
Check for: requirement coverage, code quality, security vulnerabilities, performance issues, test coverage, documentation completeness. Provide structured feedback with severity levels."

### Acceptance Validation

Use Task tool with subagent_type="test-automator"
Prompt: "Validate implementation against acceptance criteria in specs/NNN-feature/spec.md for: $ARGUMENTS. For each criterion:
1. Identify corresponding tests
2. Verify test coverage is complete
3. Confirm tests pass
4. Note any gaps or missing coverage
Generate acceptance validation report."

### Constitution Compliance

Use Task tool with subagent_type="code-reviewer"
Prompt: "Verify implementation complies with constitution.md principles for: $ARGUMENTS. Check adherence to:
- Architectural patterns
- Code quality standards
- Testing requirements
- Documentation standards
Report violations with specific code references."

### Validation Checkpoint: VERIFY Phase

- [ ] All acceptance criteria from spec.md are verified
- [ ] Code review completed with no critical issues
- [ ] Constitution compliance verified
- [ ] Performance requirements met (if specified)
- [ ] Security review passed (if applicable)
- [ ] Documentation updated
- [ ] Ready for pull request creation

**GATE**: All checkpoints must pass for feature completion.

## Completion Actions

After successful verification:

1. **Create Feature Branch** (if not already)
   ```
   git checkout -b NNN-feature-name
   ```

2. **Commit Final Changes**
   ```
   git add .
   git commit -m "feat(NNN): Feature description

   Implements specs/NNN-feature/spec.md
   All acceptance criteria validated.

   Co-Authored-By: Claude <noreply@anthropic.com>"
   ```

3. **Create Pull Request**
   - Link to specification: `specs/NNN-feature/spec.md`
   - Summarize changes and rationale
   - Note test coverage metrics
   - List completed acceptance criteria

4. **Update Specification Status**
   - Mark spec.md as implemented
   - Note PR number and merge date
   - Archive completed feature specs

## Recovery Processes

### If SPECIFY Phase Fails
- Clarification questions insufficient → Involve stakeholder for requirements
- Requirements contradictory → Create decision log with trade-off analysis
- Scope too large → Break into multiple smaller specs

### If PLAN Phase Fails
- Architecture unclear → Research phase needed, create research.md
- Task breakdown incomplete → Review similar features for patterns
- Dependencies complex → Create dependency graph, sequence carefully

### If BUILD Phase Fails
- Tests failing → Use test-fixer agent to diagnose and fix
- Task blocked → Mark as 🔴, identify blocker, escalate or deprioritize
- Implementation diverging from plan → Stop, review plan, update if needed

### If VERIFY Phase Fails
- Code review issues → Address feedback, re-run verification
- Acceptance criteria not met → Return to BUILD, implement missing functionality
- Constitution violations → Refactor to compliance, maintain test coverage

## When to Use Spec-Driven Development

### ✅ Best For
- New features requiring planning (multi-day effort)
- Complex changes with multiple components
- Features with compliance or audit requirements
- Team projects needing shared understanding
- 🔴 "Always Ask First" actions from decision framework

### ⚠️ Consider Skipping For
- One-line bug fixes
- Trivial typo corrections
- Dependency updates
- Quick experiments
- 🟢 "Autonomous" actions from decision framework

Use your decision framework:
- 🔴 **Always Ask First**: MUST use spec-driven approach
- 🟡 **Collaborative**: SHOULD use spec-driven approach
- 🟢 **Autonomous**: CAN skip spec-driven approach

## Benefits

### For Development
- **Clear delegation**: "Implement from spec" vs. explaining every detail
- **Reduced rework**: Issues caught during planning, not coding
- **Parallel execution**: Multiple agents work on different tasks
- **Context preservation**: Specs survive across sessions

### For Quality
- **Test coverage**: Acceptance criteria → test cases (traceable)
- **Consistency**: Constitution enforces standards automatically
- **Audit trail**: Complete history of what/why/how decisions
- **Validation**: Objective criteria for "done"

### For Collaboration
- **Onboarding**: New team members read specs to understand features
- **Knowledge capture**: Rationale documented, not lost in commits
- **Stakeholder alignment**: Specs validate understanding before coding
- **AI effectiveness**: Structured input → better AI output

## Notes

- Specifications are living documents - update when requirements change
- Commit specs with code in same PR for version control
- Use status indicators (🔵🟡🟢🔴) for visual tracking
- Reference spec.md in all commits and PRs
- Archive completed specs for historical reference
- Constitution.md should be created once per project, updated rarely

Feature to implement: $ARGUMENTS
