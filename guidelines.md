# Dotfiles Guidelines

Implementation details, tech stack, and tooling.

See also: [`constitution.md`](constitution.md), [`AGENTS.md`](AGENTS.md)

---

## Tech Stack

**Shell:**
- Bash 4.0+ (macOS: Homebrew, Linux: system)
- Zsh 5.8+ with oh-my-zsh + Powerlevel10k

**Testing:**
- BATS 1.10+, bats-support 0.3.0+, bats-assert 2.1.0+, shellcheck 0.9.0+

**Package Management:**
- Homebrew 4.0+ (macOS), apt/yum (Linux)

**Version Control:**
- Git 2.40+, pre-commit 3.0+

---

## Project Structure

See [`constitution.md`](constitution.md) Architecture Decisions for directory tree.

**Key locations:**
- `.ai/` - Shared agent-agnostic core
- `.claude/`, `.copilot/`, `.gemini/`, `.cursor/` - Tool wrappers
- `tests/` - BATS tests
- `specs/` - Feature specifications

---

## Naming Conventions

**Files:** `kebab-case.sh` (e.g., `setup-git.sh`)
**Functions:** `snake_case` with `verb_noun` pattern (e.g., `backup_file()`)
**Variables:** `snake_case` (e.g., `config_file`)
**Constants:** `UPPER_CASE` (e.g., `DEFAULT_SHELL`)
**Tests:** `feature-name.bats`

---

## Code Style Guidelines

### Script Headers

```bash
#!/usr/bin/env bash
# Description: One-line description
# Usage: script.sh [options]

set -euo pipefail
```

### Function Structure

```bash
# Brief description
# Args: $1 - first arg, $2 - second (optional)
# Returns: 0 on success, 1 on failure
function_name() {
    local arg1="$1"
    local arg2="${2:-default}"

    [[ -z "$arg1" ]] && { echo "Error: required" >&2; return 1; }

    echo "Processing $arg1"
    return 0
}
```

### Error Handling

```bash
# Command check
! command -v brew &> /dev/null && { echo "Error: missing" >&2; exit 1; }

# Cleanup
cleanup() { rm -rf "$TEMP_DIR"; }
trap cleanup EXIT ERR
TEMP_DIR="$(mktemp -d)"
```

### Platform Detection

```bash
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)  echo "linux" ;;
        *)       echo "unknown" ;;
    esac
}
```

### Common Patterns

**File reading:**
```bash
while IFS= read -r line; do
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    echo "Processing: $line"
done < "$file"
```

**Prompts:**
```bash
read -r -p "Install? [Y/n]: " answer
answer="${answer:-Y}"
[[ "$answer" =~ ^[Yy]$ ]] && echo "Installing..."
```

**Arrays:**
```bash
FAILED=()
FAILED+=("item")
[[ ${#FAILED[@]} -gt 0 ]] && echo "Failed: ${FAILED[*]}"
```

---

## Testing Standards

### BATS Structure

```bash
#!/usr/bin/env bats
load 'test_helper'

setup() {
    export TEST_TEMP_DIR="$(mktemp -d)"
}

teardown() {
    rm -rf "$TEST_TEMP_DIR"
}

@test "function: should handle valid input" {
    run function_name "input"
    assert_success
    assert_output "expected"
}

@test "function: should be idempotent" {
    run function_name "value"
    assert_success
    run function_name "value"  # Second run
    assert_success
}
```

### Assertions

```bash
assert_success / assert_failure
assert_output "exact" / assert_output --partial "sub"
assert_line --index 0 "first"
assert_file_exists "$file"  # Custom helper
```

### Test Helpers

```bash
# tests/test_helper.bash
load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

assert_file_exists() {
    [[ -f "$1" ]] || fail "Missing: $1"
}

mock_command() {
    eval "$1() { echo \"$2\"; }"
    export -f "$1"
}
```

---

## Configuration Patterns

### Template Substitution

```bash
install_from_template() {
    local template="$1" target="$2"
    [[ ! -f "$template" ]] && return 1

    read -r -p "Git name: " name
    read -r -p "Git email: " email
    [[ -z "$name" || -z "$email" ]] && return 1

    sed -e "s/__GIT_USER_NAME__/$name/" \
        -e "s/__GIT_USER_EMAIL__/$email/" \
        "$template" > "$target"
}
```

### Backup and Symlink

```bash
backup_and_link() {
    local source="$1" target="$2" name="$3"
    [[ -z "$source" || -z "$target" ]] && return 1
    [[ ! -e "$source" ]] && return 1

    if [[ -e "$target" || -L "$target" ]]; then
        [[ "$CREATE_BACKUPS" =~ ^[Yy]$ ]] && \
            mv "$target" "$target.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    ln -s "$source" "$target"
}
```

### Package Installation

```bash
install_brew_packages() {
    local file="$1"
    [[ ! -f "$file" ]] && return 1

    while IFS= read -r pkg; do
        [[ -z "$pkg" || "$pkg" =~ ^[[:space:]]*# ]] && continue
        brew list "$pkg" &> /dev/null || brew install "$pkg"
    done < "$file"
}
```

---

## Environment Variables

**Installation:**
```bash
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Projects/dotfiles}"
AI_DIR="$HOME/.ai"
CLAUDE_DIR="$HOME/.claude"
```

**Shell:**
```bash
ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
NVM_DIR="$HOME/.nvm"
SDKMAN_DIR="$HOME/.sdkman"
```

---

## Logging Standards

```bash
log_info()    { echo "[INFO] $*" >&2; }
log_error()   { echo "[ERROR] $*" >&2; }
log_success() { echo "[SUCCESS] $*" >&2; }
log_warning() { echo "[WARNING] $*" >&2; }
```

All logs to stderr (`>&2`) to avoid polluting stdout.

---

## Security Guidelines

**Never commit:** SSH keys, API tokens, passwords, personal info

**Use templates:**
```bash
# gitconfig.template
[user]
    name = __GIT_USER_NAME__
    email = __GIT_USER_EMAIL__
```

**Validate inputs:**
```bash
validate_email() {
    [[ -z "$1" ]] && return 1
    [[ "$1" =~ ^[^@]+@[^@]+\.[^@]+$ ]] || return 1
}
```

**File permissions:**
```bash
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.gitconfig
```

---

## Deployment

**Install:**
```bash
git clone <repo> ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh
```

**Update:**
```bash
cd ~/Projects/dotfiles
git pull && ./install.sh
```

**Health check:**
```bash
ls -la ~/.ai ~/.claude
source ~/.zshrc
bats tests/install.bats
```

---

## Version Management

**SemVer:** MAJOR.MINOR.PATCH
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes

**Constitution versioning:**
```yaml
---
version: "1.0"
---
```

**Git:**
- Commit format: Imperative mood, explain "why"
- Branch: `feature/`, `fix/`, `refactor/`, `docs/`
- Pre-commit: shellcheck + BATS (NO `--no-verify`)
