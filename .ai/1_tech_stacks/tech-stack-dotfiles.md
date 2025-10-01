# Tech Stack: Dotfiles & Shell Scripts

## Overview
Dotfiles repository for managing development environment configuration across macOS and Linux systems. Emphasizes portability, modularity, and testability of shell scripts.

## Architecture Patterns

### Unix Philosophy
- **Do one thing well**: Each script has a single, clear purpose
- **Composability**: Scripts can be combined and reused
- **Plain text**: Configuration as readable, version-controlled text
- **Modularity**: Separate concerns into discrete files/functions

### Repository Structure
```
dotfiles/
├── install.sh              # Main installation script
├── lib/                    # Reusable shell functions
│   ├── utils.sh           # Common utilities
│   ├── logging.sh         # Logging functions
│   └── platform.sh        # Platform detection
├── config/                 # Configuration templates
│   ├── gitconfig.template
│   ├── zshrc.template
│   └── vimrc.template
├── scripts/                # Individual setup scripts
│   ├── setup-brew.sh
│   ├── setup-git.sh
│   └── setup-vim.sh
├── tests/                  # BATS test files
│   ├── install.bats
│   ├── lib/
│   │   └── utils.bats
│   └── helpers/           # Test helpers
│       └── test_helper.bash
└── README.md
```

## Shell Scripting Conventions

### Script Headers
```bash
#!/usr/bin/env bash
# Description: One-line description of what script does
# Usage: script-name.sh [options]

set -euo pipefail  # Exit on error, undefined vars, pipe failures
```

### Function Patterns
```bash
# Function naming: lowercase with underscores
function setup_git() {
    local config_file="${1:-$HOME/.gitconfig}"

    # Validate inputs
    [[ -z "$config_file" ]] && {
        echo "Error: config_file required" >&2
        return 1
    }

    # Implementation
    cp config/gitconfig.template "$config_file"
}

# Export for use in other scripts if needed
export -f setup_git
```

### Error Handling
```bash
# Check command success
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew not installed" >&2
    exit 1
fi

# Trap for cleanup
trap 'cleanup_temp_files' EXIT ERR

# Validation with meaningful errors
validate_input() {
    local input="$1"
    [[ -n "$input" ]] || {
        echo "Error: Input cannot be empty" >&2
        return 1
    }
}
```

### Platform Detection
```bash
# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)  echo "linux" ;;
        *)       echo "unknown" ;;
    esac
}

# Platform-specific logic
if [[ "$(detect_os)" == "macos" ]]; then
    # macOS-specific commands
    brew install coreutils
else
    # Linux-specific commands
    apt-get install coreutils
fi
```

## Testing Strategy

### BATS (Bash Automated Testing System)
Primary testing framework for shell scripts.

### Test Structure
```bash
#!/usr/bin/env bats
# Test file naming: script-name.bats

load 'helpers/test_helper'

setup() {
    # Run before each test
    export TEST_TEMP_DIR="$(mktemp -d)"
}

teardown() {
    # Run after each test
    rm -rf "$TEST_TEMP_DIR"
}

@test "function_name: should do expected behavior" {
    # Arrange
    local input="test-value"

    # Act
    run function_name "$input"

    # Assert
    assert_success
    assert_output "expected output"
}

@test "function_name: should fail on invalid input" {
    # Act
    run function_name ""

    # Assert
    assert_failure
    assert_output --partial "Error:"
}
```

### Test Helpers
```bash
# helpers/test_helper.bash
load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

# Custom helpers
setup_test_git_config() {
    export GIT_CONFIG_GLOBAL="$TEST_TEMP_DIR/.gitconfig"
}

assert_file_exists() {
    [[ -f "$1" ]] || fail "File does not exist: $1"
}
```

### Test Coverage
1. **Unit Tests**: Individual functions in isolation
2. **Integration Tests**: Multi-function workflows
3. **Idempotency Tests**: Script can run multiple times safely
4. **Platform Tests**: Behavior on macOS vs Linux

### BATS Assertions
- `assert_success` / `assert_failure`
- `assert_output "expected"`
- `assert_output --partial "substring"`
- `assert_line --index 0 "first line"`
- `assert_equal "$actual" "$expected"`

## Configuration Management

### Template Pattern
```bash
# config/gitconfig.template
[user]
    name = __GIT_USER_NAME__
    email = __GIT_USER_EMAIL__

[core]
    editor = vim
```

```bash
# Installation script
install_git_config() {
    local template="config/gitconfig.template"
    local target="$HOME/.gitconfig"

    # Prompt for user input
    read -rp "Enter git user name: " git_name
    read -rp "Enter git email: " git_email

    # Replace placeholders
    sed -e "s/__GIT_USER_NAME__/$git_name/" \
        -e "s/__GIT_USER_EMAIL__/$git_email/" \
        "$template" > "$target"
}
```

### Symlinking Pattern
```bash
# Create symlinks for dotfiles
link_dotfile() {
    local source="$1"
    local target="$2"

    # Backup existing file
    [[ -f "$target" ]] && mv "$target" "$target.backup"

    # Create symlink
    ln -sf "$source" "$target"
}

# Usage
link_dotfile "$PWD/config/zshrc" "$HOME/.zshrc"
```

