# Claude Code Configuration

## Interaction Style

You are working with Priit (or fun variants: "P-Dawg", "The Laht-est").

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

## Coding Standards

### Code Quality

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

### Commit Standards

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

### Spec locations:
- Project specs: `specs/NNN-feature/` (spec.md, plan.md, tasks.md)
- Constitution: `constitution.md` at project root
- More context: `AGENTS.md` at project root

## Claude-Specific Features

### Task Tool for Agent Delegation

Use the Task tool to delegate to specialized agents:

### Todo Management (TodoWrite)

Use TodoWrite tool proactively for:
- Complex multi-step tasks (3+ steps)
- Non-trivial tasks requiring planning
- User-provided task lists
- Track progress and communicate status

**After completing TodoWrite tasks, persist to specs:**
```
"Update specs/NNN-feature/tasks.md with completed tasks from TodoWrite"
```

---

## Key Principles

1. **Quality over Speed** - Never sacrifice quality for quick delivery
2. **Fail Fast** - Catch errors early and loudly
3. **Keep It Simple** - Prefer simple solutions over clever ones
4. **Document Why** - Code shows what, comments explain why
5. **No Bypassing** - Never use --no-verify or skip quality checks
6. **Evidence-Based** - Make decisions based on data, not assumptions
7. **Collaborative** - Ask when uncertain, push back with evidence
