#!/bin/bash

# Git Worktree Manager for AI Instruction Kits
# 
# Usage:
#   worktree-manager.sh create <task-id> <description>
#   worktree-manager.sh list
#   worktree-manager.sh switch <task-id>
#   worktree-manager.sh complete <task-id>
#   worktree-manager.sh clean

set -e

# Configuration
WORKTREE_DIR=".gitworktrees"
WORKTREE_PREFIX="ai"

# Ensure we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository" >&2
    exit 1
fi

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel)
WORKTREE_PATH="$REPO_ROOT/$WORKTREE_DIR"

# Create worktree directory if it doesn't exist
mkdir -p "$WORKTREE_PATH"

# Function to sanitize branch names
sanitize_name() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//'
}

# Function to get worktree name from task ID
get_worktree_name() {
    local task_id="$1"
    local description="$2"
    local sanitized_desc=$(sanitize_name "$description")
    echo "${WORKTREE_PREFIX}-${task_id}-${sanitized_desc}"
}

# Command: create
cmd_create() {
    local task_id="$1"
    local description="$2"
    
    if [ -z "$task_id" ] || [ -z "$description" ]; then
        echo "❌ Error: Usage: $0 create <task-id> <description>" >&2
        exit 1
    fi
    
    local worktree_name=$(get_worktree_name "$task_id" "$description")
    local worktree_path="$WORKTREE_PATH/$worktree_name"
    local branch_name="$worktree_name"
    
    # Check if worktree already exists
    if [ -d "$worktree_path" ]; then
        echo "⚠️  Worktree already exists: $worktree_name"
        echo "📁 Path: $worktree_path"
        exit 0
    fi
    
    # Get current branch to base new branch on
    local base_branch=$(git rev-parse --abbrev-ref HEAD)
    
    # Create new worktree
    echo "🌲 Creating worktree: $worktree_name"
    git worktree add "$worktree_path" -b "$branch_name" "$base_branch"
    
    echo "✅ Worktree created successfully!"
    echo "📁 Path: $worktree_path"
    echo "🌿 Branch: $branch_name"
    echo ""
    echo "To switch to this worktree:"
    echo "  cd $worktree_path"
}

# Command: list
cmd_list() {
    echo "📋 Active worktrees:"
    echo ""
    
    if ! git worktree list > /dev/null 2>&1; then
        echo "No worktrees found."
        return
    fi
    
    # List all worktrees, highlighting AI task worktrees
    git worktree list | while read -r line; do
        if echo "$line" | grep -q "$WORKTREE_DIR"; then
            # Extract worktree info
            local path=$(echo "$line" | awk '{print $1}')
            local branch=$(echo "$line" | awk '{print $3}' | tr -d '[]')
            local worktree_name=$(basename "$path")
            
            # Extract task ID if it's an AI worktree
            if [[ "$worktree_name" =~ ^${WORKTREE_PREFIX}-(TASK-[0-9]+-[a-z0-9]+)-(.+)$ ]]; then
                local task_id="${BASH_REMATCH[1]}"
                echo "🤖 $worktree_name"
                echo "   📌 Task ID: $task_id"
                echo "   🌿 Branch: $branch"
                echo "   📁 Path: $path"
                echo ""
            fi
        fi
    done
}

# Command: switch
cmd_switch() {
    local task_id="$1"
    
    if [ -z "$task_id" ]; then
        echo "❌ Error: Usage: $0 switch <task-id>" >&2
        exit 1
    fi
    
    # Find worktree with matching task ID
    local found=false
    git worktree list | while read -r line; do
        if echo "$line" | grep -q "$WORKTREE_DIR.*$task_id"; then
            local path=$(echo "$line" | awk '{print $1}')
            echo "📁 Switching to worktree: $(basename "$path")"
            echo "Run: cd $path"
            found=true
            break
        fi
    done
    
    if [ "$found" = false ]; then
        echo "❌ Error: No worktree found for task ID: $task_id" >&2
        exit 1
    fi
}

# Command: complete
cmd_complete() {
    local task_id="$1"
    
    if [ -z "$task_id" ]; then
        echo "❌ Error: Usage: $0 complete <task-id>" >&2
        exit 1
    fi
    
    # Find worktree with matching task ID
    local worktree_path=""
    local branch_name=""
    
    git worktree list | while read -r line; do
        if echo "$line" | grep -q "$WORKTREE_DIR.*$task_id"; then
            worktree_path=$(echo "$line" | awk '{print $1}')
            branch_name=$(echo "$line" | awk '{print $3}' | tr -d '[]')
            break
        fi
    done
    
    if [ -z "$worktree_path" ]; then
        echo "❌ Error: No worktree found for task ID: $task_id" >&2
        exit 1
    fi
    
    echo "🏁 Completing worktree for task: $task_id"
    echo "🌿 Branch: $branch_name"
    echo ""
    echo "Options:"
    echo "1) Merge to current branch and delete worktree"
    echo "2) Keep worktree for later"
    echo "3) Delete worktree without merging"
    echo ""
    read -p "Select option (1-3): " option
    
    case $option in
        1)
            # Merge and delete
            local current_branch=$(git rev-parse --abbrev-ref HEAD)
            echo "🔀 Merging $branch_name into $current_branch..."
            git merge "$branch_name"
            echo "🗑️  Removing worktree..."
            git worktree remove "$worktree_path"
            git branch -d "$branch_name"
            echo "✅ Worktree completed and merged!"
            ;;
        2)
            # Keep worktree
            echo "✅ Worktree kept for later use"
            ;;
        3)
            # Delete without merging
            echo "🗑️  Removing worktree..."
            git worktree remove "$worktree_path"
            git branch -D "$branch_name"
            echo "✅ Worktree removed without merging"
            ;;
        *)
            echo "❌ Invalid option"
            exit 1
            ;;
    esac
}

# Command: clean
cmd_clean() {
    echo "🧹 Cleaning up worktrees..."
    
    # Prune worktree information
    git worktree prune
    
    # List orphaned directories
    local orphaned=0
    for dir in "$WORKTREE_PATH"/*; do
        if [ -d "$dir" ]; then
            local dir_name=$(basename "$dir")
            if ! git worktree list | grep -q "$dir_name"; then
                echo "🗑️  Removing orphaned directory: $dir_name"
                rm -rf "$dir"
                orphaned=$((orphaned + 1))
            fi
        fi
    done
    
    if [ $orphaned -eq 0 ]; then
        echo "✅ No orphaned directories found"
    else
        echo "✅ Cleaned up $orphaned orphaned directories"
    fi
}

# Main command dispatcher
case "${1:-}" in
    create)
        shift
        cmd_create "$@"
        ;;
    list)
        cmd_list
        ;;
    switch)
        shift
        cmd_switch "$@"
        ;;
    complete)
        shift
        cmd_complete "$@"
        ;;
    clean)
        cmd_clean
        ;;
    *)
        echo "Git Worktree Manager for AI Instruction Kits"
        echo ""
        echo "Usage:"
        echo "  $0 create <task-id> <description>  - Create new worktree for a task"
        echo "  $0 list                            - List all AI task worktrees"
        echo "  $0 switch <task-id>                - Show path to switch to a worktree"
        echo "  $0 complete <task-id>              - Complete and optionally merge a worktree"
        echo "  $0 clean                           - Clean up orphaned worktrees"
        echo ""
        echo "Examples:"
        echo "  $0 create TASK-123456-abc \"api development\""
        echo "  $0 switch TASK-123456-abc"
        echo "  $0 complete TASK-123456-abc"
        exit 1
        ;;
esac