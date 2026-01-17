# GitHub CLI Auto-Setup Feature

This project provides automatic GitHub CLI setup functionality for Claude Code on the Web environments.

## Overview

`scripts/gh-setup.sh` is a script that automatically installs GitHub CLI and configures authentication in remote environments (Claude Code on the Web). It runs as a SessionStart hook defined in `.claude/settings.json`.

## Features

- **Automatic Installation**: Auto-executes via SessionStart hook
- **Environment Detection**: Only runs when `CLAUDE_CODE_REMOTE=true`
- **Persistent PATH**: Installs to `~/.local/bin` with automatic PATH configuration
- **Version Control**: Configurable via `GH_SETUP_VERSION` environment variable
- **Authentication**: Auto-authenticates with `GH_TOKEN` or `GITHUB_TOKEN`

## Setup Instructions

### For This Project

The `.claude/settings.json` is already configured. You just need to set up environment variables.

#### Claude Code on the Web Configuration

1. **GitHub Token Setup**
   - Add environment variables in Claude Code on the Web settings
   - Set Personal Access Token to `GH_TOKEN` or `GITHUB_TOKEN`

2. **Network Settings**
   - Set network configuration to "Full" or "Custom"
   - For Custom, add `release-assets.githubusercontent.com` to allowlist

3. **Start Session**
   - GitHub CLI will be automatically installed when you start a new session

### For Other Projects

Run `scripts/setup-project.sh` to automatically deploy the configuration.

```bash
# If added as a submodule
cd /path/to/your/project
bash instructions/ai_instruction_kits/scripts/setup-project.sh

# If cloned this repository
bash /path/to/AI_Instruction_Kits/scripts/setup-project.sh
```

When you enable Claude Code configuration during setup, the following files will be deployed:

- `scripts/gh-setup.sh` - GitHub CLI auto-setup script
- `.claude/settings.json` - SessionStart hook configuration (only if file doesn't exist)

If `.claude/settings.json` already exists, manually add the following:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "bash scripts/gh-setup.sh",
        "timeout": 120
      }
    ]
  }
}
```

## Configuration Options

### Environment Variables

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `GH_SETUP_VERSION` | GitHub CLI version to install | `2.83.2` |
| `GH_TOKEN` | GitHub authentication token (preferred) | - |
| `GITHUB_TOKEN` | GitHub authentication token (alternative) | - |
| `CLAUDE_CODE_REMOTE` | Remote environment detection flag | - |

### Creating GitHub Personal Access Token

1. Open GitHub settings: https://github.com/settings/tokens
2. Select "Generate new token" → "Generate new token (classic)"
3. Select required scopes (minimum: `repo`)
4. Generate and copy the token
5. Set it as an environment variable in Claude Code on the Web

## Verification

How to verify the script is working correctly:

```bash
# Check if GitHub CLI is installed
which gh
# → /home/user/.local/bin/gh

# Check version
gh --version
# → gh version 2.83.2 (...)

# Check authentication status
gh auth status
# → ✓ Logged in to github.com as username (...)
```

## Troubleshooting

### GitHub CLI Not Installing

**Cause**: Network settings are restricted

**Solution**:
- Change network settings to "Full"
- Or add `release-assets.githubusercontent.com` to allowlist in "Custom" mode

### Authentication Fails

**Cause**: Token not set or invalid

**Solution**:
- Verify `GH_TOKEN` or `GITHUB_TOKEN` environment variable is correctly set
- Check if token hasn't expired
- Verify token has required scopes

### Installing in Local Environment

**Cause**: `CLAUDE_CODE_REMOTE` environment variable incorrectly set

**Solution**:
- Script only runs when `CLAUDE_CODE_REMOTE=true`
- Should automatically skip in local environments

## References

- Original project: [oikon48/gh-setup-hooks](https://github.com/oikon48/gh-setup-hooks)
- GitHub CLI official: https://cli.github.com/
- Claude Code on the Web: https://claude.ai/

## License

This script is an independent implementation inspired by MIT-licensed [gh-setup-hooks](https://github.com/oikon48/gh-setup-hooks).

---

Last updated: 2026-01-17
