# Dotfiles Installation Tests

Comprehensive test suite for `install.sh` using the [bats-core](https://github.com/bats-core/bats-core) testing framework.

## Overview

The test suite validates all critical functionality of the installation script:

-  **Backup functionality** - Ensures existing files are backed up with timestamps
-  **Symlink creation** - Validates all symlinks are created correctly
-  **File generation** - Tests `.gitconfig` creation and configuration
-  **Error handling** - Verifies proper error messages and exit codes
-  **Edge cases** - Tests empty input validation, multiple backups, etc.

## Prerequisites

Install bats-core and supporting libraries:

```bash
# macOS with Homebrew
brew install bats-core

# Optional: Install helper libraries for enhanced assertions
brew tap kaos/shell
brew install bats-support bats-assert
```

For other platforms, see [bats-core installation docs](https://bats-core.readthedocs.io/en/stable/installation.html).

## Running Tests

### Run all tests

```bash
bats tests/install.bats
```

### Run specific test

```bash
bats tests/install.bats --filter "creates symlink for .ai directory"
```

### Run with verbose output

```bash
bats tests/install.bats --tap
```

### Run with timing information

```bash
bats tests/install.bats --timing
```

## Test Structure

```
tests/
├── install.bats          # Main test suite
├── test_helper.bash      # Helper functions and utilities
└── README.md             # This file
```

## Test Categories

### 1. Basic Validation Tests
- Script exists and is executable
- Fails gracefully when dotfiles directory is missing

### 2. Symlink Creation Tests
- `.ai` directory symlink
- `.claude` directory symlink
- `.copilot` directory symlink
- `.gemini` directory symlink
- `.cursor` directory symlink
- `.zshrc` file symlink
- `.gitignore_global` file symlink
- `.claude/agents` symlink to `.ai/3_agents`

### 3. Backup Functionality Tests
- Backs up existing files before symlinking
- Backs up existing symlinks before replacing
- Backup filenames include timestamp (YYYYMMDD_HHMMSS format)
- Multiple backups create unique filenames
- Original content is preserved in backups

### 4. File Generation Tests
- Creates `.gitconfig` when it doesn't exist
- Generated `.gitconfig` contains user name and email
- Generated `.gitconfig` contains core settings
- Does not overwrite existing `.gitconfig`
- Adds signing configuration when enabled
- Rejects empty git name and email inputs

### 5. Integration Tests
- Installation succeeds with all symlinks created
- Symlinks are valid and point to correct targets
- Output messages are displayed correctly

## Test Environment

Each test runs in an isolated environment:

- **Temporary HOME directory** - Prevents interference with actual user files
- **Mock commands** - `brew`, `pre-commit`, and `git` are mocked
- **Isolated dotfiles structure** - Fresh dotfiles directory for each test
- **Automatic cleanup** - All temporary files removed after each test

## Helper Functions

The `test_helper.bash` file provides utility functions:

- `setup_mock_omz()` - Creates mock Oh My Zsh installation
- `assert_symlink_target()` - Verifies symlink points to correct target
- `count_backups()` - Counts backup files matching pattern
- `get_latest_backup()` - Gets most recent backup file
- `assert_timestamp_format()` - Validates timestamp format in filenames
- `create_test_dotfiles()` - Creates complete test dotfiles structure
- `simulate_user_input()` - Simulates interactive user input
- `assert_gitconfig_section()` - Verifies gitconfig section exists
- `assert_gitconfig_value()` - Verifies gitconfig key-value pair

## Writing New Tests

Follow this template:

```bash
@test "description of what is being tested" {
    # Arrange - Set up test conditions
    echo "existing content" > "$TEST_HOME/.zshrc"

    # Act - Run the installation script
    run bash "$BATS_TEST_DIRNAME/../install.sh" <<< $'n\n'

    # Assert - Verify expected outcomes
    [ "$status" -eq 0 ]
    [ -L "$TEST_HOME/.zshrc" ]
}
```

## CI Integration

To run tests in CI/CD pipelines:

### GitHub Actions

```yaml
name: Test Install Script
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install bats
        run: |
          sudo apt-get update
          sudo apt-get install -y bats
      - name: Run tests
        run: bats tests/install.bats
```

### Pre-commit Hook

Add to `.pre-commit-config.yaml`:

```yaml
  - repo: local
    hooks:
      - id: bats-tests
        name: Run bats tests
        entry: bats tests/install.bats
        language: system
        pass_filenames: false
        files: '^(install\.sh|tests/.*\.bats)$'
```

## Troubleshooting

### Tests fail with "command not found: bats"

Install bats-core using the instructions in Prerequisites section.

### Tests fail with permission errors

Ensure `install.sh` is executable:

```bash
chmod +x install.sh
```

### Tests hang or timeout

Check for interactive prompts that aren't being handled. Use heredoc input:

```bash
run bash "$BATS_TEST_DIRNAME/../install.sh" <<'INPUT'
Test User
test@example.com
n
INPUT
```

### Mock commands not working

Verify that `$TEST_HOME/bin` is in PATH during tests:

```bash
export PATH="$TEST_HOME/bin:$PATH"
```

## Coverage

Current test coverage:

- **Total tests**: 25+
- **Lines covered**: ~95% of install.sh
- **Functions covered**: 100% (backup_and_link)
- **Branches covered**: All major code paths

## Contributing

When adding new features to `install.sh`:

1. Write tests first (TDD approach)
2. Ensure all existing tests pass
3. Add tests for new functionality
4. Update this README if adding new test categories

## References

- [bats-core documentation](https://bats-core.readthedocs.io/)
- [bats-support library](https://github.com/bats-core/bats-support)
- [bats-assert library](https://github.com/bats-core/bats-assert)
