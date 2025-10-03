---
description: Perform rigorous code review of implementation against spec, plan, and constitution
---

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

Goal: Conduct a thorough, critical code review of implemented changes, verifying alignment with specification requirements, architectural principles, code quality standards, and testing rigor. This command runs AFTER `/implement` to validate the implementation before merge.

Constitution Authority: The project constitution (`constitution.md`) is **non-negotiable**. All code MUST comply with constitutional principles. Architecture violations, testing gaps, and quality issues are blocking concerns that must be addressed before approval.

Execution steps:

1. Determine review scope:
   - If user provided feature path (e.g., `specs/003-user-auth`), use it
   - Otherwise, check current git branch for feature name pattern (NNN-feature-name)
   - Derive review context:
     - SPEC = `specs/[branch-name]/spec.md`
     - PLAN = `specs/[branch-name]/plan.md`
     - TASKS = `specs/[branch-name]/tasks.md`
     - CONSTITUTION = `constitution.md`
     - AGENTS = `AGENTS.md`
   - Identify changed files via git diff (compare feature branch to main/master)

2. Load review artifacts:
   - Read spec.md for functional/non-functional requirements
   - Read plan.md for architecture, tech stack, design decisions
   - Read tasks.md to verify all tasks were completed
   - Read constitution.md for principles, standards, restrictions
   - Read AGENTS.md for project structure and conventions
   - Get git diff of all changed files

3. Architecture Review:
   - **Hexagonal compliance**: Verify domain layer purity (no external dependencies)
   - **Dependency direction**: Check adapters depend on domain, not vice versa
   - **Port/Adapter boundaries**: Validate clear separation between layers
   - **Package structure**: Confirm follows plan.md and constitution.md structure
   - **Layer violations**: Flag any architectural boundary crossings

4. Code Quality Assessment:
   - **Readability**: Evaluate code clarity and self-documentation
   - **Naming conventions**: Check for evergreen names (no "new", "improved", "v2")
   - **Modern idioms**: Verify use of `var`, records, Optional chains, etc.
   - **Lombok usage**: Validate appropriate use of @Builder, @RequiredArgsConstructor
   - **Clock injection**: Confirm no direct `.now()` calls, Clock is injected
   - **Temporal language**: Flag comments with "recently", "new", "old"
   - **File endings**: Check all files end with newline (POSIX compliance)

5. Testing Scrutiny:
   - **Test-first evidence**: Verify tests exist for all business logic
   - **Coverage completeness**: Check unit, integration, and e2e test presence
   - **Test quality**: Assess Arrange-Act-Assert structure, clear test names
   - **Edge cases**: Verify edge cases from spec.md have tests
   - **Test independence**: Confirm tests don't depend on each other
   - **Testcontainers**: Check integration tests use real dependencies
   - **Mock usage**: Validate mocks are for ports/external dependencies only

6. Specification Compliance:
   - **Requirements coverage**: Every acceptance criterion from spec.md addressed
   - **User stories**: All user stories implemented as specified
   - **Non-functional requirements**: Performance, security, observability met
   - **Edge cases**: Edge cases from spec.md handled correctly
   - **API contracts**: REST endpoints match plan.md specifications

7. Plan Alignment:
   - **Architecture match**: Implementation follows plan.md architecture
   - **Tech stack**: Uses specified technologies correctly
   - **Data model**: Entities match data-model.md (if exists)
   - **File structure**: Code organized as outlined in plan.md
   - **Dependencies**: Only approved dependencies from plan.md used

8. Constitutional Compliance:
   - **Principles adherence**: Code follows all constitutional articles
   - **TDD discipline**: Evidence of test-first development
   - **Security practices**: Input validation, authentication, authorization
   - **Performance requirements**: No obvious performance anti-patterns
   - **Technical guidelines**: Follows tech stack standards from constitution

9. Task Completion Verification:
   - **All tasks done**: Every task in tasks.md marked complete [X]
   - **No shortcuts**: No TODO comments or mock implementations left
   - **Dependencies resolved**: All task dependencies satisfied
   - **Phases complete**: All phases (Setup, Tests, Core, Integration, Polish) done

10. Generate review report:
    - **Overall verdict**: APPROVE / REQUEST CHANGES / COMMENT
    - **Critical issues**: Blocking problems that must be fixed (architecture, security, missing tests)
    - **Major issues**: Important problems that should be fixed (code quality, incomplete requirements)
    - **Minor issues**: Nice-to-have improvements (naming, comments, refactoring opportunities)
    - **Positive observations**: What was done well
    - **Recommendations**: Suggestions for improvement

11. Provide actionable feedback:
    - For each issue: File path, line numbers, description, suggested fix
    - Prioritize issues by severity (Critical > Major > Minor)
    - Reference specific spec/plan/constitution sections violated
    - Offer concrete code examples for fixes where appropriate

12. Next steps:
    - If APPROVED: Proceed to merge and close feature branch
    - If REQUEST CHANGES: Use `/fix` to address critical/major issues
    - If COMMENT: Optional improvements, up to developer discretion

Note: This command is READ-ONLY and does NOT modify code. It produces a review report. To fix issues, use `/fix` command after reviewing the report.
