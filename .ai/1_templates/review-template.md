# Code Review Report: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`
**Reviewed**: [DATE]
**Reviewer**: AI Code Review Agent
**Status**: In Progress

## Review Scope Determination

**CRITICAL: Determine scope before proceeding**

Ask user: "What scope should I review?"
- **Option 1**: Feature branch changes only (git diff main...HEAD)
- **Option 2**: Uncommitted changes only (git diff HEAD)
- **Option 3**: Entire project/codebase
- **Option 4**: Specific directory or file path

**DO NOT ASSUME** - wait for user confirmation.

Once scope is determined, document it:
- **Scope**: [NEEDS ANSWER: branch changes / uncommitted / entire project / specific path]
- **Base comparison**: [if branch: main/master, if uncommitted: HEAD, if project: N/A]
- **Files in scope**: [list after determining scope]

---

## Execution Flow (main)
```
1. Determine review scope (ASK USER - do not assume)
   → Wait for: branch changes / uncommitted / entire project / path
   → Document scope clearly
2. Identify feature context (if feature branch)
   → Load: spec.md, plan.md, tasks.md from specs/[branch-name]/
   → If not feature branch: skip to step 3
3. Read constitution.md for standards
4. Collect files to review based on scope
   → Branch: git diff main...HEAD
   → Uncommitted: git diff HEAD
   → Project: all source files
   → Path: specified directory/files
5. Run Architecture Review checklist
   → Mark violations as CRITICAL
6. Run Code Quality Assessment checklist
   → Mark issues as MAJOR or MINOR
7. Run Testing Scrutiny checklist
   → Mark gaps as CRITICAL or MAJOR
8. If feature context exists:
   → Run Specification Compliance checklist
   → Run Plan Alignment checklist
   → Run Task Completion checklist
9. Run Constitutional Compliance checklist
   → Mark violations by severity
10. Aggregate findings by severity
11. Determine overall verdict
    → APPROVE: No critical/major issues
    → REQUEST CHANGES: Critical or major issues found
    → COMMENT: Only minor issues or suggestions
12. Generate actionable feedback report
13. Return: Review report with verdict and next steps
```

---

## Review Context *(loaded during execution)*

### Feature Information (if applicable)
- **Spec**: `specs/[branch-name]/spec.md`
- **Plan**: `specs/[branch-name]/plan.md`
- **Tasks**: `specs/[branch-name]/tasks.md`
- **Constitution**: `constitution.md`

### Scope Information
- **Review Type**: [branch changes / uncommitted / entire project / specific path]
- **Files Reviewed**: [count]
- **Lines Changed**: [if branch/uncommitted: additions/deletions]

---

## Review Checklists

### 1. Architecture Review
*Verify architectural patterns and boundaries*

- [ ] **Domain layer purity**: No external dependencies in domain
- [ ] **Dependency direction**: Adapters depend on domain, not vice versa
- [ ] **Port/Adapter boundaries**: Clear separation maintained
- [ ] **Package structure**: Follows plan.md and constitution.md
- [ ] **Layer violations**: No architectural boundary crossings

**Findings**:
- [List architecture violations with file:line references]

---

### 2. Code Quality Assessment
*Evaluate code clarity and standards compliance*

- [ ] **Readability**: Code is clear and self-documenting
- [ ] **Naming conventions**: Evergreen names (no "new", "improved", "v2")
- [ ] **Modern idioms**: Appropriate use of language features
- [ ] **Framework conventions**: Proper use of framework patterns
- [ ] **Time handling**: No direct `.now()` calls, time injection used
- [ ] **Temporal language**: No "recently", "new", "old" in comments
- [ ] **File endings**: All files end with newline (POSIX)

**Findings**:
- [List code quality issues with file:line references]

---

### 3. Testing Scrutiny
*Verify test coverage and quality*

- [ ] **Test-first evidence**: Tests exist for all business logic
- [ ] **Coverage completeness**: Unit, integration, e2e tests present
- [ ] **Test quality**: Arrange-Act-Assert structure, clear names
- [ ] **Edge cases**: Edge cases from spec.md tested (if applicable)
- [ ] **Test independence**: Tests don't depend on each other
- [ ] **Real dependencies**: Integration tests use appropriate test doubles
- [ ] **Mock usage**: Mocks only for ports/external dependencies

