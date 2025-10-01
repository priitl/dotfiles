#!/usr/bin/env bash
# Initialize AGENTS.md in a new project
#
# Usage:
#   ./scripts/init-project-agents.sh
#   Or from anywhere: ~/.dotfiles/scripts/init-project-agents.sh

set -euo pipefail

# Colors for output
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m' # No Color

# Dotfiles location - check common locations
if [[ -d "${HOME}/.dotfiles" ]]; then
    readonly DOTFILES_DIR="${HOME}/.dotfiles"
elif [[ -d "${HOME}/Projects/dotfiles" ]]; then
    readonly DOTFILES_DIR="${HOME}/Projects/dotfiles"
else
    readonly DOTFILES_DIR="${HOME}/.dotfiles"
fi
readonly AGENTS_TEMPLATE="${DOTFILES_DIR}/.ai/AGENTS.md"

log_info() {
    echo -e "${GREEN}✓${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}⚠${NC} $*"
}

log_error() {
    echo -e "${RED}✗${NC} $*" >&2
}

main() {
    # Check if AGENTS.md already exists
    if [[ -f "AGENTS.md" ]]; then
        log_warn "AGENTS.md already exists in current directory"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Aborted. No changes made."
            exit 0
        fi
    fi

    # Check if dotfiles are installed
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        log_error "Dotfiles not found at $DOTFILES_DIR"
        echo "Install dotfiles first:"
        echo "  git clone https://github.com/priitl/dotfiles ~/.dotfiles"
        echo "  cd ~/.dotfiles && ./install.sh"
        exit 1
    fi

    # Check if AGENTS.md template exists
    if [[ ! -f "$AGENTS_TEMPLATE" ]]; then
        log_error "AGENTS.md template not found at $AGENTS_TEMPLATE"
        exit 1
    fi

    # Check if ~/.ai/3_agents/ exists
    if [[ ! -d "${HOME}/.ai/3_agents" ]]; then
        log_error "Agent definitions not found at ~/.ai/3_agents/"
        echo "Run dotfiles install.sh to set up symlinks."
        exit 1
    fi

    # Copy template
    cp "$AGENTS_TEMPLATE" AGENTS.md
    log_info "AGENTS.md created in current directory"

    # Suggest next steps
    echo ""
    echo "Next steps:"
    echo "  1. Review AGENTS.md and customize for your project"
    echo "  2. Create constitution.md if needed:"
    echo "     cp ~/.ai/4_specs/constitution-template.md constitution.md"
    echo "  3. Create specs/ directory for feature specifications:"
    echo "     mkdir -p specs"
    echo ""
    log_info "Done! Your project is ready to use AI agents."
}

main "$@"
