## API Design

### RESTful Principles

1. **Resource URLs**: Use nouns, plurals for collections
2. **HTTP Methods**: GET (read), POST (create), PUT/PATCH (update), DELETE
3. **Status Codes**: 200 OK, 201 Created, 400 Bad Request, 401 Unauthorized, 404 Not Found

### Documentation

{{#if api_documentation_format}}Format: {{api_documentation_format}}{{/if}}

For each endpoint:
- Purpose and schemas
- Parameters and examples
- Error responses

### Versioning

{{#if api_versioning_strategy}}
Strategy: {{api_versioning_strategy}}
{{else}}
- URL path: `/api/v1/resources`
- Maintain compatibility
{{/if}}

### Performance

- Pagination
- Field filtering
- Cache headers
- Rate limiting
