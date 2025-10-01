#!/usr/bin/env bats

# Tests for install.sh
# Validates backup functionality, symlink creation, and file generation

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
    mkdir -p "$TEST_DOTFILES/.ai"/{0_core,1_workflows,2_agents}

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
[color]
	ui = auto
[core]
	autocrlf = input
	excludesfile = ~/.gitignore_global
[init]
	defaultBranch = main
[pull]
	rebase = true
[fetch]
	prune = true
[rebase]
	autoStash = true
[rerere]
	enabled = true
EOF

    # Create a mock .gitconfig to skip interactive prompts in most tests
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
echo "mock brew: $@"
exit 0
EOF
    chmod +x "$TEST_HOME/bin/brew"

    # Mock pre-commit command
    cat > "$TEST_HOME/bin/pre-commit" <<'EOF'
#!/usr/bin/env bash
echo "mock pre-commit: $@"
exit 0
EOF
    chmod +x "$TEST_HOME/bin/pre-commit"

    # Mock git command that actually modifies .gitconfig
    cat > "$TEST_HOME/bin/git" <<'EOF'
#!/usr/bin/env bash
# Mock git command that handles config operations
if [ "$1" = "config" ] && [ "$2" = "--global" ]; then
    config_file="$HOME/.gitconfig"
    key="$3"
    value="$4"

    # Simple INI-style config writer
    case "$key" in
        user.name)
            sed -i '' "s/name = .*/name = $value/" "$config_file" 2>/dev/null || \
            sed -i "s/name = .*/name = $value/" "$config_file"
            ;;
        user.email)
            sed -i '' "s/email = .*/email = $value/" "$config_file" 2>/dev/null || \
            sed -i "s/email = .*/email = $value/" "$config_file"
            ;;
        user.signingkey)
            # Add signing key after email if not present
            if ! grep -q "signingkey = " "$config_file"; then
                sed -i '' "/email = /a\\
	signingkey = $value" "$config_file" 2>/dev/null || \
                sed -i "/email = /a\\	signingkey = $value" "$config_file"
            fi
            ;;
        gpg.format)
            # Add gpg section if not present
            if ! grep -q "\[gpg\]" "$config_file"; then
                echo -e "\n[gpg]\n	format = $value" >> "$config_file"
            fi
            ;;
        gpg.ssh.program)
            # Add under gpg section
            if ! grep -q "program = " "$config_file"; then
                sed -i '' "/\[gpg\]/a\\
	program = $value" "$config_file" 2>/dev/null || \
                sed -i "/\[gpg\]/a\\	program = $value" "$config_file"
            fi
            ;;
        commit.gpgsign)
            # Add commit section if not present
            if ! grep -q "\[commit\]" "$config_file"; then
                echo -e "\n[commit]\n	gpgsign = $value" >> "$config_file"
            fi
            ;;
    esac
    exit 0
else
    echo "mock git: $@"
    exit 0
fi
EOF
    chmod +x "$TEST_HOME/bin/git"
}

# Helper function to provide standard "no" responses to all optional prompts
# Current prompts: signing, apps, casks, sdkman, nvm, zsh-plugins, macos-defaults = 7 prompts
skip_all_optional() {
    echo -e "n\nn\nn\nn\nn\nn\nn"
}

teardown() {
    # Clean up test environment
    rm -rf "$TEST_HOME"
}

@test "install.sh exists and is executable" {
    [ -f "$BATS_TEST_DIRNAME/../install.sh" ]
    [ -x "$BATS_TEST_DIRNAME/../install.sh" ]
}

@test "fails when dotfiles directory does not exist" {
    export DOTFILES_DIR="$TEST_HOME/nonexistent"
    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Error: Dotfiles directory not found" ]]
}

@test "creates symlink for .ai directory" {
    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'
    [ -L "$TEST_HOME/.ai" ]
    [ "$(readlink "$TEST_HOME/.ai")" = "$TEST_DOTFILES/.ai" ]
}

@test "creates symlink for .claude directory" {
    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'
    [ -L "$TEST_HOME/.claude" ]
    [ "$(readlink "$TEST_HOME/.claude")" = "$TEST_DOTFILES/.claude" ]
}

@test "creates symlink for .copilot directory" {
    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'
    [ -L "$TEST_HOME/.copilot" ]
    [ "$(readlink "$TEST_HOME/.copilot")" = "$TEST_DOTFILES/.copilot" ]
}

