---
layout: default
title: AI Instruction Kits
description: Quick Start Guide - Get started with AI Instruction Kits in 5 minutes
lang: en
---

# Quick Start Guide

Get AI Instruction Kits integrated into your project in just 5 minutes!

## 📋 Prerequisites

- Git (for submodule/clone modes)
- Bash shell
- AI development tools (Claude, ChatGPT, Gemini, etc.)

## 🚀 Step 1: Get the Repository

```bash
# Clone AI Instruction Kits
git clone https://github.com/dobachi/AI_Instruction_Kits.git
cd AI_Instruction_Kits
```

## 🔧 Step 2: Setup in Your Project

Run this in your project's root directory:

```bash
# Interactive setup (recommended)
bash path/to/AI_Instruction_Kits/scripts/setup-project.sh
```

### Choose Setup Mode

Select from 3 modes displayed on screen:

```
🎯 Select AI instruction integration mode:

1) copy      - Simple file copy (no Git)
2) clone     - Independent Git repository (fully customizable)
3) submodule - Git submodule (recommended)

Choose [1-3] (default: 3): 
```

## 📝 Step 3: Customize Project Settings

Edit the generated `instructions/PROJECT.md`:

```markdown
## Project-specific Additional Instructions

### Examples:
- Coding standards: Follow ESLint configuration
- Test framework: Jest
- Build command: npm run build
- Lint command: npm run lint
- Other constraints: TypeScript strict mode
```

## 💬 Step 4: Give Instructions to AI

### For Claude
```bash
# Load project settings and start working
claude "Refer to CLAUDE.md and implement user authentication API"
```

### For ChatGPT
```bash
# Upload file or copy & paste
"Follow the contents of CLAUDE.md and design the database schema"
```

### For Gemini
```bash
# Upload file or copy & paste
"Follow the contents of GEMINI.md and design the database schema"
```

## 🎯 Practical Examples

### Example 1: Create React Component
```bash
claude "Refer to CLAUDE.md and create a React component to display product list.
- Use Material-UI
- With pagination
- With search functionality"
```

### Example 2: API Design
```bash
claude "Refer to CLAUDE.md and design a RESTful API.
Endpoints:
- User management (CRUD)
- Authentication (using JWT)
- File upload"
```

## ⚡ Advanced Usage

### Using Custom Repository

```bash
# Use forked repository
bash setup-project.sh --url https://github.com/yourname/AI_Instruction_Kits.git --clone

# Use private repository
bash setup-project.sh --url git@github.com:company/private-instructions.git --submodule
```

### Automated Setup in CI/CD

```bash
# Run without confirmation prompts
bash setup-project.sh --submodule --force
```

## 📊 Progress Management

Checkpoint feature automatically records your work:

```bash
# Check progress log
cat checkpoint.log

# Example output:
[2024-01-05 10:00:00][TASK-abc123][START] Implement user authentication API (estimated 5 steps)
[2024-01-05 10:30:00][TASK-abc123][COMPLETE] Result: Created 3 API endpoints, 15 tests
```

## ❓ FAQ

### Q: Will it affect my existing project?
A: Minimal impact. Only adds:
- `instructions/` directory
- Symbolic links (CLAUDE.md, etc.)
- Link to `scripts/checkpoint.sh`

### Q: Is it Japanese only?
A: Both Japanese and English are supported. Edit `PROJECT.en.md` for English version.

### Q: Can I customize it?
A: Yes! All instructions are freely editable, and adding new instructions is easy.

## 🎉 Setup Complete!

AI Instruction Kits is now integrated into your project.
Enjoy efficient AI-powered development!

<div style="margin-top: 3em; padding: 1em; background-color: #f0f8ff; border-radius: 8px;">
  <h3>🚀 Next Steps</h3>
  <ul>
    <li><a href="features">View detailed features</a></li>
    <li><a href="https://github.com/dobachi/AI_Instruction_Kits">Check source code on GitHub</a></li>
    <li><a href="https://github.com/dobachi/AI_Instruction_Kits/issues">Submit questions or requests</a></li>
  </ul>
</div>