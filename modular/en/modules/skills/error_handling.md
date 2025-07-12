# Error Handling Skill Module

## Error Handling Implementation

### Basic Principles

1. **Early Detection**
   - Input validation
   - Precondition checking
   - Type safety assurance

2. **Appropriate Processing**
   - Error classification
   - Recoverability assessment
   - Appropriate actions

3. **Clear Notification**
   - Clear error messages
   - Context information provision
   - Logging

### Implementation Patterns

{{error_handling_pattern}}

### Error Messages

- **Structure**: {{error_message_format}}
- **Content**: Problem description, cause, solution
{{#if error_message_tone}}
- **Tone**: {{error_message_tone}}
{{/if}}

{{#if logging_requirements}}
### Logging

{{logging_requirements}}
{{/if}}

## Best Practices

1. Don't suppress errors
2. Preserve stack traces
3. User-friendly messages
4. Proper debug information management