@test "creates symlink for .gemini directory" {
    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'
    [ -L "$TEST_HOME/.gemini" ]
    [ "$(readlink "$TEST_HOME/.gemini")" = "$TEST_DOTFILES/.gemini" ]
}

@test "creates symlink for .cursor directory" {
    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'
    [ -L "$TEST_HOME/.cursor" ]
    [ "$(readlink "$TEST_HOME/.cursor")" = "$TEST_DOTFILES/.cursor" ]
}

@test "creates symlink for zshrc" {
    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'
    # zshrc should be a copy from template (not a symlink)
    [ -f "$TEST_HOME/.zshrc" ]
    [ ! -L "$TEST_HOME/.zshrc" ]
}

@test "creates symlink for gitignore_global" {
    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'
    [ -L "$TEST_HOME/.gitignore_global" ]
    [ "$(readlink "$TEST_HOME/.gitignore_global")" = "$TEST_DOTFILES/gitignore_global" ]
}

@test "backs up existing file before symlinking" {
    # Create existing file
    echo "existing content" > "$TEST_HOME/.zshrc"

    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'
    [ "$status" -eq 0 ]

    # Check that backup was created
    backup_count=$(find "$TEST_HOME" -name ".zshrc.backup.*" | wc -l)
    [ "$backup_count" -eq 1 ]

    # Check that original content is preserved in backup
    backup_file=$(find "$TEST_HOME" -name ".zshrc.backup.*" | head -n 1)
    [ "$(cat "$backup_file")" = "existing content" ]
}

@test "backs up existing symlink before replacing" {
    # Create existing symlink
    mkdir -p "$TEST_HOME/old_target"
    ln -s "$TEST_HOME/old_target" "$TEST_HOME/.ai"

    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'Y\nn\nn\nn\nn\nn\nn\nn\n'
    [ "$status" -eq 0 ]

    # Check that backup was created
    backup_count=$(find "$TEST_HOME" -name ".ai.backup.*" | wc -l)
    [ "$backup_count" -eq 1 ]
}

@test "backup filenames include timestamp" {
    echo "existing" > "$TEST_HOME/.zshrc"

    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'

    backup_file=$(find "$TEST_HOME" -name ".zshrc.backup.*" | head -n 1)
    # Check that filename matches pattern: .zshrc.backup.YYYYMMDD_HHMMSS.XXXXXX (mktemp format)
    [[ "$(basename "$backup_file")" =~ ^\.zshrc\.backup\.[0-9]{8}_[0-9]{6}\. ]]
}

@test "creates .gitconfig when it doesn't exist" {
    # Remove the mock .gitconfig created in setup
    rm "$TEST_HOME/.gitconfig"

    # Provide input for backup prompt, git name and email, skip signing, skip all optional installs
    run bash "$BATS_TEST_DIRNAME/../install.sh" <<'INPUT'
Y
Test User
test@example.com
n
n
n
n
n
n
n
INPUT

    [ "$status" -eq 0 ]
    [ -f "$TEST_HOME/.gitconfig" ]
}

@test "generated .gitconfig contains user name and email" {
    # Remove the mock .gitconfig created in setup
    rm "$TEST_HOME/.gitconfig"

    run bash "$BATS_TEST_DIRNAME/../install.sh" <<'INPUT'
Y
John Doe
john@example.com
n
n
n
n
n
n
n
INPUT

    [ -f "$TEST_HOME/.gitconfig" ]
    grep -q "name = John Doe" "$TEST_HOME/.gitconfig"
    grep -q "email = john@example.com" "$TEST_HOME/.gitconfig"
}

@test "generated .gitconfig contains core settings" {
    # Remove the mock .gitconfig created in setup
    rm "$TEST_HOME/.gitconfig"

    run bash "$BATS_TEST_DIRNAME/../install.sh" <<'INPUT'
Test User
test@example.com
n
n
n
n
n
n
n
INPUT

    [ -f "$TEST_HOME/.gitconfig" ]
    grep -q "\[core\]" "$TEST_HOME/.gitconfig"
    grep -q "autocrlf = input" "$TEST_HOME/.gitconfig"
    grep -q "excludesfile = ~/.gitignore_global" "$TEST_HOME/.gitconfig"
    grep -q "defaultBranch = main" "$TEST_HOME/.gitconfig"
    grep -q "prune = true" "$TEST_HOME/.gitconfig"
}

