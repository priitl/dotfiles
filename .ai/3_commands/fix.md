---
description: Diagnose and fix test failures, build errors, and code review issues
---

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

Goal: Diagnose failures (test failures, build errors, linting issues, review feedback) and systematically fix them while maintaining spec compliance and code quality. This command runs AFTER `/implement` or `/spec-review` when issues are detected.

Constitution Authority: The project constitution (`constitution.md`) is **non-negotiable**. Fixes MUST maintain constitutional compliance. Never compromise on architecture, testing rigor, or security to "make it work."

Execution steps:

1. Determine fix context:
   - If user provided feature path (e.g., `specs/003-user-auth`), use it
   - If user provided specific failure description in arguments, use it
   - Otherwise, check current git branch for feature name pattern (NNN-feature-name)
   - Derive context:
     - SPEC = `specs/[branch-name]/spec.md`
     - PLAN = `specs/[branch-name]/plan.md`

2. Read the constitution at `constitution.md` to understand coding standards and restrictions.

3. Identify failure type:
   - **Test failures**: Run tests, capture output, identify failing tests
   - **Build errors**: Run build, capture compilation/linking errors
   - **Linting issues**: Run linters (checkstyle, spotbugs, eslint), capture violations
   - **Review feedback**: If `/spec-review` was run, parse review report for critical/major issues
   - **Runtime errors**: If provided, analyze stack traces and error logs

4. Analyze root cause:
   - **For test failures**:
     - Understand what the test is verifying
     - Identify assertion that failed
     - Check if implementation logic is wrong OR test expectations are wrong
     - Verify test setup (mocks, fixtures, data) is correct
   - **For build errors**:
     - Identify missing dependencies
     - Check for syntax errors or type mismatches
     - Verify import statements and package structure
   - **For linting issues**:
     - Understand the violated rule
     - Check if it's a valid violation or false positive
     - Determine if fix requires code change or suppression
   - **For review feedback**:
     - Understand the architectural or quality concern
     - Identify specific code sections needing changes
     - Plan refactoring approach

5. Plan fix strategy:
   - **Minimal changes**: Fix the specific issue without unnecessary refactoring
   - **Maintain tests**: If fixing implementation, keep tests unchanged (they define correct behavior)
   - **Preserve architecture**: Ensure fix doesn't violate hexagonal boundaries
   - **Follow constitution**: All fixes must comply with constitutional principles
   - **Avoid shortcuts**: No TODO comments, no skipping tests, no suppressing real issues

6. Execute fixes systematically:
   - **One issue at a time**: Fix, verify, commit, move to next
   - **Test-first mindset**: If test is wrong, understand why before changing
   - **Incremental validation**: Run affected tests after each fix
   - **Document reasoning**: Add comments explaining non-obvious fixes
   - **Track progress**: Mark fixed issues as resolved

7. Fix execution patterns:
   - **Test failure fix**:
     1. Read failing test code
     2. Read implementation code
     3. Determine root cause (logic error, missing edge case, wrong test expectation)
     4. Fix implementation (preferred) or test (if test was wrong)
     5. Run test again to verify fix
   - **Build error fix**:
     1. Parse compiler/build error message
     2. Identify problematic code location
     3. Fix syntax, types, imports, or dependencies
     4. Re-run build to verify
   - **Architecture violation fix**:
     1. Identify violated boundary (e.g., domain depending on adapter)
     2. Refactor to invert dependency (use ports/interfaces)
     3. Update affected tests
     4. Verify architecture compliance
   - **Code quality fix**:
     1. Identify quality issue (naming, complexity, duplication)
     2. Refactor while maintaining behavior
     3. Run tests to ensure no regression
     4. Verify linters pass

8. Validation after fixes:
   - Run full test suite (unit + integration + e2e)
   - Run build to ensure compilation succeeds
   - Run linters to verify code quality
   - Check git diff to ensure changes are minimal and focused
   - Verify spec.md requirements still met

9. Handle unfixable issues:
   - If issue cannot be fixed without violating constitution: STOP and report
   - If issue requires spec/plan changes: Document needed changes, ask user
   - If issue reveals architectural flaw: Escalate to `/spec-review` or `/analyze`
   - If blocked by external dependency: Document blocker, suggest workaround

10. Report fix results:
    - **Fixed issues**: List each issue and how it was resolved
    - **Remaining issues**: Any issues that could not be fixed (with reasons)
    - **Changes made**: Summary of modified files and changes
    - **Verification status**: Test results, build status, linter status
    - **Next steps**: Recommendations (re-run `/spec-review`, continue with merge, etc.)

11. Update tasks.md (if applicable):
    - If fixing issues from incomplete implementation, mark tasks complete
    - If fixing issues found in review, note fixes in task descriptions
    - Keep tasks.md synchronized with actual implementation state

12. Commit fixes:
    - Create focused commit message explaining fixes
    - Reference spec/plan/review report as context
    - Include test results showing fixes work
    - Follow git workflow from constitution.md

Note: This command MODIFIES code to fix issues. It assumes the specification and plan are correct. If the spec/plan needs changes, use `/specify` or `/plan` to update them first, then re-run `/implement`.
