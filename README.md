# Priit's Dotfiles

Agent-agnostic AI development environment configuration that works with Claude, Copilot, Gemini, and Cursor.

## What's Inside

### 🤖 Agent-Agnostic AI Framework (`.ai/`)
A shared core that works with **all AI tools** - write once, use everywhere:
- **Core standards** - Personality, coding standards, decision framework, git workflow
- **Workflows** - TDD workflow, pre-commit protocol
- **Specialized agents** - 6 expert agents that work across all AI tools

### 🛠️ Tool-Specific Configurations
Lightweight wrappers that import the shared core:
- **`.claude/`** - Claude Code configuration with Task delegation
- **`.copilot/`** - GitHub Copilot inline suggestions
- **`.gemini/`** - Google Gemini large-context analysis
- **`.cursor/`** - Cursor IDE integration

### 🐚 Shell Configuration
- **zshrc.template** - Modular Zsh configuration with oh-my-zsh & Powerlevel10k
- **zsh_plugins.txt** - Customizable Oh-My-Zsh plugin list
- **gitignore_global** - Global git ignore patterns
- **gitconfig.template** - Git configuration template

The install script dynamically builds your `.zshrc` based on installed tools:
- ✅ Installs Docker/Colima → Adds Docker/Testcontainers config
- ✅ Installs NVM → Adds NVM initialization
- ✅ Installs SDKMAN → Adds SDKMAN initialization
- ✅ Installs zsh plugins → Adds plugin sources

### 📦 Package Management
- **brew_apps.txt** - Homebrew CLI packages (with comment support)
- **brew_casks.txt** - Homebrew GUI applications (with comment support)
- **npm_packages.txt** - Global npm packages (with comment support)

## Repository Structure

```
dotfiles/
├── .ai/                                # 🎯 Agent-agnostic core (works with all tools)
│   ├── 0_core/
│   │   ├── priit-personality.md        # Buddy-cop relationship
│   │   ├── coding-standards.md         # TDD, quality standards
│   │   ├── decision-framework.md       # 🟢🟡🔴 action framework
│   │   └── git-workflow.md             # Pre-commit discipline
│   ├── 1_workflows/
│   │   ├── tdd-workflow.md             # Red-Green-Refactor process
│   │   └── pre-commit-protocol.md      # Quality gate protocol
│   └── 2_agents/
│       ├── README.md                   # Agent documentation
│       ├── spring-hex-bootstrapper.md  # 🏗️ Constructor Conway
│       ├── jira-to-spec.md             # 🌉 Valdis the Translator
│       ├── spring-hex-tdd-developer.md # 🦖 Rex the Red-Green-Refactor
│       ├── code-reviewer.md            # ⚖️ Judge Dredd Code
│       ├── test-fixer.md               # 🔬 Dr. Debugsworth McFixit
│       └── ai-dotfiles-architect.md    # 🏛️ Architect Anya
│
├── .claude/
│   ├── CLAUDE.md                       # Claude-specific wrapper
│   └── agents/ → ../.ai/2_agents/      # Symlink to shared agents
│
├── .copilot/
│   └── instructions.md                 # Copilot-specific wrapper
│
├── .gemini/
│   └── config.md                       # Gemini-specific wrapper
│
├── .cursor/
│   └── rules.md                        # Cursor-specific wrapper
│
├── zshrc.template                      # Modular zsh configuration
├── zsh_plugins.txt                     # Oh-My-Zsh plugins list
├── gitignore_global                    # Global gitignore
├── gitconfig.template                  # Git config template
├── brew_apps.txt                       # Homebrew packages list
├── brew_casks.txt                      # Homebrew casks list
├── npm_packages.txt                    # Global npm packages list
├── install.sh                          # Installation script
└── README.md                           # This file
```

## Specialized Agents (Work with ALL AI Tools)

### 🏗️ Constructor Conway
**Purpose:** Bootstrap Spring Boot projects with hexagonal architecture
**When to use:** Starting new projects with clean architecture
**Example:** "Bootstrap a Spring Boot project called 'order-service' with package 'com.example.orders'"

### 🌉 Valdis the Translator
**Purpose:** Translate Jira tasks into crystal-clear technical specifications
**When to use:** Converting vague requirements into actionable specs
**Example:** "Translate JIRA-123 into a technical specification"

### 🦖 Rex the Red-Green-Refactor
**Purpose:** TDD specialist for Spring Boot & hexagonal architecture
**When to use:** Implementing features with strict TDD discipline
**Example:** "Implement user authentication with TDD"

### ⚖️ Judge Dredd Code
**Purpose:** Rigorous code reviewer with zero tolerance for violations
**When to use:** Reviewing code for quality, architecture, best practices
**Example:** "Review this PR for architecture violations"

