#!/usr/bin/env bash

# Dotfiles Installation Script
# Installs Claude AI agent configurations and shell dotfiles

set -e

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Projects/dotfiles}"
AI_DIR="$HOME/.ai"
CLAUDE_DIR="$HOME/.claude"
COPILOT_DIR="$HOME/.copilot"
GEMINI_DIR="$HOME/.gemini"
CURSOR_DIR="$HOME/.cursor"
LOG_FILE="$HOME/.dotfiles_install.log"

echo "🤖 Installing Priit's Dotfiles..."
echo ""

# Initialize installation log
init_log() {
    cat > "$LOG_FILE" <<EOF
# Dotfiles Installation Log
# Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
# This file tracks what was installed and can be used by uninstaller.sh
INSTALL_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
DOTFILES_DIR=$DOTFILES_DIR
EOF
}

# Log an action
log_action() {
    local action_type="$1"
    local target="$2"
    local source="${3:-}"

    case "$action_type" in
        SYMLINK)
            echo "SYMLINK=$target:$source" >> "$LOG_FILE"
            ;;
        FILE)
            echo "FILE=$target" >> "$LOG_FILE"
            ;;
        BACKUP)
            echo "BACKUP=$target" >> "$LOG_FILE"
            ;;
        OPTION)
            echo "$target=$source" >> "$LOG_FILE"
            ;;
    esac
}

# Initialize log file
init_log

# Ask about backups
echo "Do you want to create backups of existing files before symlinking?"
echo "(Backups will be saved with timestamp: file.backup.YYYYMMDD_HHMMSS)"
read -r -p "Create backups? [Y/n]: " CREATE_BACKUPS
CREATE_BACKUPS=${CREATE_BACKUPS:-Y}
echo ""

# Ask for sudo password upfront if needed
SUDO_KEEPALIVE_PID=""
if [[ "$INSTALL_PACKAGES" == "true" ]] || [[ "$INSTALL_MACOS_DEFAULTS" == "true" ]]; then
    sudo -v
    # Keep-alive: update existing sudo time stamp for 15 minutes max (security)
    (
        # shellcheck disable=SC2034
        for i in {1..15}; do
            sudo -n true || break
            sleep 60
        done
    ) &
    SUDO_KEEPALIVE_PID=$!
fi

# Cleanup sudo keep-alive on exit
cleanup_sudo() {
    if [ -n "$SUDO_KEEPALIVE_PID" ]; then
        kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
    fi
}
trap cleanup_sudo EXIT

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

    # Validate parameters
    if [ -z "$source" ] || [ -z "$target" ] || [ -z "$name" ]; then
        echo "❌ Error: backup_and_link() requires all parameters"
        return 1
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
        if [[ "$CREATE_BACKUPS" =~ ^[Yy]$ ]]; then
            BACKUP="$target.backup.$(date +%Y%m%d_%H%M%S)"
            echo "📦 Backing up existing $name to: $BACKUP"
            mv "$target" "$BACKUP"
            log_action "BACKUP" "$BACKUP"
        else
            echo "⚠️  Removing existing $name (no backup)"
            rm -rf "$target"
        fi
    fi

    echo "🔗 Creating symlink: $target -> $source"
    ln -s "$source" "$target"
    log_action "SYMLINK" "$target" "$source"
    echo "   ✓ $name linked"
}

# Validate required files exist and are readable
validate_required_files() {
    local file
    for file in "$@"; do
        if [ ! -f "$file" ]; then
            echo "❌ Error: Required file not found: $file"
            exit 1
        fi
        if [ ! -r "$file" ]; then
            echo "❌ Error: Cannot read file: $file"
            exit 1
        fi
    done
}

# Array to track failed installations
FAILED_INSTALLS=()

