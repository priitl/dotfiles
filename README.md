# Priit's Dotfiles

Agent-agnostic AI development environment configuration that works with Claude, Copilot, Gemini, and Cursor.

## What's Inside

### 🤖 Agent-Agnostic AI Framework (`.ai/`)
A shared core that works with **all AI tools** - agents and commands reusable everywhere:
- **Spec templates** (`1_templates/`) - Templates for specifications, plans, and tasks (7 templates)
- **Commands** (`2_commands/`) - Spec-kit commands and tools (67 total: 48 tools + 19 workflows)
- **Tech stacks** (`3_tech_stacks/`) - Spring Boot, dotfiles, AI configuration patterns (3 references)
- **Specialized agents** (`4_agents/`) - 27 expert agents organized by workflow phase

### 🛠️ Tool-Specific Configurations
Self-contained configs optimized for each tool:
- **`.claude/`** - Claude Code configuration with Task delegation and TodoWrite
- **`.copilot/`** - GitHub Copilot inline suggestions and pattern matching
- **`.gemini/`** - Google Gemini large-context analysis and cross-file consistency
- **`.cursor/`** - Cursor IDE integration with cmd+k optimization

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
│   ├── 1_templates/                    # Spec templates (7)
│   │   ├── spec-template.md            # Specification template
│   │   ├── plan-template.md            # Implementation plan template
│   │   ├── tasks-template.md           # Task breakdown template
│   │   ├── bootstrap-template.md       # Project bootstrap template
│   │   ├── review-template.md          # Code review template
│   │   ├── constitution-template.md    # Constitution template
│   │   └── agents-template.md          # AGENTS.md template
│   ├── 2_commands/                     # Commands and tools (67)
│   │   ├── workflows/                  # Multi-agent orchestration (19)
│   │   │   ├── spec-driven.md          # Complete Spec → Plan → Build → Verify
│   │   │   └── ...                     # 18 more workflow commands
│   │   └── [tools]                     # Single-purpose tools (48)
│   │       ├── constitution.md         # Bootstrap project constitution
│   │       ├── specify.md              # Create feature specification
│   │       ├── clarify.md              # Refine vague requirements
│   │       ├── plan.md                 # Create implementation plan
│   │       ├── tasks.md                # Generate task breakdown
│   │       ├── analyze.md              # Analyze spec consistency
│   │       ├── bootstrap.md            # Bootstrap new project
│   │       ├── implement.md            # Execute implementation
│   │       ├── spec-review.md          # Spec-driven code review
│   │       ├── fix.md                  # Fix failures
│   │       └── ...                     # 38 more tools
│   ├── 3_tech_stacks/                  # Tech references (3)
│   │   ├── tech-stack-spring-hex.md    # Spring Boot + hexagonal patterns
│   │   ├── tech-stack-dotfiles.md      # Shell script patterns
│   │   └── tech-stack-ai.md            # AI configuration patterns
│   ├── 4_agents/                       # Specialized agents (28)
│   │   ├── speccing/                   # Requirements → Specs (empty)
│   │   ├── planning/                   # Specs → Plans (empty)
│   │   ├── engineering/                # Language specialists (8)
│   │   │   ├── backend-architect.md
│   │   │   ├── frontend-developer.md
│   │   │   ├── golang-pro.md
│   │   │   ├── java-pro.md
│   │   │   ├── javascript-pro.md
│   │   │   ├── python-pro.md
│   │   │   ├── rust-pro.md
│   │   │   └── typescript-pro.md
│   │   ├── quality/                    # Testing & review (6)
│   │   │   ├── code-reviewer.md
│   │   │   ├── debugger.md
│   │   │   ├── error-detective.md
│   │   │   ├── security-auditor.md
│   │   │   ├── tdd-orchestrator.md
│   │   │   └── test-automator.md
│   │   ├── infrastructure/             # DevOps, cloud (6)
│   │   │   ├── cloud-architect.md
│   │   │   ├── deployment-engineer.md
│   │   │   ├── devops-troubleshooter.md
│   │   │   ├── kubernetes-architect.md
│   │   │   ├── network-engineer.md
│   │   │   └── terraform-specialist.md
│   │   ├── data/                       # Data engineering, ML (5)
│   │   │   ├── ai-engineer.md
│   │   │   ├── data-engineer.md
│   │   │   ├── data-scientist.md
│   │   │   ├── ml-engineer.md
│   │   │   └── mlops-engineer.md
│   │   └── business/                   # Content, support, analysis (3)
│   │       ├── business-analyst.md
│   │       ├── content-marketer.md
│   │       └── customer-support.md
│
├── .claude/
│   ├── CLAUDE.md                       # Claude-specific config (self-contained)
│   └── agents/ → ../.ai/4_agents/      # Symlink to shared agents
│
├── .copilot/
│   └── instructions.md                 # Copilot-specific config (self-contained)
│
├── .gemini/
│   └── GEMINI.md                       # Gemini-specific config (self-contained)
│
├── .cursor/
│   └── rules.md                        # Cursor-specific config (self-contained)
│
├── .archive/                           # Archived files (gitignored)
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

