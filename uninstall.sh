#!/usr/bin/env bash

# Dotfiles Uninstall Script
# Reverts changes made by install.sh using the installation log

set -e

LOG_FILE="$HOME/.dotfiles_install.log"

echo "🗑️  Dotfiles Uninstall"
echo ""

# Check if log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "❌ Error: Installation log not found at $LOG_FILE"
    echo "   Cannot proceed without knowing what was installed."
    echo "   If you manually installed, you'll need to manually uninstall."
    exit 1
fi

# Show what will be removed
echo "📋 Reading installation log from: $LOG_FILE"
echo ""

# Parse log file to get installation details
INSTALL_DATE=$(grep "^INSTALL_DATE=" "$LOG_FILE" | cut -d= -f2)
AI_CONFIGS=$(grep "^AI_CONFIGS=" "$LOG_FILE" | cut -d= -f2 2>/dev/null || echo "unknown")
ZSH_CONFIGS=$(grep "^ZSH_CONFIGS=" "$LOG_FILE" | cut -d= -f2 2>/dev/null || echo "unknown")

echo "Installation date: $INSTALL_DATE"
echo "AI configs installed: $AI_CONFIGS"
echo "Zsh configs installed: $ZSH_CONFIGS"
echo ""

# Count items
SYMLINK_COUNT=$(grep -c "^SYMLINK=" "$LOG_FILE" 2>/dev/null || echo 0)
FILE_COUNT=$(grep -c "^FILE=" "$LOG_FILE" 2>/dev/null || echo 0)
BACKUP_COUNT=$(grep -c "^BACKUP=" "$LOG_FILE" 2>/dev/null || echo 0)

echo "Found in log:"
echo "  - $SYMLINK_COUNT symlinks"
echo "  - $FILE_COUNT files"
echo "  - $BACKUP_COUNT backups"
echo ""

# Ask what to remove
echo "⚠️  WARNING: This will remove dotfiles installed by install.sh"
echo ""
read -r -p "Remove all symlinks created by installer? [y/N]: " remove_symlinks
remove_symlinks=${remove_symlinks:-N}

read -r -p "Remove files created by installer (.zshrc, .gitconfig)? [y/N]: " remove_files
remove_files=${remove_files:-N}

if [[ "$BACKUP_COUNT" -gt 0 ]]; then
    read -r -p "Restore backup files? [y/N]: " restore_backups
    restore_backups=${restore_backups:-N}
fi

echo ""

# Track what was removed
REMOVED_COUNT=0
RESTORED_COUNT=0
FAILED_COUNT=0
FAILED_ITEMS=()

# Remove symlinks
if [[ "$remove_symlinks" =~ ^[Yy]$ ]]; then
    echo "=== Removing Symlinks ==="
    echo ""

    while IFS= read -r line; do
        if [[ "$line" =~ ^SYMLINK=(.+):(.+)$ ]]; then
            target="${BASH_REMATCH[1]}"

            if [ -L "$target" ]; then
                echo "🔗 Removing symlink: $target"
                if rm "$target"; then
                    ((REMOVED_COUNT++))
                else
                    echo "   ❌ Failed to remove"
                    FAILED_ITEMS+=("$target")
                    ((FAILED_COUNT++))
                fi
            elif [ -e "$target" ]; then
                echo "⚠️  Skipping $target (not a symlink)"
            else
                echo "ℹ️  Already removed: $target"
            fi
        fi
    done < "$LOG_FILE"

    echo ""
fi

# Remove files
if [[ "$remove_files" =~ ^[Yy]$ ]]; then
    echo "=== Removing Files ==="
    echo ""

    while IFS= read -r line; do
        if [[ "$line" =~ ^FILE=(.+)$ ]]; then
            target="${BASH_REMATCH[1]}"

            if [ -f "$target" ]; then
                echo "📄 Removing file: $target"
                if rm "$target"; then
                    ((REMOVED_COUNT++))
                else
                    echo "   ❌ Failed to remove"
                    FAILED_ITEMS+=("$target")
                    ((FAILED_COUNT++))
                fi
            else
                echo "ℹ️  Already removed: $target"
            fi
        fi
    done < "$LOG_FILE"

    echo ""
fi

# Restore backups
if [[ "${restore_backups:-N}" =~ ^[Yy]$ ]]; then
    echo "=== Restoring Backups ==="
    echo ""

    while IFS= read -r line <&3; do
        if [[ "$line" =~ ^BACKUP=(.+)$ ]]; then
            backup_file="${BASH_REMATCH[1]}"

            if [ -e "$backup_file" ]; then
                # Extract original filename by removing .backup.* suffix
                if [[ "$backup_file" =~ ^(.+)\.backup\.[0-9]{8}_[0-9]{6} ]]; then
                    original="${BASH_REMATCH[1]}"

                    echo "📦 Restoring: $backup_file -> $original"

                    # Check if target already exists
                    if [ -e "$original" ] || [ -L "$original" ]; then
                        echo "   ⚠️  Warning: $original already exists"
                        read -r -p "   Overwrite? [y/N]: " overwrite
                        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
                            echo "   Skipped"
                            continue
                        fi
                        rm -rf "$original"
                    fi

                    if mv "$backup_file" "$original"; then
                        echo "   ✓ Restored"
                        ((RESTORED_COUNT++))
                    else
                        echo "   ❌ Failed to restore"
                        FAILED_ITEMS+=("$backup_file")
                        ((FAILED_COUNT++))
                    fi
                fi
            else
                echo "ℹ️  Backup not found: $backup_file"
            fi
        fi
    done 3< "$LOG_FILE"

    echo ""
fi

# Summary
echo "=== Summary ==="
echo ""
echo "✓ Removed: $REMOVED_COUNT items"
echo "✓ Restored: $RESTORED_COUNT backups"

if [ $FAILED_COUNT -gt 0 ]; then
    echo "❌ Failed: $FAILED_COUNT items"
    echo ""
    echo "Failed items:"
    for item in "${FAILED_ITEMS[@]}"; do
        echo "  - $item"
    done
    echo ""
fi

# Ask about removing log file
if [[ "$remove_symlinks" =~ ^[Yy]$ ]] || [[ "$remove_files" =~ ^[Yy]$ ]]; then
    echo ""
    read -r -p "Remove installation log file? [y/N]: " remove_log
    remove_log=${remove_log:-N}

    if [[ "$remove_log" =~ ^[Yy]$ ]]; then
        if rm "$LOG_FILE"; then
            echo "🗑️  Installation log removed: $LOG_FILE"
        else
            echo "❌ Failed to remove log file"
        fi
    else
        echo "ℹ️  Keeping installation log: $LOG_FILE"
        echo "   You can run this uninstaller again later"
    fi
fi

echo ""
echo "✅ Uninstallation complete!"