# Function to add tool configuration to zshrc
add_tool_config() {
    local config_name="$1"
    local config_content="$2"

    if [ ! -f "$HOME/.zshrc" ]; then
        echo "⚠️  .zshrc not found, skipping $config_name configuration"
        return 1
    fi

    # Check if this config already exists
    if grep -q "# $config_name" "$HOME/.zshrc" 2>/dev/null; then
        echo "   ✓ $config_name already configured in .zshrc"
        return 0
    fi

    # Insert before TOOL_CONFIGS_MARKER or at the end if marker doesn't exist
    if grep -q "# TOOL_CONFIGS_MARKER" "$HOME/.zshrc" 2>/dev/null; then
        # Write config to temp file
        local config_file
        config_file=$(mktemp)
        echo "$config_content" > "$config_file"

        # Insert before marker using sed
        sed "/# TOOL_CONFIGS_MARKER/r $config_file" "$HOME/.zshrc" > "$HOME/.zshrc.tmp"
        mv "$HOME/.zshrc.tmp" "$HOME/.zshrc"
        rm "$config_file"

        echo "   ✓ $config_name configuration added to .zshrc"
    else
        # Append to end if no marker
        echo "" >> "$HOME/.zshrc"
        echo "$config_content" >> "$HOME/.zshrc"
        echo "   ✓ $config_name configuration appended to .zshrc"
    fi
}

echo ""
read -r -p "🤖 Install AI agent configurations (.ai, .claude, .copilot, etc.)? [Y/n]: " install_ai
install_ai=${install_ai:-Y}
log_action "OPTION" "AI_CONFIGS" "$install_ai"

if [[ "$install_ai" =~ ^[Yy]$ ]]; then
    echo ""
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
    # Symlink agents into .claude for backward compatibility
    if [ -L "$CLAUDE_DIR" ] || [ -d "$CLAUDE_DIR" ]; then
        backup_and_link "$AI_DIR/5_agents" "$CLAUDE_DIR/agents" ".claude/agents"
        backup_and_link "$AI_DIR/3_commands" "$CLAUDE_DIR/commands" ".claude/commands"
    fi
    echo ""
else
    echo "⏭️  Skipping AI configurations"
    echo ""
fi

echo "=== Installing Developer Tools ==="
echo ""
# Check for Homebrew and install if not found
if ! command -v brew &> /dev/null; then
    echo "🍺 Homebrew not found."
    echo ""
    echo "⚠️  WARNING: This will download and execute Homebrew's installation script."
    echo "   Command: curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash"
    echo "   This is the standard installation method from https://brew.sh"
    echo ""
    read -r -p "Continue with Homebrew installation? [y/N]: " install_homebrew
    if [[ ! "$install_homebrew" =~ ^[Yy]$ ]]; then
        echo "⚠️  Skipping Homebrew installation. Some features may not work."
        echo "   You can install Homebrew later by running:"
        echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        # Set flag to skip brew-dependent installations
        export SKIP_BREW=true
    else
        echo "📥 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || true
    fi

    # Add Homebrew to PATH for Apple Silicon and Intel Macs
    if [ -d "/opt/homebrew/bin" ]; then
        export PATH="/opt/homebrew/bin:$PATH"
    else
        export PATH="/usr/local/bin:$PATH"
    fi
else
    echo "🍺 Homebrew already installed. Updating..."
    brew update || true
fi

if [[ "${SKIP_BREW:-false}" != "true" ]]; then
    echo "🔧 Installing essential developer tools..."
    brew install pre-commit shellcheck || true

    echo "🔧 Installing pre-commit hooks..."
    pre-commit install || true
else
    echo "⚠️  Skipping developer tools (Homebrew not installed)"
fi

echo ""
read -r -p "🐚 Install Zsh configurations (Oh My Zsh, Powerlevel10k, .zshrc)? [Y/n]: " install_zsh
install_zsh=${install_zsh:-Y}
log_action "OPTION" "ZSH_CONFIGS" "$install_zsh"

