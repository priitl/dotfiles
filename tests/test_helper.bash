#!/usr/bin/env bash

# Test helper functions for bats tests

# Ensure bats-core support libraries are available
# These are typically installed via brew or npm
if [ -z "$BATS_SUPPORT_LOADED" ]; then
    # Try to load from common locations
    if [ -f "/usr/local/lib/bats-support/load.bash" ]; then
        load "/usr/local/lib/bats-support/load.bash"
    elif [ -f "/opt/homebrew/lib/bats-support/load.bash" ]; then
        load "/opt/homebrew/lib/bats-support/load.bash"
    fi
fi

if [ -z "$BATS_ASSERT_LOADED" ]; then
    if [ -f "/usr/local/lib/bats-assert/load.bash" ]; then
        load "/usr/local/lib/bats-assert/load.bash"
    elif [ -f "/opt/homebrew/lib/bats-assert/load.bash" ]; then
        load "/opt/homebrew/lib/bats-assert/load.bash"
    fi
fi

# Helper function to create a mock Oh My Zsh installation
setup_mock_omz() {
    local home="$1"
    mkdir -p "$home/.oh-my-zsh/custom/themes"
}

# Helper function to verify symlink target
assert_symlink_target() {
    local link="$1"
    local expected_target="$2"
    local actual_target

    if [ ! -L "$link" ]; then
        echo "Error: $link is not a symlink"
        return 1
    fi

    actual_target="$(readlink "$link")"
    if [ "$actual_target" != "$expected_target" ]; then
        echo "Error: $link points to $actual_target, expected $expected_target"
        return 1
    fi

    return 0
}

# Helper function to count backup files
count_backups() {
    local pattern="$1"
    find "$(dirname "$pattern")" -name "$(basename "$pattern").backup.*" 2>/dev/null | wc -l | tr -d ' '
}

# Helper function to get the latest backup file
get_latest_backup() {
    local pattern="$1"
    find "$(dirname "$pattern")" -name "$(basename "$pattern").backup.*" 2>/dev/null | sort -r | head -n 1
}

# Helper function to verify timestamp format in filename
assert_timestamp_format() {
    local filename="$1"
    local timestamp_pattern='[0-9]{8}_[0-9]{6}'

    if [[ ! "$filename" =~ $timestamp_pattern ]]; then
        echo "Error: $filename does not contain valid timestamp format (YYYYMMDD_HHMMSS)"
        return 1
    fi

    return 0
}

# Helper function to create a temporary dotfiles structure
create_test_dotfiles() {
    local dotfiles_dir="$1"

    mkdir -p "$dotfiles_dir"/{.ai,.claude,.copilot,.gemini,.cursor}
    mkdir -p "$dotfiles_dir/.ai"/{0_core,1_workflows,2_agents}

    # Create mock configuration files
    cat > "$dotfiles_dir/.ai/0_core/priit-personality.md" <<'EOF'
# Priit's AI Personality
Core personality configuration
EOF

    cat > "$dotfiles_dir/.ai/0_core/coding-standards.md" <<'EOF'
# Coding Standards
Code quality rules
EOF

    cat > "$dotfiles_dir/.claude/CLAUDE.md" <<'EOF'
# Claude Code Configuration
Claude-specific settings
EOF

    cat > "$dotfiles_dir/zshrc" <<'EOF'
# Zsh Configuration
export PATH="$HOME/bin:$PATH"
EOF

    cat > "$dotfiles_dir/gitignore_global" <<'EOF'
.DS_Store
*.swp
EOF

    cat > "$dotfiles_dir/gitconfig.template" <<'EOF'
[user]
    name = Your Name
    email = your.email@example.com
EOF
}

# Helper function to simulate user input for interactive prompts
simulate_user_input() {
    local git_name="${1:-Test User}"
    local git_email="${2:-test@example.com}"
    local enable_signing="${3:-n}"
    local signing_key="${4:-}"

    echo "$git_name"
    echo "$git_email"
    echo "$enable_signing"
    if [ -n "$signing_key" ]; then
        echo "$signing_key"
    fi
}

# Helper function to verify gitconfig section
assert_gitconfig_section() {
    local gitconfig="$1"
    local section="$2"

    if ! grep -q "\[$section\]" "$gitconfig"; then
        echo "Error: $gitconfig missing [$section] section"
        return 1
    fi

    return 0
}

# Helper function to verify gitconfig key-value pair
assert_gitconfig_value() {
    local gitconfig="$1"
    local key="$2"
    local value="$3"

    if ! grep -q "$key = $value" "$gitconfig"; then
        echo "Error: $gitconfig missing '$key = $value'"
        return 1
    fi

    return 0
}
