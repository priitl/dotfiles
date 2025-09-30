# Priit's Dotfiles

Personal development environment configuration and Claude AI agent workflows.

## What's Inside

### Shell Configuration
- **zshrc** - Zsh with oh-my-zsh, Powerlevel10k theme, Docker/Colima setup
- **gitignore_global** - Global git ignore patterns
- **gitconfig.template** - Git configuration template

### Claude AI Agent Workflows
A collection of specialized AI agents in `.claude/agents/` for software development:
- 🏗️ Constructor Conway (project bootstrapper)
- 🌉 Valdis the Translator (Jira to specs)
- 🦖 Rex the Red-Green-Refactor (TDD developer)
- ⚖️ Judge Dredd Code (code reviewer)
- 🔬 Dr. Debugsworth McFixit (test fixer)

See `.claude/agents/README.md` for detailed agent documentation.

## Repository Structure

```
dotfiles/
├── .claude/
│   ├── CLAUDE.md                      # Global Claude Code instructions
│   └── agents/
│       ├── README.md                  # Agent documentation
│       ├── spring-hex-bootstrapper.md # Constructor Conway
│       ├── jira-to-spec.md            # Valdis the Translator
│       ├── spring-hex-tdd-developer.md# Rex the Red-Green-Refactor
│       ├── code-reviewer.md           # Judge Dredd Code
│       └── test-fixer.md              # Dr. Debugsworth McFixit
├── zshrc                              # Zsh configuration
├── gitignore_global                   # Global gitignore
├── gitconfig.template                 # Git config template
├── install.sh                         # Installation script
└── README.md                          # This file
```

## Installation

### Prerequisites

- macOS (tested on macOS)
- Zsh with oh-my-zsh
- Powerlevel10k theme
- Claude Code CLI installed (for agents)
- Homebrew (for shell enhancements)

### Quick Start

```bash
# Clone this repository
git clone <your-repo-url> ~/Projects/dotfiles
cd ~/Projects/dotfiles

# Run installation script
./install.sh
```

The install script will:
1. Install Powerlevel10k theme (if not already installed)
2. Backup existing dotfiles (with timestamp)
3. Create symlinks for:
   - `~/.claude` → `~/Projects/dotfiles/.claude`
   - `~/.zshrc` → `~/Projects/dotfiles/zshrc`
   - `~/.gitignore_global` → `~/Projects/dotfiles/gitignore_global`
4. Create `~/.gitconfig` from template if it doesn't exist (with interactive prompts)

### Post-Installation

After running `install.sh`:

1. **Reload shell configuration**:
   ```bash
   source ~/.zshrc
   ```

2. **Configure Powerlevel10k** (if first time):
   - The configuration wizard will start automatically on first shell launch
   - Or manually run: `p10k configure`

3. **Configure global gitignore**:
   ```bash
   git config --global core.excludesfile ~/.gitignore_global
   ```

### Manual Installation

Not recommended. Use `install.sh` instead for proper setup including Git configuration.