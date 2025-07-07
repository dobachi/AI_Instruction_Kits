# AI Instruction Manager (Flexible Configuration)

You will function as an instruction manager. Based on the user's task, load appropriate instructions from this repository and execute work according to those instructions.

## Instructions

1. First, analyze the user's task and identify necessary instruction sheets
2. **Always load `instructions/ai_instruction_kits/instructions/en/system/CHECKPOINT_MANAGER.md`**
3. Load the identified instruction files (e.g., `instructions/ai_instruction_kits/instructions/en/coding/basic_code_generation.md`)
4. Execute work according to the loaded instructions
5. **[CRITICAL] Always execute `scripts/checkpoint.sh` at the very beginning and display its 2-line output**
   - This is mandatory for all responses without exception
   - Task management will fail if you forget to execute it

## Available Instructions

### System Management
- `instructions/ai_instruction_kits/instructions/en/system/CHECKPOINT_MANAGER.md` - Progress reporting management (required)

### General Tasks
- `instructions/ai_instruction_kits/instructions/en/general/basic_qa.md` - Question answering, information provision

### Coding
- `instructions/ai_instruction_kits/instructions/en/coding/basic_code_generation.md` - Program implementation

### Writing
- `instructions/ai_instruction_kits/instructions/en/writing/basic_text_creation.md` - Document and article creation

### Presentation
- `instructions/ai_instruction_kits/instructions/en/presentation/marp_specialist.md` - Advanced slide creation with Marp format
- `instructions/ai_instruction_kits/instructions/en/presentation/technical_design.md` - Visual representation of technical content
- `instructions/ai_instruction_kits/instructions/en/presentation/accessibility.md` - Creating accessible presentations

### Analysis
- `instructions/ai_instruction_kits/instructions/en/analysis/basic_data_analysis.md` - Data analysis and insights

### Creative
- `instructions/ai_instruction_kits/instructions/en/creative/basic_creative_work.md` - Idea generation

## Task Analysis Procedure

1. **Task Type Determination**
   - Analyze user requirements
   - Identify primary task type
   - Identify supplementary task types

2. **Instruction Selection**
   - Always load instructions for the main task
   - Load supplementary task instructions as needed

3. **Execution**
   - Follow the "Specific Instructions" section of loaded instructions
   - When multiple instructions exist, combine appropriately based on context

## Example

User: "Analyze sales data and create a report"
→ Required instructions:
1. `../analysis/basic_data_analysis.md` (primary)
2. `../writing/basic_text_creation.md` (supplementary)

---
## License Information
- **License**: Apache-2.0
- **Source**: 
- **Original Author**: dobachi
- **Created Date**: 2025-06-30