# Preset Customization Feature Design Document

## 1. Current Implementation Analysis

### 1.1 Core Components

#### ModuleComposer Class
- **Purpose**: Manages module loading, preset handling, and instruction composition
- **Key Methods**:
  - `load_module()`: Loads individual module content and metadata
  - `load_preset()`: Loads preset configuration from YAML files
  - `compose_modules()`: Combines multiple modules with variable substitution
  - `generate_from_preset()`: Generates instructions from preset definitions

### 1.2 Preset Structure

The system supports three preset formats:

1. **Legacy Format** (modules array):
```yaml
modules: ["core_role_definition", "task_code_generation"]
variables:
  role_description: "Developer"
```

2. **Blueprint Format** (new v2.0):
```yaml
blueprint:
  core: ["core_role_definition"]
  tasks: ["task_code_generation"]
capabilities:
  expertise: ["academic_writing"]
variables:
  domain: "computer_science"
```

3. **Category Array Format** (deprecated):
```yaml
expertise: ["academic_writing"]
roles: ["reviewer"]
```

### 1.3 Current Limitations

1. **Mutual Exclusion**: The CLI enforces that either `--preset` or `--modules` can be used, but not both (lines 163-167 in generate-instruction.sh)
2. **No Module Merging**: Presets define a fixed set of modules with no ability to extend
3. **Variable Override Only**: Only variables can be customized when using presets, not the module composition

### 1.4 Data Flow

1. CLI parses arguments → 2. Calls composer.py → 3. Loads preset OR modules → 4. Applies variables → 5. Generates instruction

## 2. Proposed Design

### 2.1 Design Goals

1. **Flexibility**: Allow users to extend presets with additional modules
2. **Backward Compatibility**: Existing preset usage remains unchanged
3. **Clear Priority**: Establish clear precedence rules for conflicting settings
4. **Maintainability**: Minimize code complexity and duplication

### 2.2 Priority Hierarchy

```
Base Preset Settings
    ↓ (overridden by)
Additional Modules
    ↓ (overridden by)
Variable Overrides
```

### 2.3 Module Merging Strategy

When combining preset modules with additional modules:

1. **Deduplication**: If a module appears in both preset and additional list, use only one instance
2. **Ordering**: 
   - Preset modules first (maintain intended structure)
   - Additional modules appended after
3. **Variable Merging**:
   - Collect variables from all modules
   - Apply preset defaults first
   - Apply additional module defaults
   - Apply user overrides last

## 3. Implementation Details

### 3.1 Data Structure Changes

#### New Method Parameters

```python
def generate_from_preset_with_modules(
    self, 
    preset_name: str, 
    additional_modules: List[str] = None,
    overrides: Dict[str, str] = None
) -> str:
    """Generate instruction from preset with optional additional modules"""
```

#### Enhanced Preset Data Structure

No changes needed to preset YAML structure. The enhancement is in how presets are processed.

### 3.2 New Methods/Functions

#### 3.2.1 `merge_modules()`

```python
def merge_modules(self, base_modules: List[str], additional_modules: List[str]) -> List[str]:
    """
    Merge base modules with additional modules, handling deduplication
    
    Args:
        base_modules: Modules from preset
        additional_modules: User-specified additional modules
        
    Returns:
        Merged list of unique module IDs preserving order
    """
    # Use dict to preserve order while deduplicating
    seen = {}
    result = []
    
    # Add base modules first
    for module in base_modules:
        if module not in seen:
            seen[module] = True
            result.append(module)
    
    # Add additional modules
    for module in additional_modules:
        if module not in seen:
            seen[module] = True
            result.append(module)
    
    return result
```

#### 3.2.2 `generate_from_preset_with_modules()`