## Common Components

### Logging Functions
```bash
# lib/logging.sh
log_info() {
    echo "[INFO] $*" >&2
}

log_error() {
    echo "[ERROR] $*" >&2
}

log_success() {
    echo "[SUCCESS] $*" >&2
}
```

### File Operations
```bash
# lib/utils.sh
backup_file() {
    local file="$1"
    [[ -f "$file" ]] && cp "$file" "$file.backup.$(date +%Y%m%d_%H%M%S)"
}

ensure_directory() {
    local dir="$1"
    [[ -d "$dir" ]] || mkdir -p "$dir"
}
```

### Package Management
```bash
# scripts/setup-brew.sh
install_brew_package() {
    local package="$1"

    if brew list "$package" &> /dev/null; then
        log_info "$package already installed"
    else
        log_info "Installing $package..."
        brew install "$package"
    fi
}
```

## Code Quality Standards

### Required Practices
- **Test-first**: Write BATS tests before implementation
- **Idempotency**: Scripts can run multiple times safely
- **Error handling**: Check command success, validate inputs
- **Logging**: Use consistent logging functions
- **Documentation**: Comments explaining "why", not "what"
- **Shellcheck**: Pass shellcheck linting

### Script Safety
```bash
# Always include
set -euo pipefail

# -e: Exit on error
# -u: Error on undefined variable
# -o pipefail: Pipeline fails if any command fails
```

### Naming Conventions
- **Files**: `kebab-case.sh` (e.g., `setup-vim.sh`)
- **Functions**: `snake_case` (e.g., `install_package`)
- **Variables**: `snake_case` (e.g., `config_file`)
- **Constants**: `UPPER_CASE` (e.g., `DEFAULT_SHELL`)

### Documentation Standards
```bash
# Good: Explains why
# Use XDG_CONFIG_HOME if set, fallback to $HOME/.config
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"

# Bad: Explains what (obvious from code)
# Set config_dir variable
config_dir="$HOME/.config"
```

## Tools & Dependencies

### Package Managers
- **Homebrew** (macOS): Package installation
- **apt/yum** (Linux): Platform-specific packages

### Testing Tools
- **BATS**: Test framework
- **bats-support**: Additional test helpers
- **bats-assert**: Assertion library
- **shellcheck**: Shell script linter

### Utilities
- **git**: Version control
- **stow**: Symlink management (optional)
- **sed/awk**: Text processing
- **jq**: JSON processing (if needed)

## Planning Considerations

### When Planning Dotfiles Features
1. **Script Organization**: Which files need creation/modification?
2. **Functions**: Break down into reusable functions in `lib/`
3. **Configuration**: Templates vs. direct copies vs. symlinks
4. **Platform Support**: macOS vs. Linux differences
5. **Testing**: BATS tests for each function and integration flow
6. **Idempotency**: Ensure scripts can run repeatedly safely
7. **User Input**: What needs prompting vs. sensible defaults?

### Task Breakdown Pattern
1. **T1-T2**: Create/update lib functions (with unit tests)
2. **T3-T4**: Create configuration templates
3. **T5-T6**: Write main installation script logic
4. **T7-T8**: Write BATS unit tests
5. **T9-T10**: Write BATS integration tests
6. **T11**: Test on macOS
7. **T12**: Test on Linux (if applicable)
8. **T13**: Run shellcheck and fix issues

### Common Task Types
- Create new shell function in `lib/`
- Write BATS test for function
- Create configuration template
- Implement template substitution
- Add package installation logic
- Test idempotency (run script twice)
- Cross-platform compatibility check

## Installation Workflow

### Typical Installation Flow
```bash
#!/usr/bin/env bash
# install.sh

set -euo pipefail

# Source libraries
source "$(dirname "$0")/lib/logging.sh"
source "$(dirname "$0")/lib/platform.sh"

main() {
    log_info "Starting dotfiles installation..."

    # Detect platform
    local os
    os="$(detect_os)"
    log_info "Detected OS: $os"

    # Platform-specific setup
    case "$os" in
        macos)
            source scripts/setup-brew.sh
            setup_homebrew
            ;;
        linux)
            source scripts/setup-apt.sh
            setup_apt_packages
            ;;
    esac

    # Common setup (platform-agnostic)
    source scripts/setup-git.sh
    setup_git_config

    log_success "Installation complete!"
}

main "$@"
```

## Best Practices

### Portability
- Use `#!/usr/bin/env bash` (not `#!/bin/bash`)
- Avoid GNU-specific flags (or detect and adapt)
- Test on both macOS and Linux when possible

### Security
- Never commit secrets (use templates with placeholders)
- Validate all user input
- Use `mktemp` for temporary files/directories

### Maintainability
- Small, focused functions (do one thing well)
- Consistent error handling patterns
- Clear separation between lib, scripts, config
- Comprehensive test coverage

## References
- BATS: https://github.com/bats-core/bats-core
- Shellcheck: https://www.shellcheck.net/
- Google Shell Style Guide: https://google.github.io/styleguide/shellguide.html
- Dotfiles Guide: https://dotfiles.github.io/
