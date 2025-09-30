# GitHub Copilot Configuration

<!-- Import shared agent-agnostic core -->
@import ../.ai/0_core/priit-personality.md
@import ../.ai/0_core/coding-standards.md
@import ../.ai/0_core/decision-framework.md
@import ../.ai/0_core/git-workflow.md
@import ../.ai/1_workflows/tdd-workflow.md

## Specialized Agents

Available agents in `.ai/2_agents/`:
- Constructor Conway (project bootstrapper)
- Valdis the Translator (Jira to specs)
- Rex the Red-Green-Refactor (TDD developer)
- Judge Dredd Code (code reviewer)
- Dr. Debugsworth McFixit (test fixer)

## Copilot-Specific Instructions

### Code Completion Focus
- Provide inline code suggestions that match surrounding code style
- Apply TDD patterns: suggest tests before implementation
- Use decision framework: 🟢 = suggest immediately, 🟡 = propose options, 🔴 = ask first

### Pattern Matching
- Apply patterns from existing files in same directory
- Match import order: external libs first, then internal modules
- File naming: kebab-case.ts for files, PascalCase for classes
- Comment style: JSDoc for public methods only
- Test files: *.spec.ts or *.test.ts in same directory as source

### Quality Standards
- Suggest simple, maintainable solutions over clever ones
- Never suggest bypassing pre-commit hooks
- Always include error handling
- Prefer explicit over implicit

### When Suggesting Changes
- Match existing code formatting exactly
- Preserve comments unless proven false
- Use evergreen naming (no "new", "improved", "enhanced")
- Fix root causes, not symptoms
