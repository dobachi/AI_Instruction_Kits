## API Design

### RESTful API Design Principles

1. **Resource-based URL Design**
   - Use nouns, express verbs with HTTP methods
   - Clear hierarchy: `/resources/{id}/sub-resources`
   - Use plurals for collections

2. **Proper Use of HTTP Methods**
   - GET: Retrieve resources
   - POST: Create new resources
   - PUT/PATCH: Update resources
   - DELETE: Delete resources

3. **Correct Use of Status Codes**
   - 200 OK: Success
   - 201 Created: Resource creation success
   - 400 Bad Request: Client error
   - 401 Unauthorized: Authentication required
   - 404 Not Found: Resource not found
   - 500 Internal Server Error: Server error

### API Documentation

{{#if api_documentation_format}}Format: {{api_documentation_format}}{{/if}}

For each endpoint:
- Purpose and overview
- Request/response schemas
- Parameter descriptions
- Usage examples
- Error responses

### Versioning

{{#if api_versioning_strategy}}
Strategy: {{api_versioning_strategy}}
{{else}}
- Include version in URL path: `/api/v1/resources`
- Maintain backward compatibility between versions
- Gradual deprecation of legacy APIs
{{/if}}

### Performance Optimization

- Implement pagination
- Support field filtering
- Proper cache header configuration
- Implement rate limiting