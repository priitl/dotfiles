#!/usr/bin/env bash

# Dotfiles Installation Script
# Installs Claude AI agent configurations and shell dotfiles

set -e

DOTFILES_DIR="$HOME/Projects/dotfiles"
AI_DIR="$HOME/.ai"
CLAUDE_DIR="$HOME/.claude"
COPILOT_DIR="$HOME/.copilot"
GEMINI_DIR="$HOME/.gemini"
CURSOR_DIR="$HOME/.cursor"

echo "🤖 Installing Priit's Dotfiles..."
echo ""

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "❌ Error: Dotfiles directory not found at $DOTFILES_DIR"
    echo "   Please clone the repository to ~/Projects/dotfiles first"
    exit 1
fi

# Function to backup and symlink
backup_and_link() {
    local source="$1"
    local target="$2"
    local name="$3"

    if [ -e "$target" ] || [ -L "$target" ]; then
        BACKUP="$target.backup.$(date +%Y%m%d_%H%M%S)"
        echo "📦 Backing up existing $name to: $BACKUP"
        mv "$target" "$BACKUP"
    fi

    echo "🔗 Creating symlink: $target -> $source"
    ln -s "$source" "$target"
    echo "   ✓ $name linked"
}

echo "=== Installing Agent-Agnostic AI Core ==="
echo ""
backup_and_link "$DOTFILES_DIR/.ai" "$AI_DIR" ".ai (agent-agnostic core)"
echo ""

echo "=== Installing Tool-Specific Configurations ==="
echo ""
backup_and_link "$DOTFILES_DIR/.claude" "$CLAUDE_DIR" ".claude (Claude Code)"
backup_and_link "$DOTFILES_DIR/.copilot" "$COPILOT_DIR" ".copilot (GitHub Copilot)"
backup_and_link "$DOTFILES_DIR/.gemini" "$GEMINI_DIR" ".gemini (Google Gemini)"
backup_and_link "$DOTFILES_DIR/.cursor" "$CURSOR_DIR" ".cursor (Cursor IDE)"
echo ""

echo "=== Installing Developer Tools ==="
echo ""
# Check for Homebrew and install if not found
if ! command -v brew &> /dev/null; then
    echo "🍺 Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "🍺 Homebrew already installed. Updating..."
    brew update
fi

echo "🔧 Installing pre-commit and shellcheck..."
brew install pre-commit shellcheck

echo "🔧 Installing pre-commit hooks..."
pre-commit install

echo ""

echo "=== Installing Powerlevel10k ==="
echo ""

# Check if Powerlevel10k is already installed
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "📥 Cloning Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    echo "   ✓ Powerlevel10k installed"
else
    echo "ℹ️  Powerlevel10k already installed"
fi
echo ""

echo "=== Installing Shell Configuration ==="
echo ""
backup_and_link "$DOTFILES_DIR/zshrc" "$HOME/.zshrc" "zshrc"
backup_and_link "$DOTFILES_DIR/gitignore_global" "$HOME/.gitignore_global" "gitignore_global"
echo ""

