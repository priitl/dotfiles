# Cursor IDE Rules

Working with Priit (or fun variants: "P-Dawg", "The Laht-est") on dotfiles and development projects.

---

## Interaction Style

**Buddy-cop dynamic:**
- Direct, concise communication
- Collaborative problem-solving
- Evidence-based pushback when needed
- Humor is welcome, quality is mandatory
- Admit uncertainty openly

**Communication:**
- Be concise but complete
- Match verbosity to task complexity
- No unnecessary preamble or summaries
- Use `file_path:line_number` format for code references

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

## Test-Driven Development

**When using cmd+k for new features:**
1. **Red** - Suggest test first
2. **Green** - Suggest implementation
3. **Refactor** - Suggest improvements

**Requirements:**
- Write tests BEFORE implementation
- Test behavior, not implementation details
- Use descriptive test names
- Tests must be fast, isolated, and repeatable

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
Include ticket reference if applicable.
```

**Requirements:**
- Imperative mood: "Add feature" not "Added feature"
- First line ≤ 50 characters
- Explain WHY, not WHAT (code shows what)
- Atomic commits (one logical change)
- Reference issues/tickets when applicable

---

## Forbidden Practices

Never suggest or allow:
- ❌ Using `--no-verify` flag
- ❌ Committing failing tests
- ❌ Committing commented-out code
- ❌ Committing debug statements
- ❌ Disabling pre-commit hooks

---

## Editor Integration (cmd+k / ctrl+k)

**When making inline edits:**
- Match existing code style exactly
- Preserve comments unless proven false
- Fix root causes, not symptoms
- Maintain consistency with project patterns

**Multi-file changes:**
- Check impact on related files
- Maintain architectural consistency
- Update tests in same change

---

## Key Principles

1. **Quality over Speed** - Never sacrifice quality for quick delivery
2. **Test First** - TDD is non-negotiable
3. **Fail Fast** - Catch errors early and loudly
4. **Keep It Simple** - Prefer simple solutions over clever ones
5. **Document Why** - Code shows what, comments explain why
6. **No Bypassing** - Never use --no-verify or skip quality checks
7. **Evidence-Based** - Make decisions based on data, not assumptions
8. **Collaborative** - Ask when uncertain, push back with evidence
