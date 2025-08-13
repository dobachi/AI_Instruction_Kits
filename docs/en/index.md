---
layout: default
title: AI Instruction Kits
description: Structured AI instruction management system
lang: en
---

# Welcome to AI Instruction Kits

**Efficiently manage and provide structured instructions to AI**

<div class="buttons">
  <a href="quickstart" class="btn">Quick Start</a>
  <a href="features" class="btn">Features</a>
  <a href="https://github.com/dobachi/AI_Instruction_Kits" class="btn">GitHub</a>
</div>

## 🎯 What is AI Instruction Kits?

AI Instruction Kits is a system that structurally manages instruction sets for AI development tools (Claude, ChatGPT, Gemini, etc.).

By centralizing management of scattered AI instructions, it achieves:
- **Consistency**: Unified instructions across projects
- **Efficiency**: No need to recreate instructions each time
- **Flexibility**: Easy customization and extension
- **Multilingual**: Japanese and English support

## 🚀 Key Features

### 🧩 NEW! Modular Instruction System
- **Dynamic instruction generation**: Customized to match your project
- **6 presets**: Academic research, business consulting, data analysis, and more
- **5 expertise modules**: Software engineering, legal engineering, ML/AI, parallel/distributed, data spaces

### 1. One-command Setup
```bash
bash scripts/setup-project.sh
```
Just run this command to complete the setup. Choose from 3 integration modes to match your project.

### 2. Rich Instruction Categories
- **System Management**: Basic instructions to control AI behavior
- **Coding**: Instructions specialized for programming tasks
- **Writing**: For document and content creation
- **Analysis**: For data analysis and research tasks
- **Creative**: Support for creative tasks
- **Agent-based**: Instructions to behave as specific experts

### 3. Checkpoint System
Automatically track work progress, enabling smooth task handover and continuity:
```
[2024-01-05 10:00:00][TASK-abc123][START] Implement user authentication API
[2024-01-05 10:30:00][TASK-abc123][COMPLETE] Result: Created 3 API endpoints, 15 tests
```

### 4. Claude Code Agent Support
Automate large-scale analysis tasks using Task tool (agent feature)

## 💡 Use Cases

### Typical Usage Scenarios

1. **Development Project Standardization**
   - Apply consistent coding standards across the team
   - Unified test writing methods
   - Common documentation format

2. **Onboarding New Team Members**
   - Quickly share project-specific rules
   - Understanding AI tool usage
   - Reduced learning curve

3. **Improving Work Efficiency**
   - Skip repetitive instruction creation
   - Quickly apply optimal instructions for the task
   - Track and visualize progress

## 📝 How to Use

1. **Initial Setup**
   ```bash
   git clone https://github.com/dobachi/AI_Instruction_Kits.git
   cd your-project
   bash path/to/AI_Instruction_Kits/scripts/setup-project.sh
   ```

2. **Give Instructions to AI**
   ```bash
   # Using the modular system (recommended)
   claude "Create a website"
   # → MODULE_COMPOSER automatically selects optimal modules
   
   # Traditional method
   claude "Refer to CLAUDE.md and implement user authentication API"
   ```

3. **Customize**
   Edit `instructions/PROJECT.md` to add project-specific settings

## 🌟 Why Choose AI Instruction Kits?

- **Open Source**: Apache-2.0 license, free to use
- **Flexible**: Easily add custom instructions
- **Proven**: Used in actual development projects
- **Community**: Growing ecosystem

## 📖 Documentation

- [Quick Start Guide](quickstart)
- [Features](features)
- [Proposals](proposals)
- [Developer Documentation](developers)
- [How to Use](usage)

<div style="margin-top: 3em; padding: 1em; background-color: #f0f8ff; border-radius: 8px;">
  <h3>🚀 Get Started Now</h3>
  <p>Set up AI Instruction Kits in just 5 minutes and improve your AI development efficiency!</p>
  <p><a href="quickstart" class="btn btn-primary">View Quick Start Guide →</a></p>
</div>