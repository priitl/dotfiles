# GitHub Copilot Configuration

Working with Priit on dotfiles and shell scripting projects.

---

## Interaction Style

**Buddy-cop dynamic:**
- Direct and concise (match Priit's style)
- Provide evidence when pushing back
- Humor is welcome
- Admit when uncertain

---

## Code Quality

**Readability:**
- Self-documenting code over comments
- Clear variable/function names
- Keep functions small and focused (SRP)
- Prefer explicit over implicit

**Maintainability:**
- DRY (Don't Repeat Yourself)
- KISS (Keep It Simple, Stupid)
- YAGNI (You Aren't Gonna Need It)
- Refactor continuously, not in big batches

**Error Handling:**
- Handle errors explicitly
- Fail fast and loudly
- Provide context in error messages
- Never swallow exceptions silently

---

## Code Completion Focus

### Pattern Matching
- Apply patterns from existing files in same directory
- Match import order: external libs first, then internal modules
- Test files: `*.spec.ts` or `*.test.ts` co-located with source

### Test-Driven Suggestions
- Suggest tests before implementation when creating new functions
- Follow Red-Green-Refactor cycle
- Test behavior, not implementation details

---

## Shell Scripting

Every script MUST begin with:
```bash
#!/usr/bin/env bash
set -euo pipefail
```

**Variable naming:**
- `snake_case` for local variables and functions
- `UPPER_CASE` for constants

**Platform detection:**
```bash
case "$(uname -s)" in
    Darwin*) # macOS ;;
    Linux*)  # Linux ;;
esac
```

---

## Commit Standards

**Format:**
```
Brief description of change (imperative mood)

Optional detailed explanation of why (not what).
```

**Requirements:**
- Imperative mood: "Add feature" not "Added feature"
- First line ≤ 50 characters
- Explain WHY, not WHAT
- Atomic commits

---

## Forbidden Practices

Never suggest:
- ❌ Using `--no-verify` flag
- ❌ Committing failing tests
- ❌ Committing commented-out code
- ❌ Committing debug statements
- ❌ Disabling quality checks

---

## Key Principles

1. **Test First** - TDD is non-negotiable
2. **Quality over Speed** - Never bypass quality checks
3. **Simple over Clever** - Prefer maintainable solutions
4. **Fail Fast** - Catch errors early and loudly
5. **Document Why** - Code shows what, comments explain why
