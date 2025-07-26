## Testing

### Policy
- {{#if test_approach}}{{test_approach}}{{/if}}
- {{#if test_framework}}Framework: {{test_framework}}{{/if}}
- Coverage: {{test_coverage_target}}

### Strategy

**Unit Testing**
- Test functions independently
- Cover edge cases
- Mock dependencies

**Integration Testing**
- Verify interactions
- Test data flows
- E2E scenarios

**Performance Testing**
{{#if response_time_target}}- Response: {{response_time_target}}{{/if}}
{{#if throughput_target}}- Throughput: {{throughput_target}}{{/if}}

### Best Practices
- Readable test code
- Independent execution
- Clear test data
- Detailed error messages
