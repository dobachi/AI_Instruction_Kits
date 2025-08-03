---
description: "Reload AI instruction system and reset AI behavior"
---

# AI Instruction Reload & Reset

Update the AI instruction system to the latest version and reset AI behavior to follow instructions properly.

## Execution Content

1. **Save Current Task State**
   ```bash
   !echo "📋 Saving current task state..."
   !scripts/checkpoint.sh pending > /tmp/ai_tasks_backup.txt 2>&1 || echo "No task information"
   ```

2. **Update Submodule (Skip if this is the project itself)**
   ```bash
   !if [ -d "instructions/ai_instruction_kits/.git" ]; then
   !  echo "🔄 Updating AI instruction system..."
   !  git submodule update --remote instructions/ai_instruction_kits
   !else
   !  echo "📌 Running in AI Instruction Kits development environment (skipping submodule update)"
   !fi
   ```

3. **Check Update Status**
   ```bash
   !echo -e "\n✅ Current instruction system status:"
   !if [ -d "instructions/ai_instruction_kits/.git" ]; then
   !  git submodule status instructions/ai_instruction_kits
   !else
   !  echo "Development environment: $(git rev-parse --short HEAD)"
   !fi
   ```

4. **System Reset Declaration**
   Resetting AI system with the following steps:

   ### 🔄 Reset Complete
   
   I have been reset to the following state:
   - ✅ Recognizing the latest AI instruction system
   - ✅ Operating mode following ROOT_INSTRUCTION
   - ✅ Task management system ready
   - ✅ Preset-first instruction selection
   
   ### 📋 Applied Basic Rules
   1. **Task Management**: Progress management using checkpoint.sh
   2. **Instruction Selection**: Priority order: Preset → Modular → Legacy
   3. **Work Process**: Start task → Select instruction → Execute → Report completion
   4. **Path Recognition**: Automatic identification of development and submodule environments

5. **Reload ROOT_INSTRUCTION**
   Auto-detect path and load:
   @instructions/en/system/ROOT_INSTRUCTION.md or
   @instructions/ai_instruction_kits/instructions/en/system/ROOT_INSTRUCTION.md

6. **Check Saved Task State**
   ```bash
   !if [ -f "/tmp/ai_tasks_backup.txt" ]; then
   !  echo -e "\n📋 Saved tasks:"
   !  cat /tmp/ai_tasks_backup.txt
   !  rm /tmp/ai_tasks_backup.txt
   !fi
   ```

## Usage

```
/reload-and-reset
```

No arguments required. AI system will be completely reset and operate according to the latest instructions.

## Effects

- 🧠 AI behavior reset to follow instructions
- 📚 Load latest instruction system
- ✅ Re-initialize task management system

## Recommended Usage Timing

- When AI behaves not following instructions
- After long work sessions
- When instruction system is updated
- Before starting new task sessions