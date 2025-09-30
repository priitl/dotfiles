#!/usr/bin/env bash

# Dotfiles Installation Script
# Installs Claude AI agent configurations and shell dotfiles

set -e

DOTFILES_DIR="$HOME/Projects/dotfiles"
CLAUDE_DIR="$HOME/.claude"

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

echo "=== Installing Claude AI Agents ==="
echo ""
backup_and_link "$DOTFILES_DIR/.claude" "$CLAUDE_DIR" ".claude"
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
    read -p "Enter your Git name (e.g., John Doe): " git_name
    while [ -z "$git_name" ]; do
        echo "❌ Name cannot be empty"
        read -p "Enter your Git name: " git_name
    done

    # Prompt for git email
    read -p "Enter your Git email (e.g., john@example.com): " git_email
    while [ -z "$git_email" ]; do
        echo "❌ Email cannot be empty"
        read -p "Enter your Git email: " git_email
    done

    # Prompt for 1Password SSH signing (optional)
    echo ""
    echo "Do you want to enable commit signing with 1Password SSH?"
    echo "(Requires 1Password with SSH agent enabled)"
    read -p "Enable commit signing? [y/N]: " enable_signing

    # Create gitconfig from template
    cp "$DOTFILES_DIR/gitconfig.template" "$HOME/.gitconfig"

    # Replace placeholders
    sed -i '' "s/YOUR_NAME/$git_name/" "$HOME/.gitconfig"
    sed -i '' "s/YOUR_EMAIL/$git_email/" "$HOME/.gitconfig"

    # Enable signing if requested
    if [[ "$enable_signing" =~ ^[Yy]$ ]]; then
        echo ""
        read -p "Enter your SSH signing key (or press Enter to skip): " signing_key

        if [ -n "$signing_key" ]; then
            # Uncomment signing configuration
            sed -i '' 's/# \[gpg\]/[gpg]/' "$HOME/.gitconfig"
            sed -i '' 's/# 	format = ssh/	format = ssh/' "$HOME/.gitconfig"
            sed -i '' 's/# \[gpg "ssh"\]/[gpg "ssh"]/' "$HOME/.gitconfig"
            sed -i '' 's|# 	program = /Applications/1Password.app.*|	program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign|' "$HOME/.gitconfig"
            sed -i '' 's/# \[commit\]/[commit]/' "$HOME/.gitconfig"
            sed -i '' 's/# 	gpgsign = true/	gpgsign = true/' "$HOME/.gitconfig"
            sed -i '' "s|# signingkey = YOUR_SSH_KEY.*|	signingkey = $signing_key|" "$HOME/.gitconfig"
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
if [ -L "$CLAUDE_DIR" ] && [ -d "$CLAUDE_DIR" ]; then
    echo "✅ Installation complete!"
    echo ""
    echo "📚 Available agents:"
    echo "   🏗️  Constructor Conway     - Bootstrap Spring Boot projects"
    echo "   🌉 Valdis the Translator  - Jira to technical specs"
    echo "   🦖 Rex the Red-Green-Refactor - TDD implementation"
    echo "   ⚖️  Judge Dredd Code       - Code reviews"
    echo "   🔬 Dr. Debugsworth McFixit - Test failure diagnosis"
    echo ""
    echo "🚀 Quick start:"
    echo "   1. Open Claude Code CLI"
    echo "   2. Try: 'Bootstrap a Spring Boot project called \"demo\" with package \"com.example.demo\"'"
    echo ""
    echo "📖 For more info: cat ~/Projects/dotfiles/README.md"
else
    echo "❌ Installation failed - symlink not created correctly"
    exit 1
fi