@test "does not overwrite existing .gitconfig" {
    echo "existing gitconfig" > "$TEST_HOME/.gitconfig"

    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'

    [ "$status" -eq 0 ]
    [ "$(cat "$TEST_HOME/.gitconfig")" = "existing gitconfig" ]
    [[ "$output" =~ Skipping\ \.gitconfig\ \(already\ exists\) ]]
}

@test "adds signing configuration when enabled" {
    # Remove the mock .gitconfig created in setup
    rm "$TEST_HOME/.gitconfig"

    run bash "$BATS_TEST_DIRNAME/../install.sh" <<'INPUT'
Y
Test User
test@example.com
y
ssh-ed25519 AAAA... test@example.com
n
n
n
n
n
n
INPUT

    [ -f "$TEST_HOME/.gitconfig" ]
    grep -q "signingkey = ssh-ed25519" "$TEST_HOME/.gitconfig"
    grep -q "format = ssh" "$TEST_HOME/.gitconfig"
    grep -q "gpgsign = true" "$TEST_HOME/.gitconfig"
}

@test "rejects empty git name" {
    # Remove the mock .gitconfig created in setup
    rm "$TEST_HOME/.gitconfig"

    run bash "$BATS_TEST_DIRNAME/../install.sh" <<'INPUT'

Valid Name
test@example.com
n
n
n
n
n
n
n
INPUT

    [[ "$output" =~ "Name cannot be empty" ]]
    [ -f "$TEST_HOME/.gitconfig" ]
    grep -q "name = Valid Name" "$TEST_HOME/.gitconfig"
}

@test "rejects empty git email" {
    # Remove the mock .gitconfig created in setup
    rm "$TEST_HOME/.gitconfig"

    run bash "$BATS_TEST_DIRNAME/../install.sh" <<'INPUT'
Y
Test User

test@example.com
n
n
n
n
n
n
n
INPUT

    [[ "$output" =~ "Email cannot be empty" ]]
    [ -f "$TEST_HOME/.gitconfig" ]
    grep -q "email = test@example.com" "$TEST_HOME/.gitconfig"
}

@test "creates agents symlink in .claude directory" {
    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'
    [ "$status" -eq 0 ]
    [ -L "$TEST_HOME/.claude/agents" ]
    [ "$(readlink "$TEST_HOME/.claude/agents")" = "$TEST_HOME/.ai/3_agents" ]
}

@test "installation succeeds with all symlinks created" {
    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'
    [ "$status" -eq 0 ]
    [[ "$output" =~ "✅ Installation complete!" ]]
}

@test "multiple backups create unique filenames" {
    # Create initial file
    echo "version1" > "$TEST_HOME/.zshrc"

    # Run install first time
    bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n' > /dev/null

    # Remove symlink and create new file
    rm "$TEST_HOME/.zshrc"
    echo "version2" > "$TEST_HOME/.zshrc"

    # Run install second time
    sleep 1  # Ensure different timestamp
    bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n' > /dev/null

    # Check that two backups exist with different timestamps
    backup_count=$(find "$TEST_HOME" -name ".zshrc.backup.*" | wc -l)
    [ "$backup_count" -eq 2 ]
}

@test "installation output shows backup messages" {
    echo "existing" > "$TEST_HOME/.zshrc"

    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'
    [[ "$output" =~ "📦 Backing up existing" ]]
}

@test "installation output shows symlink creation" {
    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'
    [[ "$output" =~ "🔗 Creating symlink" ]]
}

@test "symlinks are valid and point to correct targets" {
    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\nn\nn\nn\nn\nn\nn\n'

    # Check .ai symlink
    [ -L "$TEST_HOME/.ai" ]
    [ -d "$TEST_HOME/.ai" ]
    [ -e "$TEST_HOME/.ai/0_core/test.md" ]

    # Check .claude symlink
    [ -L "$TEST_HOME/.claude" ]
    [ -d "$TEST_HOME/.claude" ]
    [ -e "$TEST_HOME/.claude/CLAUDE.md" ]

    # Check zshrc - should be a copy from template (or symlink if template doesn't exist)
    [ -f "$TEST_HOME/.zshrc" ]
    # If template exists, zshrc should be a regular file (copy)
    # If template doesn't exist, zshrc should be a symlink to legacy zshrc
    if [ -f "$TEST_DOTFILES/zshrc.template" ]; then
        [ ! -L "$TEST_HOME/.zshrc" ]  # Not a symlink
    else
        [ -L "$TEST_HOME/.zshrc" ]  # Is a symlink
    fi
}
