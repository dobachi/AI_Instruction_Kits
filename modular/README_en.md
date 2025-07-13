# Modular Instruction System

## Overview

This directory contains a system for modularizing and dynamically combining AI instructions.

## Directory Structure

```
modular/
├── ja/                # Japanese modules
│   ├── modules/       # Module files
│   │   ├── core/      # Core modules
│   │   ├── tasks/     # Task modules
│   │   ├── skills/    # Skill modules
│   │   ├── quality/   # Quality modules
│   │   └── fragments/ # Fragments
│   └── templates/     # Template files
│       ├── presets/   # Preset definitions
│       └── custom/    # Custom templates
├── en/                # English modules
│   ├── modules/       # Module files
│   │   ├── core/      # Core modules
│   │   ├── tasks/     # Task modules
│   │   ├── skills/    # Skill modules
│   │   ├── quality/   # Quality modules
│   │   └── fragments/ # Fragments
│   └── templates/     # Template files
│       ├── presets/   # Preset definitions
│       └── custom/    # Custom templates
├── cache/             # Generated instruction cache (language-agnostic)
└── composer.py        # Module composition engine
```

## Metadata System

Each module manages metadata with a `.yaml` file of the same name:

- `ja/modules/tasks/web_api_development.md` - Module content (Japanese)
- `ja/modules/tasks/web_api_development.yaml` - Metadata (Japanese)
- `en/modules/tasks/web_api_development.md` - Module content (English)
- `en/modules/tasks/web_api_development.yaml` - Metadata (English)

### Metadata File Example

```yaml
id: "task_web_api"
name: "Web API Development"
description: "Basic structure for RESTful Web API development"
version: "1.0.0"
tags: ["api", "web", "backend"]
category: "tasks"
variables:
  - name: "framework"
    description: "Web framework to use"
    type: "string"
    default: "FastAPI"
```

## Usage

### Language Specification

Use the `-l` or `--lang` option to specify language (default: ja):

```bash
# Use Japanese modules (default)
python modular/composer.py list modules

# Use English modules
python modular/composer.py -l en list modules
```

### Basic Usage

```bash
# List modules
./scripts/generate-instruction.sh --list

# Generate with specified modules
./scripts/generate-instruction.sh --modules task_web_api skill_tdd

# Use a preset
./scripts/generate-instruction.sh --preset web_api_production

# Update cache
./scripts/generate-instruction.sh --refresh-cache
```

## For Developers

Steps to add a new module:

1. Create a module file (.md) in the appropriate category directory
2. Create a metadata file (.yaml) with the same name
3. Update cache: `./scripts/generate-instruction.sh --refresh-cache`

---
## License Information
- **License**: MIT
- **Created**: 2025-01-08