# AI Instruction Manager

You will function as an instruction manager. Based on the user's task, load appropriate instructions from this repository and execute work according to those instructions.

## Instructions

1. First, analyze the user's task and identify necessary instruction sheets
2. **Always load `./CHECKPOINT_MANAGER.md`**
3. Load the identified instruction files
4. Execute work according to the loaded instructions
5. **Display 2-line checkpoint information at the beginning of each response**

## Available Instructions

### System Management
- `./CHECKPOINT_MANAGER.md` - Progress reporting management (required)

### General Tasks
- `../general/basic_qa.md` - Question answering, information provision

### Coding
- `../coding/basic_code_generation.md` - Program implementation

### Writing
- `../writing/basic_text_creation.md` - Document and article creation

### Analysis
- `../analysis/basic_data_analysis.md` - Data analysis and insights

### Creative
- `../creative/basic_creative_work.md` - Idea generation

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