if [[ "$install_zsh" =~ ^[Yy]$ ]]; then
    echo ""
    echo "=== Installing Oh My Zsh ==="
    echo ""
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "📥 Installing Oh My Zsh..."
        RUNZSH=no KEEP_ZSHRC=yes CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
        echo "   ✓ Oh My Zsh installed"
    else
        echo "ℹ️  Oh My Zsh already installed"
    fi
    echo ""

    echo "=== Installing Powerlevel10k ==="
    echo ""

    # Check if Powerlevel10k is already installed
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        echo "📥 Cloning Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" || true
        echo "   ✓ Powerlevel10k installed"
    else
        echo "ℹ️  Powerlevel10k already installed"
    fi
    echo ""

    echo "=== Installing Shell Configuration ==="
    echo ""

    # Generate zshrc from template
    if [ -f "$DOTFILES_DIR/zshrc.template" ]; then
        # Backup existing .zshrc if it exists
        if [ -e "$HOME/.zshrc" ] || [ -L "$HOME/.zshrc" ]; then
            backup_file=$(mktemp "${HOME}/.zshrc.backup.$(date +%Y%m%d_%H%M%S).XXXXXX")
            mv "$HOME/.zshrc" "$backup_file"
            echo "📦 Backing up existing .zshrc to $backup_file"
            log_action "BACKUP" "$backup_file"
        fi

        # Copy template to ~/.zshrc (not symlink, so we can modify it)
        cp "$DOTFILES_DIR/zshrc.template" "$HOME/.zshrc"
        log_action "FILE" "$HOME/.zshrc"
        echo "🔗 Created .zshrc from template"
        echo "   📝 Using modular zshrc template"
    else
        # Fallback to old zshrc if template doesn't exist
        backup_and_link "$DOTFILES_DIR/zshrc" "$HOME/.zshrc" "zshrc"
        echo "   ⚠️  Using legacy zshrc (consider migrating to zshrc.template)"
    fi

    # Symlink plugin configuration
    if [ -f "$DOTFILES_DIR/zsh_plugins.txt" ]; then
        backup_and_link "$DOTFILES_DIR/zsh_plugins.txt" "$HOME/.zsh_plugins.txt" "zsh_plugins.txt"
    fi
else
    echo "⏭️  Skipping Zsh configurations"
fi

echo ""
backup_and_link "$DOTFILES_DIR/gitignore_global" "$HOME/.gitignore_global" "gitignore_global"

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

    signing_key=""
    if [[ "$enable_signing" =~ ^[Yy]$ ]]; then
        echo ""
        read -r -p "Enter your SSH signing key (or press Enter to skip): " signing_key
    fi

    # Copy the template to ~/.gitconfig
    cp "$DOTFILES_DIR/gitconfig.template" "$HOME/.gitconfig"
    log_action "FILE" "$HOME/.gitconfig"

    # Set the user name and email
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"

    # Set the signing key if provided
    if [ -n "$signing_key" ]; then
        git config --global user.signingkey "$signing_key"
        git config --global gpg.format "ssh"
        git config --global gpg.ssh.program "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        git config --global commit.gpgsign "true"
    fi

    echo ""
    echo "   ✓ .gitconfig created and configured"
else
    echo "ℹ️  Skipping .gitconfig (already exists)"
    echo "   Template available at: $DOTFILES_DIR/gitconfig.template"
fi
echo ""

echo "=== Installing Helper Scripts ==="
echo ""

# Note: Project documentation is now generated by Archivist Aurora agent
# Old init-project-agents.sh script has been removed
# Use: "Bootstrap documentation for ~/Projects/my-project" → Archivist Aurora
echo ""

