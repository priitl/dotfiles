#!/usr/bin/env bats

# Tests for uninstall.sh
# Validates that uninstall can remove installed dotfiles

load test_helper

setup() {
    # Create temporary test environment
    TEST_HOME="$(mktemp -d)"
    TEST_DOTFILES="$TEST_HOME/Projects/dotfiles"

    # Set up environment variables
    export HOME="$TEST_HOME"
    export DOTFILES_DIR="$TEST_DOTFILES"

    # Create mock dotfiles directory structure
    mkdir -p "$TEST_DOTFILES"/{.ai,.claude,.copilot,.gemini,.cursor}
    mkdir -p "$TEST_DOTFILES/.ai"/{0_core,1_workflows,3_commands,5_agents}

    # Create mock files
    echo "mock ai core" > "$TEST_DOTFILES/.ai/0_core/test.md"
    echo "mock claude config" > "$TEST_DOTFILES/.claude/CLAUDE.md"
    echo "mock zshrc" > "$TEST_DOTFILES/zshrc"
    cat > "$TEST_DOTFILES/zshrc.template" <<'EOF'
# Mock zshrc template
export ZSH="$HOME/.oh-my-zsh"
# TOOL_CONFIGS_MARKER
EOF
    echo "mock gitignore" > "$TEST_DOTFILES/gitignore_global"

    # Create gitconfig.template
    cat > "$TEST_DOTFILES/gitconfig.template" <<'EOF'
[user]
	name = YOUR_NAME
	email = YOUR_EMAIL
EOF

    # Create a mock .gitconfig to skip interactive prompts
    cat > "$TEST_HOME/.gitconfig" <<'EOF'
[user]
	name = Test User
	email = test@example.com
EOF

    # Mock brew command
    export PATH="$TEST_HOME/bin:$PATH"
    mkdir -p "$TEST_HOME/bin"
    cat > "$TEST_HOME/bin/brew" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
    chmod +x "$TEST_HOME/bin/brew"
}

teardown() {
    # Clean up test environment
    rm -rf "$TEST_HOME"
}

@test "uninstall.sh exists and is executable" {
    [ -f "$BATS_TEST_DIRNAME/../uninstall.sh" ]
    [ -x "$BATS_TEST_DIRNAME/../uninstall.sh" ]
}

@test "fails when log file does not exist" {
    run bash "$BATS_TEST_DIRNAME/../uninstall.sh" <<< $'n\nn\n'
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Installation log not found" ]]
}

@test "reads installation log" {
    # First install
    bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nY\nY\nn\nn\nn\nn\nn\nn\nn\n' > /dev/null

    # Run uninstall without removing anything
    run bash "$BATS_TEST_DIRNAME/../uninstall.sh" <<< $'n\nn\nn\n'
    [ "$status" -eq 0 ]
    [[ "$output" =~ "AI configs installed: Y" ]]
    [[ "$output" =~ "Zsh configs installed: Y" ]]
}

@test "removes symlinks when requested" {
    # First install
    bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nY\nY\nn\nn\nn\nn\nn\nn\nn\n' > /dev/null

    # Verify symlinks exist
    [ -L "$TEST_HOME/.ai" ]
    [ -L "$TEST_HOME/.claude" ]

    # Run uninstall to remove symlinks
    run bash "$BATS_TEST_DIRNAME/../uninstall.sh" <<< $'y\nn\nn\nn\n'
    [ "$status" -eq 0 ]

    # Verify symlinks removed
    [ ! -e "$TEST_HOME/.ai" ]
    [ ! -e "$TEST_HOME/.claude" ]
}

@test "removes files when requested" {
    # First install
    bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nY\nY\nn\nn\nn\nn\nn\nn\nn\n' > /dev/null

    # Verify zshrc exists
    [ -f "$TEST_HOME/.zshrc" ]

    # Run uninstall to remove files
    run bash "$BATS_TEST_DIRNAME/../uninstall.sh" <<< $'n\ny\nn\nn\n'
    [ "$status" -eq 0 ]

    # Verify file removed
    [ ! -f "$TEST_HOME/.zshrc" ]
}

@test "restores backups when requested" {
    # Create existing file
    echo "original content" > "$TEST_HOME/.zshrc"

    # Install (creates backup)
    bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'Y\nY\nY\nn\nn\nn\nn\nn\nn\nn\n' > /dev/null

    # Verify backup exists and new file exists
    backup_file=$(find "$TEST_HOME" -name ".zshrc.backup.*" | head -n 1)
    [ -f "$backup_file" ]
    [ -f "$TEST_HOME/.zshrc" ]
    [ "$(cat "$backup_file")" = "original content" ]

    # Run uninstall to restore backup (need to say 'y' to overwrite prompt)
    run bash "$BATS_TEST_DIRNAME/../uninstall.sh" <<< $'n\nn\ny\ny\nn\n'
    [ "$status" -eq 0 ]

    # Verify backup was restored
    [ -f "$TEST_HOME/.zshrc" ]
    [ "$(cat "$TEST_HOME/.zshrc")" = "original content" ]
    [ ! -f "$backup_file" ]
}

@test "keeps log file if user declines" {
    # First install
    bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nY\nY\nn\nn\nn\nn\nn\nn\nn\n' > /dev/null

    # Run uninstall but keep log
    run bash "$BATS_TEST_DIRNAME/../uninstall.sh" <<< $'y\ny\nn\nn\n'
    [ "$status" -eq 0 ]

    # Verify log still exists
    [ -f "$TEST_HOME/.dotfiles_install.log" ]
    [[ "$output" =~ "Keeping installation log" ]]
}

@test "shows summary of removed items" {
    # First install
    bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nY\nY\nn\nn\nn\nn\nn\nn\nn\n' > /dev/null

    # Run uninstall
    run bash "$BATS_TEST_DIRNAME/../uninstall.sh" <<< $'y\ny\nn\nn\n'
    [ "$status" -eq 0 ]
    [[ "$output" =~ "=== Summary ===" ]]
    [[ "$output" =~ "✓ Removed:" ]]
}
