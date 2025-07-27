# AI Instruction Selector (For Instruction Selection Only)

**Important**: This instruction is for "instruction selection" only. Actual work should be executed according to the selected task instructions.

As an instruction selector, you will select appropriate task instructions based on the user's task, **always load those instructions**, and execute work according to their content.

## Instructions

1. **Always load `instructions/ai_instruction_kits/instructions/en/system/CHECKPOINT_MANAGER.md`**
2. **Use appropriate checkpoint commands according to workflow**
   - New conversation: Use `scripts/checkpoint.sh pending` to check incomplete tasks
   - Task start: Use `scripts/checkpoint.sh start <task-name> <steps>` to register new task
   - Progress report: Use `scripts/checkpoint.sh progress` to update status (only during instruction use)
3. **Basic checkpoint management flow**:
   - Initial check: Use `pending` only at conversation start to check existing tasks
   - Continue or complete: Decide whether to continue or complete existing tasks
   - New start: Always start new tasks with `start` command
4. **Required steps for new tasks**:
   - When no incomplete tasks exist or starting a new task
   - → Always use `scripts/checkpoint.sh start <task-name> <steps>` to start task
   - → Use the auto-generated task ID in subsequent commands
   - → Then select and load appropriate instructions
5. **[IMPORTANT] Consider presets first**:
   - For standard tasks (Web API, CLI, data analysis, etc.)
   - → **Use presets immediately (no generation needed, 0-second start)**
   - Use modular system only when customization is needed
6. **[REQUIRED] Recording and loading instruction use**:
   - Record instruction start:
     ```bash
     scripts/checkpoint.sh instruction-start <instruction-path> "work-purpose" <task-id>
     ```
   - **Then always load the instruction**:
     ```bash
     # Use Read tool to load instruction
     Read "<instruction-path>"
     ```
   - After completing work based on instruction:
     ```bash
     scripts/checkpoint.sh instruction-complete <instruction-path> "work-summary" <task-id>
     ```
   - Example:
     ```bash
     scripts/checkpoint.sh instruction-start "instructions/en/presets/web_api_production.md" "REST API development" TASK-123456-abc123
     # Execute work...
     scripts/checkpoint.sh instruction-complete "instructions/en/presets/web_api_production.md" "3 endpoints implemented" TASK-123456-abc123
     ```
   - **Note**: Warnings will be displayed if task ID is omitted
7. **[IMPORTANT] Required steps after instruction selection**:
   1. Select appropriate task instruction (preset or modular generated)
   2. Record start with `instruction-start`
   3. **Always load instruction with Read tool**
   4. Execute work according to loaded instruction content
   5. Record completion with `instruction-complete`

**Note**: This ROOT_INSTRUCTION.md itself is not a "task instruction". Actual work must always be executed according to selected task instructions (presets/ or modular/cache/).

## Available Instructions

### 🎯 Pre-generated Presets (Fast, Top Priority)
**Use these presets with top priority for standard tasks (0-second start):**
- `instructions/ai_instruction_kits/instructions/en/presets/web_api_production.md` - Web API development
- `instructions/ai_instruction_kits/instructions/en/presets/cli_tool_basic.md` - CLI tool development
- `instructions/ai_instruction_kits/instructions/en/presets/data_analyst.md` - Data analysis
- `instructions/ai_instruction_kits/instructions/en/presets/technical_writer.md` - Technical documentation
- `instructions/ai_instruction_kits/instructions/en/presets/academic_researcher.md` - Academic research
- `instructions/ai_instruction_kits/instructions/en/presets/business_consultant.md` - Business consulting
- `instructions/ai_instruction_kits/instructions/en/presets/startup_advisor.md` - Startup support

### 🔥 Modular System (When customization is needed)
- `instructions/ai_instruction_kits/instructions/en/system/MODULE_COMPOSER.md` - **Modular instruction generation**
  - Special requirements not covered by presets
  - Need to combine multiple requirements
  - Need special skill sets

### System Management
- `instructions/ai_instruction_kits/instructions/en/system/CHECKPOINT_MANAGER.md` - Progress management (required)

### Basic Functions
- `instructions/ai_instruction_kits/instructions/en/general/basic_qa.md` - Q&A, information provision
- `instructions/ai_instruction_kits/instructions/en/creative/basic_creative_work.md` - Idea generation

### Legacy Special Functions (Advanced specialized tasks)
- `instructions/ai_instruction_kits/instructions/en/legacy/agent/python_expert.md` - Act as Python development expert
- `instructions/ai_instruction_kits/instructions/en/legacy/agent/code_reviewer.md` - Act as code review expert
- `instructions/ai_instruction_kits/instructions/en/legacy/specialist/marp_specialist.md` - Advanced slide creation with Marp format

## Task Analysis Procedure

1. **Task Type Determination**
   - Analyze user requirements
   - Determine if standard task or special requirements

2. **🎯 Preset Priority Check (Fastest)**
   For standard tasks, **use pre-generated presets immediately**:
   - Web API development → `presets/web_api_production.md`
   - CLI tools → `presets/cli_tool_basic.md`
   - Data analysis → `presets/data_analyst.md`
   - Technical documentation → `presets/technical_writer.md`
   - Academic research → `presets/academic_researcher.md`
   
   → **Use matching preset directly (no generation needed, 0-second start)**

3. **🔥 Modular System Check (When customization needed)**
   For special requirements not covered by presets:
   - Combination of multiple specialties
   - Special skill sets
   - Custom workflows
   
   → **Use MODULE_COMPOSER for dynamic generation**

4. **Legacy/Basic Function Use**
   - Simple Q&A → `general/basic_qa.md`
   - Code review specialist → `legacy/agent/code_reviewer.md`
   - Python expert → `legacy/agent/python_expert.md`
   - Marp slides → `legacy/specialist/marp_specialist.md`

5. **Execution**
   - Presets: Start execution immediately
   - MODULE_COMPOSER: Execute after generation
   - Legacy/Basic: Execute directly

## Examples

### 🎯 Preset Priority Examples (Fastest)
User: "Create a REST API"
→ **Use preset immediately**:
1. Load `instructions/ai_instruction_kits/instructions/en/presets/web_api_production.md`
2. Implement API according to instruction (no generation needed, immediate start)

User: "Build a CLI tool with Python"
→ **Use preset immediately**:
1. Load `instructions/ai_instruction_kits/instructions/en/presets/cli_tool_basic.md`
2. Implement CLI tool according to instruction (no generation needed, immediate start)

### 🔥 Modular System Examples (When customization needed)
User: "Machine learning API with A/B testing"
→ **Use MODULE_COMPOSER for special requirements**:
1. Load `instructions/ai_instruction_kits/instructions/en/system/MODULE_COMPOSER.md`
2. Get metadata and select optimal modules
3. Generate customized instruction with `generate-instruction.sh`
4. **[REQUIRED] Load generated instruction**
5. Implement according to loaded instruction

### Single Instruction Examples (Without modular system)
User: "Review this code"
→ Required instruction:
1. `instructions/ai_instruction_kits/instructions/en/legacy/agent/code_reviewer.md`

User: "Answer this question"
→ Required instruction:
1. `instructions/ai_instruction_kits/instructions/en/general/basic_qa.md`

---
## License Information
- **License**: Apache-2.0
- **Source**: 
- **Original Author**: dobachi
- **Created Date**: 2025-06-30
- **Updated Date**: 2025-07-27