### 🔬 Dr. Debugsworth McFixit
**Purpose:** Test failure diagnostician and fixer extraordinaire
**When to use:** Fixing failing tests and diagnosing test issues
**Example:** "Fix the failing integration tests in UserService"

### 🏛️ Architect Anya
**Purpose:** AI configuration architect specializing in agent-agnostic dotfiles and workflow patterns
**When to use:** Creating new agents, designing configuration architecture, maintaining AI dotfiles
**Example:** "Anya, create a new agent for database migrations"

## Installation

### Prerequisites

- macOS (tested on macOS)
- At least one AI tool: Claude Code, GitHub Copilot, Cursor, or Gemini
- Optional: Homebrew (will be installed automatically if not present)

### Quick Start

```bash
# Clone this repository
git clone <your-repo-url> ~/Projects/dotfiles
cd ~/Projects/dotfiles

# Run installation script
./install.sh
```

The install script will:
1. **Install core configurations** (automatic):
   - Agent-agnostic AI core → `~/.ai/`
   - Tool-specific configs → `~/.claude/`, `~/.copilot/`, `~/.gemini/`, `~/.cursor/`
   - Homebrew (if not present)
   - Oh My Zsh (if not present)
   - Powerlevel10k theme (if not present)
   - Shell configurations (zshrc, gitignore_global)
   - Essential dev tools (pre-commit, shellcheck)

2. **Create gitconfig** (interactive):
   - Prompts for git user name and email
   - Optional: 1Password SSH commit signing

3. **Optional installations** (prompted):
   - Homebrew packages from `brew_apps.txt` (git, docker, nvm, etc.)
   - GUI applications from `brew_casks.txt` (1Password, VS Code, iTerm2, etc.)
   - Global npm packages from `npm_packages.txt`
   - SDKMAN + Java 21
   - NVM + Node.js LTS
   - Zsh plugins (syntax-highlighting, autosuggestions)
   - macOS defaults (Dock, Finder, Trackpad, Dark Mode)

4. **Safety features**:
   - Backup existing files with timestamps
   - Non-destructive symlink creation
   - Comment support in apps.txt/casks.txt (lines starting with `#`)

### Customizing Package Lists

Edit `brew_apps.txt`, `brew_casks.txt`, and `npm_packages.txt` to customize what gets installed:

**brew_apps.txt** (Homebrew CLI packages):
```txt
# Core development tools
git
docker
docker-compose

# Comment out packages you don't want
# awscli

# Empty lines are ignored
```

**brew_casks.txt** (GUI applications):
```txt
# Development Tools
iterm2
visual-studio-code

# Comment out apps you don't need
# figma
# slack
```

**npm_packages.txt** (Global npm packages):
```txt
# AI development tools
@anthropic-ai/claude-code

# Comment out packages you don't want
# @github/copilot
```

### Post-Installation

After running `install.sh`:

1. **Reload shell configuration**:
   ```bash
   source ~/.zshrc
   ```

2. **Configure Powerlevel10k** (if first time):
   ```bash
   p10k configure
   ```

3. **Verify AI tools can see configs**:
   ```bash
   # Check symlinks
   ls -la ~/.ai ~/.claude ~/.copilot ~/.gemini ~/.cursor
   ```

## Using with Different AI Tools

### Claude Code
Automatically reads from `~/.claude/CLAUDE.md` which imports from `~/.ai/`

**Delegate to agents:**
```
"Use the Constructor Conway agent to bootstrap a new project"
"Delegate to Rex to implement this feature with TDD"
"Have Judge Dredd review this PR"
```

### GitHub Copilot
Automatically reads from `~/.copilot/instructions.md`

**Pattern matching:**
- Inline suggestions follow coding standards
- Apply TDD patterns automatically
- Match style of surrounding code

### Google Gemini
Reads configuration from `~/.gemini/config.md`

**Large context analysis:**
- Analyze entire codebase patterns
- Cross-file refactoring suggestions
- Architectural consistency checks

### Cursor IDE
Reads rules from `~/.cursor/rules.md`

**Editor integration:**
- cmd+k (or ctrl+k) applies standards
- TDD workflow enforcement
- Agent delegation suggestions

## Project-Level Configuration

Your global settings in `~/.ai/` apply everywhere. For project-specific context, create `.claude/CLAUDE.md` (or equivalent) in the project root:

### Simple Project (Single File)