# Check if gitconfig exists
if [ ! -f "$HOME/.gitconfig" ]; then
    echo "📝 Setting up Git configuration..."
    echo ""

    # Prompt for git user name
    read -r -p "Enter your Git name (e.g., John Doe): " git_name
    while [ -z "$git_name" ]; do
        echo "❌ Name cannot be empty"
        read -r -p "Enter your Git name: " git_name
    done

    # Prompt for git email
    read -r -p "Enter your Git email (e.g., john@example.com): " git_email
    while [ -z "$git_email" ]; do
        echo "❌ Email cannot be empty"
        read -r -p "Enter your Git email: " git_email
    done

    # Prompt for 1Password SSH signing (optional)
    echo ""
    echo "Do you want to enable commit signing with 1Password SSH?"
    echo "(Requires 1Password with SSH agent enabled)"
    read -r -p "Enable commit signing? [y/N]: " enable_signing

    # Create gitconfig from template
    cp "$DOTFILES_DIR/gitconfig.template" "$HOME/.gitconfig"

    # Replace placeholders
    # Use .bak extension for sed -i to be compatible with both GNU and BSD sed.
    sed -i '.bak' "s/YOUR_NAME/$git_name/" "$HOME/.gitconfig"
    sed -i '.bak' "s/YOUR_EMAIL/$git_email/" "$HOME/.gitconfig"

    # Enable signing if requested
    if [[ "$enable_signing" =~ ^[Yy]$ ]]; then
        echo ""
        read -r -p "Enter your SSH signing key (or press Enter to skip): " signing_key

        if [ -n "$signing_key" ]; then
            # Uncomment signing configuration
            sed -i '.bak' 's/# \[gpg\]/[gpg]/' "$HOME/.gitconfig"
            sed -i '.bak' 's/# 	format = ssh/	format = ssh/' "$HOME/.gitconfig"
            sed -i '.bak' 's/# \[gpg "ssh"\]/[gpg "ssh"]/' "$HOME/.gitconfig"
            sed -i '.bak' 's|# 	program = /Applications/1Password.app.*|	program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign|' "$HOME/.gitconfig"
            sed -i '.bak' 's/# \[commit\]/[commit]/' "$HOME/.gitconfig"
            sed -i '.bak' 's/# 	gpgsign = true/	gpgsign = true/' "$HOME/.gitconfig"
            sed -i '.bak' "s|# signingkey = YOUR_SSH_KEY.*|	signingkey = $signing_key|" "$HOME/.gitconfig"
            # Remove backup files created by sed
            rm "$HOME/.gitconfig.bak"*
        fi
    fi

    echo ""
    echo "   ✓ .gitconfig created and configured"
else
    echo "ℹ️  Skipping .gitconfig (already exists)"
    echo "   Template available at: $DOTFILES_DIR/gitconfig.template"
fi
echo ""

# Verify installation
if [ -L "$AI_DIR" ] && [ -d "$AI_DIR" ] && [ -L "$CLAUDE_DIR" ] && [ -d "$CLAUDE_DIR" ]; then
    echo "✅ Installation complete!"
    echo ""
    echo "🎯 Agent-Agnostic AI Framework Installed:"
    echo "   ~/.ai/            - Shared core (works with all AI tools)"
    echo "   ~/.claude/        - Claude Code configuration"
    echo "   ~/.copilot/       - GitHub Copilot configuration"
    echo "   ~/.gemini/        - Google Gemini configuration"
    echo "   ~/.cursor/        - Cursor IDE configuration"
    echo ""
    echo "📚 Available agents (work with all AI tools):"
    echo "   🏗️ Constructor Conway         - Bootstrap Spring Boot projects"
    echo "   🌉 Valdis the Translator      - Jira to technical specs"
    echo "   🦖 Rex the Red-Green-Refactor - TDD implementation"
    echo "   ⚖️ Judge Dredd Code           - Code reviews"
    echo "   🔬 Dr. Debugsworth McFixit    - Test failure diagnosis"
    echo "   🏛️ Architect Anya             - AI dotfiles architecture"
    echo ""
    echo "🚀 Quick start with Claude Code:"
    echo "   1. Open Claude Code CLI in any project"
    echo "   2. Try: 'Bootstrap a Spring Boot project called \"demo\" with package \"com.example.demo\"'"
    echo ""
    echo "💡 Quick start with other tools:"
    echo "   - GitHub Copilot: Opens instructions from ~/.copilot/instructions.md"
    echo "   - Cursor: Opens rules from ~/.cursor/rules.md"
    echo "   - Gemini: Opens config from ~/.gemini/config.md"
    echo ""
    echo "📖 For more info: cat ~/Projects/dotfiles/README.md"
else
    echo "❌ Installation failed - symlinks not created correctly"
    exit 1
fi