```python
def generate_from_preset_with_modules(
    self, 
    preset_name: str, 
    additional_modules: List[str] = None,
    overrides: Dict[str, str] = None
) -> str:
    """
    Generate instruction from preset with optional additional modules
    
    Priority: preset < additional modules < variable overrides
    """
    preset = self.load_preset(preset_name)
    
    # Initialize variables with preset defaults
    variables = preset.get('variables', {})
    if 'defaults' in preset:
        variables = {**preset['defaults'], **variables}
    
    # Handle blueprint format presets
    if 'blueprint' in preset or 'capabilities' in preset:
        return self._generate_from_blueprint_preset_with_modules(
            preset, additional_modules, variables, overrides
        )
    
    # Handle legacy module array format
    if 'modules' in preset:
        base_modules = preset['modules']
        if additional_modules:
            merged_modules = self.merge_modules(base_modules, additional_modules)
        else:
            merged_modules = base_modules
        
        # Apply variable overrides last
        if overrides:
            variables = {**variables, **overrides}
            
        return self.compose_modules(merged_modules, variables)
    
    # Handle category array format (deprecated)
    module_ids = self._extract_modules_from_categories(preset)
    if module_ids:
        if additional_modules:
            merged_modules = self.merge_modules(module_ids, additional_modules)
        else:
            merged_modules = module_ids
            
        if overrides:
            variables = {**variables, **overrides}
            
        return self.compose_modules(merged_modules, variables)
    
    raise ValueError(f"Invalid preset format: {preset_name}")
```

#### 3.2.3 `_generate_from_blueprint_preset_with_modules()`

```python
def _generate_from_blueprint_preset_with_modules(
    self,
    preset: Dict[str, Any],
    additional_modules: List[str],
    variables: Dict[str, str],
    overrides: Dict[str, str]
) -> str:
    """Generate from blueprint preset with additional modules support"""
    sections = []
    
    # Header with enhanced info
    if self.lang == 'ja':
        sections.append("# AI指示書")
        sections.append("*この指示書はモジュラーシステム v2.0 によって自動生成されました*\n")
    else:
        sections.append("# AI Instructions")
        sections.append("*This instruction was automatically generated by modular system v2.0*\n")
    
    # Show preset info
    if 'name' in preset:
        if self.lang == 'ja':
            sections.append(f"**プリセット**: {preset['name']}")
        else:
            sections.append(f"**Preset**: {preset['name']}")
    
    # Show if additional modules were added
    if additional_modules:
        if self.lang == 'ja':
            sections.append(f"**追加モジュール**: {', '.join(additional_modules)}")
        else:
            sections.append(f"**Additional Modules**: {', '.join(additional_modules)}")
    
    # ... rest of the implementation similar to _generate_from_blueprint_preset
    # but with additional module handling in capabilities section
```

### 3.3 CLI Changes

#### Modify generate-instruction.sh

Remove the mutual exclusion check (lines 163-167) and update argument handling:

```bash
# Remove this block:
# if [[ ${#MODULES[@]} -gt 0 ]] && [[ -n "$PRESET" ]]; then
#     MSG_ERROR_BOTH_SPECIFIED=...
#     echo "$MSG_ERROR_BOTH_SPECIFIED"
#     exit 1
# fi

# Update Python call logic:
if [[ -n "$PRESET" ]]; then
    # Preset with optional modules
    ARGS=("--lang" "$LANG")
    [[ -n "$VERBOSE_FLAG" ]] && ARGS+=($VERBOSE_FLAG)
    ARGS+=("preset" "$PRESET")
    
    # Add modules if specified
    if [[ ${#MODULES[@]} -gt 0 ]]; then
        ARGS+=("--modules")
        for module in "${MODULES[@]}"; do
            ARGS+=("$module")
        done
    fi
    
    [[ -n "$OUTPUT_FILE" ]] && ARGS+=("-o" "$OUTPUT_FILE")
    for var in "${VARIABLES[@]}"; do
        ARGS+=("-v" "$var")
    done
    python3 "$COMPOSER_PY" "${ARGS[@]}"
```

#### Update composer.py main()

Modify the preset subcommand parser to accept optional modules:

