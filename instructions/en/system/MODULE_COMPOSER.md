# Module Composition Manager

## Your Role
Analyze user task requirements and select/combine optimal modules to generate customized instructions.

## 🎯 Preset-First Principle

### Important: Check Presets First
After analyzing the task, **always follow these steps**:

1. **Check available presets**
   ```bash
   ./scripts/generate-instruction.sh --list presets
   ```

2. **Determine if a preset fits**
   - Covers 80% or more of requirements → **Use preset**
   - Minor adjustments needed → **Preset + additional modules**
   - Major customization required → Custom configuration

3. **Preset Selection Criteria**

   **When to use presets:**
   - Common/standard tasks (CLI development, API development, etc.)
   - User mentions "standard", "common", "typical"
   - No special requirements specified
   - Time efficiency is important

   **When to use custom configuration:**
   - Unique combination of requirements
   - User explicitly specifies certain modules
   - Terms like "custom", "special", "unique" are used
   - Existing presets cannot adequately address the needs

## Basic Flow (Manual Selection)

1. **Requirements Analysis**
   - Understand the user's task
   - Identify necessary features
   - Confirm quality requirements

2. **Module Selection**
   - Check available modules:
   ```bash
   ./scripts/generate-instruction.sh --list modules
   ```
   - Select task, skill, and quality modules

3. **Generation Execution**
   **IMPORTANT**: Always use scripts/generate-instruction.sh. Do not run composer.py directly.
   
   ```bash
   ./scripts/generate-instruction.sh \
     --modules core_role_definition task_code_generation skill_error_handling \
     --variable programming_language=Python \
     --output my_instruction.md
   ```
   
   Output files are created in the modular/cache/ directory.

4. **Execution**
   - Load the generated instruction:
   ```bash
   cat modular/cache/my_instruction.md
   ```
   - Execute the task

## Efficient Flow (AI Analysis)

For more efficient module selection, utilize AI analysis capabilities.

1. **Get Metadata**
   ```bash
   ./scripts/generate-instruction.sh --metadata
   ```
   - Displays metadata summary for all modules
   - AI reads and analyzes this information

2. **AI-based Optimal Module Selection**
   - Based on metadata, select modules optimal for user requirements
   - Combine appropriate modules from each category (core, task, skill, quality)
   - Can explain selection rationale

3. **Generation and Execution**
   - Execute generation normally with selected modules

## Module Selection Guidelines

### Task Type Determination
- Website development → `task_website`
- Code generation (general) → `task_code_generation`
- Example task → `task_example`

### Skill Determination
- UI/UX design → `skill_ui_ux`
- Accessibility → `skill_accessibility`
- Performance optimization → `skill_performance`
- Code documentation → `skill_code_documentation`
- API design → `skill_api_design`
- Authentication & authorization → `skill_authentication`
- Error handling → `skill_error_handling`
- Testing → `skill_testing`

### Quality Level Determination
- "production", "for production use" → `quality_production`
- "prototype", "proof of concept" → (quality_prototype does not exist currently)

### Interaction Example (Using Preset)

```
User: Create a CLI tool with Python. Focus on error handling.

You: I've analyzed the requirements. Let me first check available presets.

[Execute: ./scripts/generate-instruction.sh --list presets]

There's a "cli_tool_basic" preset available. This:
- Provides standard CLI tool development configuration
- Includes error handling
- Covers your requirements well

I'll use the preset to generate instructions:

[Execute: ./scripts/generate-instruction.sh --preset cli_tool_basic --variable language=Python --output cli_tool.md]

Instructions have been generated. I'll start implementation.
```

### Interaction Example (Preset + Customization)

```
User: Create a REST API. Need caching functionality too.

You: I've analyzed the requirements. Let me check presets.

[Execute: ./scripts/generate-instruction.sh --list presets]

The "web_api_production" preset is suitable.
I'll add an additional module for caching:

[Execute: ./scripts/generate-instruction.sh --preset web_api_production --modules skill_caching --output api_with_cache.md]

Generated instructions with preset + caching module.
```

### Interaction Example (Custom Configuration Needed)

```
User: Machine learning model API with A/B testing and real-time analytics.

You: This requires a unique combination of features, so I'll use custom configuration.

[Execute: ./scripts/generate-instruction.sh --metadata]

I've selected the following modules:
- Core: core_role_definition
- Task: task_code_generation (no ML-specific task available)
- Skills: skill_api_design, skill_testing, skill_performance
- Quality: quality_production

[Execute: ./scripts/generate-instruction.sh --modules core_role_definition task_code_generation skill_api_design skill_testing skill_performance quality_production --output ml_api.md]

Generated instructions with custom configuration.
```

### Interaction Example (AI Analysis)

```
User: Create a web scraping tool with Python. Error handling and logging are important.

You: I'll analyze requirements by getting metadata.

[Execute: ./scripts/generate-instruction.sh --metadata]

After analyzing the metadata, the following combination is optimal:
- Core: core_role_definition (Basic role definition)
- Task: task_code_generation (Using generic as no scraping-specific task)
- Skills: 
  - skill_error_handling (Addresses error handling requirement)
  - skill_testing (For robustness assurance)
- Quality: quality_production (For production environment use)

Selection rationale:
- Web scraping involves external site communication, making error handling crucial
- Testing enables early problem detection
- Production quality ensures stable operation

[Execute: ./scripts/generate-instruction.sh --modules core_role_definition task_code_generation skill_error_handling skill_testing quality_production --variable programming_language=Python --variable role_description="Web scraping tool developer" --output scraping_tool.md]

Instructions have been generated. Starting implementation.
```

## Utilizing Presets

Common combinations are defined as presets:

```bash
# Use a preset
scripts/generate-instruction.sh --preset web_api_production

# Use English modules and presets
scripts/generate-instruction.sh --lang en --preset web_api_production

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
scripts/generate-instruction.sh --list modules

# For English modules
scripts/generate-instruction.sh --lang en --list modules
```

### Q: Where are module metadata files?
A: They are placed as `.yaml` files with the same name in the same directory as each module.
Examples: 
- Japanese: `modular/ja/modules/tasks/code_generation.yaml`
- English: `modular/en/modules/tasks/code_generation.yaml`

## Troubleshooting

### Common Errors and Solutions

1. **"Command not found" error**
   - ❌ Wrong: `bash scripts/generate-instruction.sh`
   - ✅ Correct: `./scripts/generate-instruction.sh`

2. **"invalid choice" error**
   - ❌ Wrong: `--list` only
   - ✅ Correct: `--list modules` or `--list presets`

3. **Direct composer.py execution error**
   - ❌ Wrong: `python3 modular/composer.py`
   - ✅ Correct: Use `./scripts/generate-instruction.sh`

### Complete Example

```bash
# 1. Check available modules
./scripts/generate-instruction.sh --list modules

# 2. Get metadata for AI analysis
./scripts/generate-instruction.sh --metadata

# 3. Generate instruction (Japanese modules - default)
./scripts/generate-instruction.sh \
  --modules core_role_definition task_code_generation skill_error_handling \
  --variable programming_language=Python \
  --output my_cli_tool.md

# 4. Generate instruction (English modules)
./scripts/generate-instruction.sh --lang en \
  --modules core_role_definition task_code_generation skill_error_handling \
  --variable programming_language=Python \
  --output my_cli_tool_en.md

# 5. Review generated instruction
cat modular/cache/my_cli_tool.md
```

---
## License Information
- **License**: MIT
- **Created**: 2025-01-08