## Specialized Agents

28 specialized agents available in `.ai/4_agents/`:
- **Engineering (8):** Language specialists (Python, Java, TypeScript, JavaScript, Golang, Rust, backend, frontend)
- **Quality (6):** Testing, debugging, security, code review
- **Infrastructure (6):** Cloud, Kubernetes, DevOps, networking, Terraform, deployment
- **Data (5):** ML, MLOps, AI, data engineering, data science
- **Business (3):** Business analysis, content marketing, customer support

Access agents via your AI tool's agent delegation features.

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
Automatically reads from `~/.claude/CLAUDE.md`

**Features:**
- Task tool for agent delegation
- TodoWrite for task tracking
- Access to 28 specialized agents via Task tool

### GitHub Copilot
Automatically reads from `~/.copilot/instructions.md`

**Pattern matching:**
- Inline suggestions follow coding standards
- Apply TDD patterns automatically
- Match style of surrounding code

### Google Gemini
Reads configuration from `~/.gemini/GEMINI.md`

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

## Using AGENTS.md in Projects

Following the https://agents.md/ specification, projects can have an `AGENTS.md` file providing instructions for AI coding agents.

### What is AGENTS.md?

`AGENTS.md` is **NOT** about listing AI agents - it's about **teaching AI tools how to work on your project**:
- Setup commands
- Code style guidelines
- Testing instructions
- PR requirements

Think of it as a README specifically for AI tools.

### Bootstrap Documentation for New Projects

Create `constitution.md` and `AGENTS.md` files for your project following the spec-kit format.

Use the templates in `.ai/1_templates/` as starting points:
- **`constitution-template.md`** - Foundational principles + technical guidelines
- **`agents-template.md`** - Practical AI instructions

Example generated `AGENTS.md`:

```markdown
# My Project AI Agents

## Setup Commands
npm install
npm run dev

## Code Style
- TypeScript strict mode
- Use functional patterns
- Single quotes, no semicolons

## Testing Instructions
npm test
npm run test:e2e

## PR Instructions
- Run tests before committing
- Commit format: [PROJ-123] Description
- Get 2 approvals before merge
```

### How It Works With constitution.md

**constitution.md** - Principles (what the project believes):
- Tech stack
- Architecture decisions
- Non-negotiable constraints
- `tech_stack: spring`

**AGENTS.md** - Practical instructions (how to work on it):
- Setup commands
- Code style
- Testing workflow
- PR requirements

**Together:** AI tools read both files to understand project principles AND practical workflow.

### Benefits

- ✅ **Standardized** - Follows agents.md specification
- ✅ **Tool agnostic** - Works with Claude, Copilot, Gemini, Cursor
- ✅ **Practical** - Actionable instructions for AI agents
- ✅ **Complementary** - Works alongside constitution.md

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

# Note: Tool configs are self-contained (no imports needed)
# Define project-specific overrides here

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

Note: Global configs are already self-contained in ~/.claude/CLAUDE.md
This file provides project-specific context only.

## Tech Stack
See tech-stack.md

## Architecture
See architecture.md

## Team Conventions
See team-conventions.md
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
- Shared agents in `~/.ai/4_agents/` work with all tools
- Tool configs are self-contained (no imports)
- Agents and commands referenced consistently

### Specialized Agents
- 28 expert agents organized by category
- Work consistently across all AI tools
- Tech stack coverage: engineering, quality, infrastructure, data, business

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