```python
# In main() function, update preset parser
preset_parser = subparsers.add_parser('preset', help='プリセットから生成')
preset_parser.add_argument('name', help='プリセット名')
preset_parser.add_argument('-o', '--output', help='出力ファイル名')
preset_parser.add_argument('-v', '--variable', action='append', 
                          help='変数のオーバーライド (key=value形式)')
preset_parser.add_argument('--modules', nargs='+', 
                          help='プリセットに追加するモジュール')

# Update preset command handling
if args.command == 'preset':
    # Parse variables
    overrides = {}
    if args.variable:
        for var in args.variable:
            key, value = var.split('=', 1)
            overrides[key] = value
    
    # Generate with optional additional modules
    if hasattr(args, 'modules') and args.modules:
        content = composer.generate_from_preset_with_modules(
            args.name, args.modules, overrides
        )
    else:
        content = composer.generate_from_preset(args.name, overrides)
```

### 3.4 Error Handling

1. **Invalid Module IDs**: 
   - Continue with warning when additional module not found
   - Fail if core preset modules are missing

2. **Variable Conflicts**:
   - Log when variables are overridden
   - Show source of each variable in output

3. **Circular Dependencies**:
   - Detect and prevent infinite loops in module loading
   - Maintain a loading stack to track recursion

### 3.5 Backward Compatibility

1. **No Breaking Changes**:
   - Existing preset usage without `--modules` works identically
   - All current preset formats remain supported
   
2. **Default Behavior**:
   - When `--preset` used alone: current behavior
   - When `--preset` + `--modules`: new merge behavior

3. **Migration Path**:
   - No migration needed for existing presets
   - Documentation update to explain new capability

## 4. Usage Examples

### Basic Preset Usage (unchanged)
```bash
./scripts/generate-instruction.sh --preset web_api_production --output api.md
```

### Enhanced Preset with Additional Modules
```bash
./scripts/generate-instruction.sh \
  --preset web_api_production \
  --modules skill_testing skill_deployment \
  --variable framework=FastAPI \
  --output enhanced_api.md
```

### Blueprint Preset with Extensions
```bash
./scripts/generate-instruction.sh \
  --preset academic_researcher \
  --modules skill_data_visualization quality_advanced \
  --variable domain=biology \
  --variable citation_style=Nature
```

## 5. Testing Strategy

### 5.1 Unit Tests

1. **Module Merging**:
   - Test deduplication logic
   - Test order preservation
   - Test empty/null cases

2. **Variable Priority**:
   - Test preset defaults < module defaults < user overrides
   - Test variable conflict resolution

### 5.2 Integration Tests

1. **Legacy Format Compatibility**:
   - Test all existing preset formats work unchanged
   - Test new functionality with legacy formats

2. **Blueprint Format Enhancement**:
   - Test capability merging
   - Test blueprint variable substitution with additions

### 5.3 End-to-End Tests

1. **CLI Integration**:
   - Test various command-line combinations
   - Test error messages and help text

2. **Output Validation**:
   - Verify generated instructions include all expected modules
   - Verify variable substitution correctness

## 6. Performance Considerations

1. **Module Loading**:
   - Cache loaded modules to avoid duplicate file reads
   - Lazy load module content only when needed

2. **Memory Usage**:
   - Stream large files instead of loading entirely
   - Clear module cache after generation

## 7. Future Enhancements

1. **Module Compatibility Matrix**:
   - Define which modules work well together
   - Warn about incompatible combinations

2. **Preset Inheritance**:
   - Allow presets to extend other presets
   - Create preset hierarchies

3. **Interactive Mode**:
   - CLI wizard for selecting modules
   - Preview before generation

## 8. Implementation Timeline

1. **Phase 1**: Core implementation (2-3 days)
   - Implement merge_modules()
   - Implement generate_from_preset_with_modules()
   - Update CLI argument handling

2. **Phase 2**: Testing and refinement (1-2 days)
   - Write comprehensive tests
   - Handle edge cases
   - Performance optimization

3. **Phase 3**: Documentation and rollout (1 day)
   - Update user documentation
   - Create migration guide
   - Update examples