**Option 1: Add context only** (global settings still apply)
```markdown
# Project Context

## Tech Stack
- Backend: Spring Boot 3.2, Java 21
- Architecture: Hexagonal (Ports & Adapters)
- Database: PostgreSQL with Flyway migrations
- Testing: JUnit 5, Testcontainers, ArchUnit

## Domain
- E-commerce order processing system
- Team size: 4 backend developers

## Project-Specific Rules
- All domain logic must be in hexagon (no Spring annotations in domain)
- Use records for DTOs and value objects
- Integration tests must use Testcontainers
- Commit message format: `[STORY-123] Add feature description`
```

**Option 2: Override global settings** (if you need different behavior)
```markdown
# Project-Specific Configuration

# Import only what you want from global settings
@import ~/.ai/0_core/priit-personality.md
@import ~/.ai/0_core/coding-standards.md

# Skip git-workflow.md because this project uses different commit format

## Tech Stack
- Backend: Spring Boot 3.2, Java 21

## Custom Git Workflow
- Commit format: `[STORY-123] Add feature description`
- No pre-commit hooks (legacy project, gradual migration)
```

### Complex Project (Split Files)

For larger projects, organize like the global config:

```
your-project/
├── .claude/
│   ├── CLAUDE.md                    # Main config (imports everything)
│   ├── tech-stack.md                # Tech stack details
│   ├── architecture.md              # Architecture decisions
│   └── team-conventions.md          # Team-specific rules
```

**`.claude/CLAUDE.md`** (main config):
```markdown
# Project Configuration

# Import global Priit settings
@import ~/.ai/0_core/priit-personality.md
@import ~/.ai/0_core/coding-standards.md
@import ~/.ai/0_core/git-workflow.md

# Import project-specific files
@import tech-stack.md
@import architecture.md
@import team-conventions.md
```

**`.claude/tech-stack.md`**:
```markdown
# Tech Stack

## Backend
- Spring Boot 3.2, Java 21
- PostgreSQL with Flyway migrations
- Redis for caching

## Testing
- JUnit 5, Testcontainers, ArchUnit
- WireMock for external API mocking
```

**`.claude/architecture.md`**:
```markdown
# Architecture Guidelines

## Hexagonal Architecture
- All domain logic must be in hexagon (no Spring annotations in domain)
- Adapters live in `infrastructure/` package
- Use cases in `application/` package

## Package Structure
```
com.example.orders/
├── domain/          # Pure business logic
├── application/     # Use cases
└── infrastructure/  # Adapters (DB, REST, etc)
```
```

**`.claude/team-conventions.md`**:
```markdown
# Team Conventions

## Git Workflow
- Commit format: `[STORY-123] Add feature description`
- Branch naming: `feature/STORY-123-short-description`
- PR must have 2 approvals

## Code Review
- No PRs over 400 lines
- All tests must pass before review
- ArchUnit tests verify hexagonal boundaries
```

### Quick Examples

**Frontend React Project:**
```markdown
# Project Context
- Tech stack: React 18, TypeScript, Vite, TailwindCSS
- State management: Zustand
- Testing: Vitest, Testing Library
- API: REST with React Query
- Commit format: `feat(component): description` (conventional commits)
```

**Python Data Pipeline:**
```markdown
# Project Context
- Tech stack: Python 3.11, FastAPI, Pandas, SQLAlchemy
- Code style: Black, ruff, mypy strict mode
- Testing: pytest with fixtures, pytest-asyncio
- Infrastructure: Docker, Kubernetes, Terraform
- Commit format: Jira ticket in commit body
```

## Key Features

### Agent-Agnostic
- Write your preferences once in `~/.ai/`
- All AI tools automatically use them
- No duplication across tool configs

### Specialized Agents
- 5 expert agents for different workflows
- Work consistently across all AI tools
- Clear delegation patterns

### TDD Workflow
- Red-Green-Refactor enforcement
- Pre-commit quality gates
- Test-first mindset baked in

### Git Discipline
- Pre-commit hook failure protocol
- Forbidden flags (`--no-verify`)
- Quality over speed always

### Decision Framework
- 🟢 Autonomous: Fix tests, linting, typos
- 🟡 Collaborative: Multi-file changes, features
- 🔴 Ask First: Rewrites, business logic, security

### Buddy-Cop Relationship
- Address me as "Priit" (or fun variants)
- Collaborative team dynamic
- Humor welcome, quality mandatory

## Updating

To update the dotfiles:

```bash
cd ~/Projects/dotfiles
git pull
./install.sh  # Re-run to update symlinks
```

## Uninstalling

To remove the dotfiles:

```bash
# Remove symlinks
rm ~/.ai ~/.claude ~/.copilot ~/.gemini ~/.cursor ~/.zshrc ~/.gitignore_global

# Restore backups (if desired)
# Look for *.backup.* files in your home directory
```
