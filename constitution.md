# Dotfiles Repository Constitution

This document defines the **non-negotiable principles** for Priit's dotfiles repository.

## Project Overview

**Purpose**: Agent-agnostic AI development environment configuration
**Scope**: Personal dotfiles that work across Claude, Copilot, Gemini, and Cursor
**Philosophy**: Write once, use everywhere

## Core Principles

### 1. Agent-Agnostic First
- ALL core content lives in `.ai/` (agent-agnostic)
- Tool-specific folders (`.claude/`, `.copilot/`, etc.) are thin wrappers
- Changes to `.ai/` automatically affect all AI tools (via symlinks)
- No duplication between tool configs

### 2. Single Source of Truth
- Agents: `.ai/3_agents/` only (`.claude/agents/` is symlink)
- Standards: `.ai/0_core/` defines all rules
- Workflows: `.ai/1_workflows/` contains all processes
- Templates: `.ai/4_specs/` for spec-driven development

### 3. Backward Compatibility
- Original agent filenames preserved (`spring-hex-bootstrapper.md`, not `constructor-conway.md`)
- Existing `.claude/agents/` path works via symlink
- No breaking changes to agent references

### 4. Quality Over Convenience
- NEVER bypass pre-commit hooks (`--no-verify` forbidden)
- NEVER commit changes without testing
- All templates must be validated before adding
- Documentation updates required for structural changes

### 5. Symlink-Based Installation
- `install.sh` creates symlinks, not copies
- Changes in repo are immediately live in `~/`
- No need to reinstall after edits
- Backups created before symlink creation

## Technology Stack

**Primary Tech Stack**: <!-- Used by Decomposer Dale for planning -->
```
tech_stack: dotfiles  # Shell scripts, BATS testing, Unix tooling
```

**Secondary Tech Stack**: <!-- For AI configuration work in .ai/ -->
```
tech_stack_secondary: ai  # Agent definitions, workflows, CLAUDE.md
```

**Reference Files**:
- Dotfiles patterns: `.ai/2_tech_stacks/tech-stack-dotfiles.md`
- AI config patterns: `.ai/2_tech_stacks/tech-stack-ai.md`

### Shell & Environment
- **Shell**: Zsh with oh-my-zsh
- **Theme**: Powerlevel10k
- **Platform**: macOS (primary), Linux (compatible)
- **Package Manager**: Homebrew (macOS)

### AI Tools Supported
- **Claude Code**: Primary IDE integration
- **GitHub Copilot**: Inline code completion
- **Google Gemini**: Large-context analysis
- **Cursor IDE**: AI-powered editor

### Version Control
- **Git**: All configs version controlled
- **Branch Strategy**: main branch (stable), feature branches for changes
- **Commit Format**: Conventional commits with tracking IDs

## Architecture Patterns

### Directory Structure
```
dotfiles/
├── .ai/                   # Agent-agnostic core (source of truth)
│   ├── 0_core/            # Standards, principles, workflows
│   ├── 1_workflows/       # Process definitions
│   ├── 3_agents/          # Specialized agents
│   └── 4_specs/           # Spec-kit templates
├── .claude/               # Claude wrapper (imports from .ai/)
├── .copilot/              # Copilot wrapper
├── .gemini/               # Gemini wrapper
├── .cursor/               # Cursor wrapper
└── shell configs...       # zshrc, gitconfig, etc.
```

### Import Pattern
All tool configs use `@import` to pull from `.ai/`:
```markdown
@import ../.ai/0_core/priit-personality.md
@import ../.ai/0_core/coding-standards.md
```

## Coding Standards

### File Naming
- **Agent files**: Original names (e.g., `spring-hex-bootstrapper.md`)
- **Work logs**: Dated format `YYYYMMDD-agent-topic.md` (when used in projects)
- **Templates**: Descriptive names (`spec-template.md`, `plan-template.md`)

### Documentation Style
- **Markdown**: All documentation in markdown
- **Headers**: H1 for title, H2 for sections, H3 for subsections
- **Code blocks**: Always specify language (```bash, ```markdown)
- **Links**: Use relative paths within repo

### Personality & Tone
- **Address user as**: "Priit" (or fun variants)
- **Relationship**: Buddy-cop collaboration
- **Humor**: Welcome and encouraged
- **Quality**: Non-negotiable, never compromised

## Prohibited Actions

### NEVER
1. Create duplicate agents (use symlinks)
2. Commit secrets or credentials
3. Break backward compatibility without migration guide
4. Use `--no-verify` when committing
5. Create tool-specific agents (keep in `.ai/3_agents/`)
6. Hardcode paths (use relative imports)

### AVOID
1. Adding dependencies without justification
2. Complex installation scripts (keep it simple)
3. OS-specific code without fallbacks
4. Removing existing features without deprecation notice

## Required Actions

### ALWAYS
1. Test install.sh after changes
2. Update README.md when structure changes
3. Keep all tool wrappers in sync with `.ai/` changes
4. Preserve existing agent names and references
5. Document breaking changes in commit messages

### BEFORE COMMIT
1. Run shellcheck on install.sh
2. Verify symlinks work correctly
3. Test with at least one AI tool (Claude)
4. Update version in README if applicable

## Decision Framework

Use Priit's 🟢🟡🔴 framework for changes:

### 🟢 Autonomous (Proceed Immediately)
- Fix typos in documentation
- Add comments to existing code
- Update examples in templates
- Format markdown files
- Fix broken links

### 🟡 Collaborative (Propose First)
- Add new agents to `.ai/3_agents/`
- Modify existing templates
- Change install.sh logic
- Add new tool support (e.g., add `.windsurf/`)
- Restructure directories

### 🔴 Always Ask Permission
- Remove existing agents
- Change symlink strategy
- Break backward compatibility
- Modify core principles (this file)
- Change repository structure fundamentally

## Compliance Requirements

### Version Control
- All changes must have clear commit messages
- Use conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`
- Reference issues when applicable

### Testing
- Install script must be tested on clean system
- Symlinks must resolve correctly
- All AI tools must read configs successfully

### Documentation
- README.md must be current
- All templates must have usage examples
- Breaking changes require migration guide

## Spec-Kit Alignment (This Repo)

### For This Dotfiles Repository
- `constitution.md` (this file) at root
- Changes tracked via git (not `specs/` folder needed)
- Issues tracked via GitHub issues
- Work is done directly on files (not spec-driven workflow)

### For Projects Using These Dotfiles
- Projects SHOULD create `constitution.md` using template
- Projects SHOULD use `specs/` folder structure
- Projects reference `~/.ai/4_specs/` templates
- See `.ai/0_core/spec-kit-alignment.md` for guidance

## Maintenance

### Update Frequency
- Review this constitution: Every 6 months
- Update agent definitions: As needed
- Update templates: When spec-kit changes
- Update tool wrappers: When AI tools update

### Versioning
- **Current Version**: 2.0 (agent-agnostic)
- **Previous Version**: 1.0 (Claude-only)
- **Next Version**: TBD

### Deprecation Policy
- 2 version grace period for breaking changes
- Migration guides required
- Clear deprecation warnings in commits

---

**Version**: 2.0
**Last Updated**: 2025-09-30
**Owner**: Priit
**Status**: Active
