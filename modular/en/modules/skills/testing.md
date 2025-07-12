## Testing

### Basic Policy
- {{#if test_approach}}{{test_approach}}{{/if}}
- {{#if test_framework}}Framework: {{test_framework}}{{/if}}
- Coverage target: {{test_coverage_target}}

### Testing Strategy
1. **Unit Testing**
   - Independent testing of each function/method
   - Cover edge cases and error conditions
   - Isolate dependencies using mocks

2. **Integration Testing**
   - Verify component interactions
   - Test actual data flows
   - End-to-end scenario validation

3. **Performance Testing**
   {{#if response_time_target}}- Response time target: {{response_time_target}}{{/if}}
   {{#if throughput_target}}- Throughput target: {{throughput_target}}{{/if}}

### Testing Best Practices
- Write tests in readable and maintainable code
- Each test should be executable independently
- Use clear and predictable values for test data
- Include detailed information in error messages to help identify problems