# Optional: Install additional packages from brew_apps.txt
if [ -f "$DOTFILES_DIR/brew_apps.txt" ]; then
    echo ""
    read -r -p "📦 Install additional brew packages from brew_apps.txt? [y/N]: " install_apps
    if [[ "$install_apps" =~ ^[Yy]$ ]]; then
        echo "🍺 Installing packages from brew_apps.txt..."
        validate_required_files "$DOTFILES_DIR/brew_apps.txt"

        while IFS= read -r line; do
            # Remove inline comments and trim whitespace
            package=$(echo "$line" | sed 's/#.*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            [ -z "$package" ] && continue

            # Check if already installed (idempotency)
            if brew list "$package" &>/dev/null; then
                echo "   ✓ $package already installed"
            else
                echo "   📦 Installing $package..."
                if ! brew install "$package"; then
                    FAILED_INSTALLS+=("$package")
                fi
            fi
        done < "$DOTFILES_DIR/brew_apps.txt"

        echo "   ✓ Package installation complete"
    fi
fi

# Optional: Install cask applications from brew_casks.txt
if [ -f "$DOTFILES_DIR/brew_casks.txt" ]; then
    echo ""
    read -r -p "📦 Install applications from brew_casks.txt? [y/N]: " install_casks
    if [[ "$install_casks" =~ ^[Yy]$ ]]; then
        echo "🍺 Installing applications from brew_casks.txt..."
        validate_required_files "$DOTFILES_DIR/brew_casks.txt"

        while IFS= read -r line; do
            # Remove inline comments and trim whitespace
            cask=$(echo "$line" | sed 's/#.*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            [ -z "$cask" ] && continue

            # Check if already installed (idempotency)
            if brew list --cask "$cask" &>/dev/null; then
                echo "   ✓ $cask already installed"
            else
                echo "   📦 Installing $cask..."
                if ! brew install --cask "$cask"; then
                    FAILED_INSTALLS+=("$cask")
                fi
            fi
        done < "$DOTFILES_DIR/brew_casks.txt"

        echo "   ✓ Application installation complete"
    fi
fi

# Optional: Install SDKMAN and Java
echo ""
read -r -p "☕ Install SDKMAN and Java? [y/N]: " install_java
if [[ "$install_java" =~ ^[Yy]$ ]]; then
    if [ ! -d "$HOME/.sdkman" ]; then
        echo "📥 Installing SDKMAN..."
        curl -s "https://get.sdkman.io" | bash || true
        export SDKMAN_DIR="$HOME/.sdkman"
        # shellcheck disable=SC1091
        [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
        echo "   ✓ SDKMAN installed"

        # Add SDKMAN configuration to zshrc (only if zsh configs were installed)
        if [[ "$install_zsh" =~ ^[Yy]$ ]]; then
            sdkman_config="# SDKMAN Configuration
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR=\"\$HOME/.sdkman\"
[[ -s \"\$HOME/.sdkman/bin/sdkman-init.sh\" ]] && source \"\$HOME/.sdkman/bin/sdkman-init.sh\""
            add_tool_config "SDKMAN Configuration" "$sdkman_config"
        fi
    else
        echo "ℹ️  SDKMAN already installed"
    fi

    if command -v sdk &> /dev/null; then
        read -r -p "   Which Java version? (default: 21.0.2-open): " java_version
        java_version=${java_version:-21.0.2-open}
        echo "☕ Installing Java $java_version..."
        export SDKMAN_AUTO_ANSWER=true
        if ! sdk install java "$java_version"; then
            FAILED_INSTALLS+=("java-$java_version")
        fi
        if ! sdk default java "$java_version"; then
            FAILED_INSTALLS+=("java-$java_version-default")
        fi
        echo "   ✓ Java $java_version installed"
    fi
fi

# Optional: Install NVM and Node.js
echo ""
read -r -p "📦 Install NVM and Node.js LTS? [y/N]: " install_node
if [[ "$install_node" =~ ^[Yy]$ ]]; then
    if command -v brew &> /dev/null; then
        echo "📥 Installing nvm via Homebrew..."
        brew install nvm || true

        # Set up nvm directory and add to zshrc if not already present
        export NVM_DIR="$HOME/.nvm"
        mkdir -p "$NVM_DIR"

        # Add NVM configuration to zshrc (only if zsh configs were installed)
        if [[ "$install_zsh" =~ ^[Yy]$ ]]; then
            nvm_config="# NVM Configuration
export NVM_DIR=\"\$HOME/.nvm\"
[ -s \"\$(brew --prefix)/opt/nvm/nvm.sh\" ] && source \"\$(brew --prefix)/opt/nvm/nvm.sh\""
            add_tool_config "NVM Configuration" "$nvm_config"
        fi

        # Source nvm for current session
        # shellcheck disable=SC1091
        [ -s "$(brew --prefix nvm)/nvm.sh" ] && source "$(brew --prefix nvm)/nvm.sh"

        if command -v nvm &> /dev/null; then
            echo "📦 Installing Node.js LTS..."
            nvm install --lts || true
            nvm use --lts || true
            echo "   ✓ Node.js LTS installed"
        fi
    fi
fi

# Optional: Install npm packages from npm_packages.txt
if [ -f "$DOTFILES_DIR/npm_packages.txt" ] && command -v npm &> /dev/null; then
    echo ""
    read -r -p "📦 Install npm packages from npm_packages.txt? [y/N]: " install_npm_packages
    if [[ "$install_npm_packages" =~ ^[Yy]$ ]]; then
        echo "📦 Installing npm packages..."
        validate_required_files "$DOTFILES_DIR/npm_packages.txt"

        while IFS= read -r line; do
            # Remove inline comments and trim whitespace
            package=$(echo "$line" | sed 's/#.*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            [ -z "$package" ] && continue

            # Check if already installed (idempotency)
            if npm list -g "$package" < /dev/null &>/dev/null; then
                echo "   ✓ $package already installed"
            else
                echo "   📦 Installing $package..."
                if ! npm install -g "$package" < /dev/null; then
                    FAILED_INSTALLS+=("$package")
                fi
            fi
        done < "$DOTFILES_DIR/npm_packages.txt"

        echo "   ✓ npm package installation complete"
    fi
fi

# Optional: Install Zsh plugins (only if zsh configs were installed)
if [[ "$install_zsh" =~ ^[Yy]$ ]]; then
    echo ""
    read -r -p "🎨 Install zsh-syntax-highlighting and zsh-autosuggestions? [y/N]: " install_zsh_plugins
    if [[ "$install_zsh_plugins" =~ ^[Yy]$ ]]; then
        echo "📥 Installing zsh plugins..."
        brew install zsh-syntax-highlighting zsh-autosuggestions || true

        # Add zsh plugins configuration to zshrc
        zsh_plugins_config="# Zsh Plugins
source \$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source \$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
        add_tool_config "Zsh Plugins" "$zsh_plugins_config"
    fi
fi

# Detect and configure already-installed tools
echo ""
echo "=== Detecting Installed Tools ==="
echo ""

# Check for Docker/Colima (only add to zshrc if zsh configs were installed)
if [[ "$install_zsh" =~ ^[Yy]$ ]] && command -v docker &>/dev/null && command -v colima &>/dev/null; then
    echo "🐳 Docker and Colima detected"

    # Always add basic Docker/Colima config
    docker_colima_config="# Docker/Colima Configuration
export DOCKER_HOST=\"unix://\${HOME}/.colima/default/docker.sock\""

    # Ask about Testcontainers (optional, for testing)
    read -r -p "   Add Testcontainers environment variables? (for integration testing) [y/N]: " add_testcontainers
    if [[ "$add_testcontainers" =~ ^[Yy]$ ]]; then
        docker_colima_config="${docker_colima_config}
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock

# Cache colima host address to speed up shell startup
if [ -z \"\$TESTCONTAINERS_HOST_OVERRIDE\" ] && command -v colima &>/dev/null && command -v jq &>/dev/null; then
    export TESTCONTAINERS_HOST_OVERRIDE=\$(colima ls -j 2>/dev/null | jq -r '.address' 2>/dev/null || echo \"\")
fi"
    fi

    add_tool_config "Docker/Colima Configuration" "$docker_colima_config"
fi

# Check for NVM (only add to zshrc if zsh configs were installed)
if [[ "$install_zsh" =~ ^[Yy]$ ]] && { [ -d "$HOME/.nvm" ] || command -v nvm &>/dev/null; }; then
    nvm_config="# NVM Configuration
export NVM_DIR=\"\$HOME/.nvm\"
[ -s \"\$(brew --prefix)/opt/nvm/nvm.sh\" ] && source \"\$(brew --prefix)/opt/nvm/nvm.sh\""
    add_tool_config "NVM Configuration" "$nvm_config"
fi

# Check for SDKMAN (only add to zshrc if zsh configs were installed)
if [[ "$install_zsh" =~ ^[Yy]$ ]] && [ -d "$HOME/.sdkman" ]; then
    sdkman_config="# SDKMAN Configuration
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR=\"\$HOME/.sdkman\"
[[ -s \"\$HOME/.sdkman/bin/sdkman-init.sh\" ]] && source \"\$HOME/.sdkman/bin/sdkman-init.sh\""
    add_tool_config "SDKMAN Configuration" "$sdkman_config"
fi

# Check for zsh plugins (only add to zshrc if zsh configs were installed)
if [[ "$install_zsh" =~ ^[Yy]$ ]] && [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] 2>/dev/null; then
    zsh_plugins_config="# Zsh Plugins
source \$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

    if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] 2>/dev/null; then
        zsh_plugins_config="${zsh_plugins_config}
source \$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    fi

    add_tool_config "Zsh Plugins" "$zsh_plugins_config"
fi

# Optional: Configure macOS defaults
echo ""
read -r -p "⚙️  Configure macOS defaults (Dock, Finder, Trackpad, Dark Mode)? [y/N]: " install_defaults
if [[ "$install_defaults" =~ ^[Yy]$ ]]; then
    echo "⚙️  Configuring macOS defaults..."

    # Dock settings
    defaults write com.apple.dock orientation -string "left"
    defaults write com.apple.dock minimize-to-application -bool true
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock launchanim -bool false
    defaults write com.apple.dock show-process-indicators -bool true
    defaults write com.apple.dock show-recents -bool false

    # Finder settings
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
    defaults write com.apple.finder NewWindowTarget -string "PfHm"
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowTabView -bool true
    defaults write com.apple.finder AppleShowAllFiles -bool true
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Trackpad settings
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

    # Dark Mode
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true' 2>/dev/null || true

    # Restart affected applications
    killall Dock 2>/dev/null || true
    killall Finder 2>/dev/null || true

    echo "   ✓ macOS defaults configured"
fi

echo ""

# Verify installation
echo "✅ Installation complete!"
echo ""
echo "📋 Installation log saved to: $LOG_FILE"
echo "   Use this log with uninstall.sh to revert changes"
echo ""

if [[ "$install_ai" =~ ^[Yy]$ ]]; then
    if [ -L "$AI_DIR" ] && [ -d "$AI_DIR" ] && [ -L "$CLAUDE_DIR" ] && [ -d "$CLAUDE_DIR" ]; then
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
        echo "   - Gemini: Opens config from ~/.gemini/GEMINI.md"
        echo ""
        echo "📋 Bootstrap project documentation:"
        echo "   \"Bootstrap documentation for ~/Projects/my-project\" → Archivist Aurora"
        echo "   (Generates constitution.md, AGENTS.md, guidelines.md)"
        echo ""
    else
        echo "⚠️  Warning: AI configuration symlinks not created correctly"
    fi
fi

if [[ "$install_zsh" =~ ^[Yy]$ ]]; then
    echo "🐚 Zsh Configuration Installed:"
    echo "   ~/.zshrc          - Shell configuration"
    echo "   ~/.oh-my-zsh/     - Oh My Zsh framework"
    echo "   Powerlevel10k     - Terminal theme"
    echo ""
fi

echo "📖 For more info: cat ~/Projects/dotfiles/README.md"
echo ""

# Report failed installations if any
if [ ${#FAILED_INSTALLS[@]} -gt 0 ]; then
    echo "⚠️  Warning: Some installations failed:"
    for item in "${FAILED_INSTALLS[@]}"; do
        echo "   ❌ $item"
    done
    echo ""
    echo "💡 You can retry failed installations manually or re-run this script."
fi
