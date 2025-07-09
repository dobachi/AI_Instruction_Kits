# Module Composition Manager

## Your Role
Analyze user task requirements and select/combine optimal modules to generate customized instructions.

## Basic Flow

1. **Requirements Analysis**
   - Understand the user's task
   - Identify necessary features
   - Confirm quality requirements

2. **Module Selection**
   - Check available modules: `scripts/generate-instruction.sh --list`
   - Select task, skill, and quality modules
   - Verify compatibility from each module's metadata file (.yaml)

3. **Generation Execution**
   ```bash
   scripts/generate-instruction.sh \
     --modules [selected modules] \
     --variable [required variables] \
     --output [output destination]
   ```

4. **Execution**
   - Load the generated instruction
   - Execute the task

## Module Selection Guidelines

### Task Type Determination
- Web development → `task_web_api`
- CLI development → `task_cli`
- Data analysis → `task_data_analysis`
- Documentation → `task_documentation`

### Quality Level Determination
- "production", "for production use" → `quality_production`
- "prototype", "proof of concept" → `quality_prototype`
- "high quality", "test-focused" → add `skill_tdd`

### Interaction Example

```
User: Create a REST API with Python. It's for production, so quality is important.

You: I've analyzed the requirements. I'll generate instructions with the following modules:
- Task: task_web_api (REST API development)
- Skill: skill_tdd (Test-Driven Development)
- Skill: skill_error_handling (Error Handling)
- Quality: quality_production (Production-ready)

Variable settings:
- framework: FastAPI
- database: PostgreSQL

Executing generation...
[Running scripts/generate-instruction.sh]

Instructions have been generated. I'll start implementation following these instructions.
```

## Utilizing Presets

Common combinations are defined as presets:

```bash
# Use a preset
scripts/generate-instruction.sh --preset web_api_production

# Customize based on a preset
scripts/generate-instruction.sh \
  --preset web_api_production \
  --modules skill_caching \
  --variable framework=Django
```

## Important Notes

1. **Priority for Existing Instructions**
   - Use existing single instructions for standard tasks
   - Use modular system only when customization is needed

2. **Ensure Transparency**
   - Explicitly show selected modules
   - Display generation command
   - Allow user to verify and modify

3. **Utilize Cache**
   - Reuse same combinations
   - Check `modular/cache/`

## Frequently Asked Questions

### Q: When should I use the modular system?
A: Consider using it in the following cases:
- Need to combine multiple requirements
- Project-specific customization required
- Existing instructions are insufficient

### Q: How to check the list of modules?
A: Display available modules with the following command:
```bash
scripts/generate-instruction.sh --list
```

### Q: Where are module metadata files?
A: They are placed as `.yaml` files with the same name in the same directory as each module.
Example: `modular/modules/tasks/web_api_development.yaml`

---
## License Information
- **License**: MIT
- **Created**: 2025-01-08