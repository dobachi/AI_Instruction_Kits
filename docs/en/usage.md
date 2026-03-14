---
layout: default
title: AI Instruction Kits
description: Usage Guide - Detailed usage and best practices
lang: en
---

# Usage Guide

Learn detailed usage and best practices for AI Instruction Kits.

## 📖 Basic Usage

### 1. Using a Single Instruction

The simplest way to reference a specific instruction directly:

```bash
# For Claude
claude "Refer to instructions/en/coding/basic_code_generation.md and write code to generate Fibonacci sequence"

# For ChatGPT/Gemini (after uploading file)
"Follow the instructions to design a RESTful API"
```

### 2. Combining Multiple Instructions

Using ROOT_INSTRUCTION.md, AI automatically selects appropriate instructions:

```bash
claude "Refer to ROOT_INSTRUCTION.md to analyze sales data and create a report"
```

### 3. After Project Integration

After setup completion, simply use:

```bash
claude "Refer to CLAUDE.md and implement user authentication"
```

## 🎯 Effective Usage

### Pattern 1: Step-by-Step Application

Process complex tasks in stages:

```markdown
# In v2.0, ROOT_INSTRUCTION automatically selects skills for each step
Step 1: Refer to ROOT_INSTRUCTION.md to analyze data (analysis skill auto-selected)
Step 2: Refer to ROOT_INSTRUCTION.md to create report (writing skill auto-selected)
Step 3: Refer to ROOT_INSTRUCTION.md to generate improvements (creative skill auto-selected)

# Or install specialized skills from the marketplace
# Simply place them in .claude/skills/ to make them available
```

### Pattern 2: Role Distribution

Combine main and support instructions:

```markdown
Main: instructions/en/coding/basic_code_generation.md
Support: instructions/en/general/basic_qa.md (for technical Q&A)
```

### Pattern 3: Agent-based Approach

Act as specific experts:

```bash
claude "Refer to instructions/en/agent/python_expert.md 
and optimize this Python code"
```

## ⚙️ Customization

### Editing PROJECT.md

Add project-specific settings:

```markdown
## Project-specific Additional Instructions

### Coding Standards
- ESLint config: Follow .eslintrc.js
- Naming convention: camelCase
- Comments: JSDoc format

### Test Requirements
- Coverage: 80% minimum
- E2E tests: Using Cypress

### Build Settings
- Build command: npm run build
- Lint command: npm run lint
- Test command: npm run test
```

### Adding New Instructions

1. Copy template:
```bash
cp templates/en/instruction_template.md instructions/en/[category]/my_instruction.md
```

2. Edit content

3. Add to ROOT_INSTRUCTION.md (optional)

### Skill-Based Workflow

In v2.0, the Skill Orchestrator (ROOT_INSTRUCTION) automatically selects optimal skills from `.claude/skills/` based on your task.

#### Core Skills
```bash
# checkpoint-manager: Task progress management
scripts/checkpoint.sh start "New feature development" 5

# worktree-manager: Safe working branch management
scripts/worktree-manager.sh create TASK-123 "feature-dev"

# auto-build: Automatic build and test
# Detects project type and runs appropriate build

# commit-safe: Clean commits without AI signatures
scripts/commit.sh "feat: Add new feature"
```

#### Marketplace Skills

Add community-built skills from [claude-skills-marketplace](https://github.com/dobachi/claude-skills-marketplace).
Simply place skill files in `.claude/skills/` to make them available.

### Organization Customization Example

```markdown
# Internal Project Configuration
## Base Instructions
- instructions/en/coding/basic_code_generation.md

## Additional Rules
- Follow internal coding standards
- Comply with security guidelines
- Write comments in English
- Exclude confidential information
```

## 📊 Using Checkpoint Feature

### Recording Work

Checkpoint feature automatically records:

```bash
# Recorded content
[timestamp][task ID][status] Task name (estimated steps)
[timestamp][task ID][COMPLETE] Result: Specific outcomes

# How to check
cat checkpoint.log
```

### Visualizing Progress

```bash
# Completed tasks count
grep "COMPLETE" checkpoint.log | wc -l

# Today's work
grep "$(date +%Y-%m-%d)" checkpoint.log

# Check errors
grep "ERROR" checkpoint.log
```

## 🔍 Troubleshooting

### Q: What if instructions conflict?

A: Prioritize more specific instructions. Specify priority in PROJECT.md.

```markdown
## Instruction Priority
1. PROJECT.md (highest)
2. Task-specific instructions
3. Category instructions
4. Basic instructions
```

### Q: What if instructions are too long?

A: Extract only necessary parts or create summary version.

```bash
# Use specific section only
"Refer to 'Error Handling' section in instructions/en/coding/basic_code_generation.md"
```

### Q: How to mix languages?

A: Explicitly specify language for each instruction.

```markdown
- Explain in English: instructions/en/general/basic_qa.md
- Code in comments: instructions/en/coding/basic_code_generation.md
```

## 🎯 Best Practices

### 1. Selecting Appropriate Instructions
- Choose most suitable instructions for the task
- Don't use more instructions than necessary
- Combine with clear purpose

### 2. Managing Customizations
- Centralize in PROJECT.md
- Track changes with version control
- Share with team

### 3. Feedback Loop
- Evaluate usage results
- Continuously improve instructions
- Document best practices

## 📚 Learn More

- [Features](features) - Detailed feature explanations
- [Quick Start](quickstart) - Get started in 5 minutes
- [GitHub](https://github.com/dobachi/AI_Instruction_Kits) - Source code

<div style="margin-top: 3em; padding: 1em; background-color: #f0f8ff; border-radius: 8px;">
  <h3>💡 Tip</h3>
  <p>Start with basic instructions and gradually use advanced features as you become familiar with the system.</p>
</div>