**Findings**:
- [List testing gaps with file:line references]

---

### 4. Specification Compliance *(if feature branch)*
*Verify requirements are met*

- [ ] **Requirements coverage**: All acceptance criteria addressed
- [ ] **User stories**: All user stories implemented
- [ ] **Non-functional requirements**: Performance, security, observability met
- [ ] **Edge cases**: Edge cases handled correctly
- [ ] **API contracts**: Endpoints match plan.md (if applicable)

**Findings**:
- [List specification gaps with spec reference]

---

### 5. Plan Alignment *(if feature branch)*
*Verify implementation follows plan*

- [ ] **Architecture match**: Implementation follows plan.md
- [ ] **Tech stack**: Specified technologies used correctly
- [ ] **Data model**: Entities match data-model.md (if exists)
- [ ] **File structure**: Code organized per plan.md
- [ ] **Dependencies**: Only approved dependencies used

**Findings**:
- [List plan deviations with plan reference]

---

### 6. Constitutional Compliance
*Verify adherence to project constitution*

- [ ] **Principles adherence**: Code follows constitutional articles
- [ ] **TDD discipline**: Evidence of test-first development
- [ ] **Security practices**: Input validation, auth, authorization
- [ ] **Performance**: No obvious anti-patterns
- [ ] **Technical guidelines**: Tech stack standards followed

**Findings**:
- [List constitutional violations with constitution reference]

---

### 7. Task Completion *(if feature branch)*
*Verify all tasks completed*

- [ ] **All tasks done**: Every task in tasks.md marked [X]
- [ ] **No shortcuts**: No TODO comments or mock implementations
- [ ] **Dependencies resolved**: All task dependencies satisfied
- [ ] **Phases complete**: Setup, Tests, Core, Integration, Polish done

**Findings**:
- [List incomplete tasks]

---

## Review Report

### Overall Verdict
**[APPROVE / REQUEST CHANGES / COMMENT]**

### Summary
[High-level summary of review findings]

### Critical Issues ⛔
*Blocking problems that MUST be fixed*

1. **[Issue Title]** - `file/path.ext:123`
   - **Problem**: [Description]
   - **Violated**: [spec/plan/constitution reference]
   - **Impact**: [Why this is critical]
   - **Fix**: [Concrete suggestion]

### Major Issues ⚠️
*Important problems that SHOULD be fixed*

1. **[Issue Title]** - `file/path.ext:456`
   - **Problem**: [Description]
   - **Violated**: [standard/principle reference]
   - **Impact**: [Why this matters]
   - **Fix**: [Concrete suggestion]

### Minor Issues 💡
*Nice-to-have improvements*

1. **[Issue Title]** - `file/path.ext:789`
   - **Observation**: [Description]
   - **Suggestion**: [Improvement idea]

### Positive Observations ✅
*Things done well*

- [List positive aspects of the implementation]

### Recommendations
*Suggestions for improvement*

- [List actionable recommendations]

---

## Next Steps

**If APPROVED**:
- ✅ Code meets all standards
- → Proceed to merge and close feature branch

**If REQUEST CHANGES**:
- ❌ Critical or major issues found
- → Run `/fix` to address issues
- → Re-run `/review` after fixes

**If COMMENT**:
- 💬 Only minor issues or suggestions
- → Address at discretion
- → Can proceed to merge if desired

---

## Execution Status
*Updated during review process*

- [ ] Review scope determined
- [ ] Feature context loaded (if applicable)
- [ ] Constitution read
- [ ] Files collected
- [ ] Architecture reviewed
- [ ] Code quality assessed
- [ ] Testing scrutinized
- [ ] Specification compliance checked (if applicable)
- [ ] Plan alignment verified (if applicable)
- [ ] Constitutional compliance verified
- [ ] Task completion checked (if applicable)
- [ ] Findings aggregated
- [ ] Verdict determined
- [ ] Report generated
