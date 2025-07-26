## Authentication & Authorization

### Authentication Methods

{{#if auth_method}}**Selected**: {{auth_method}}{{/if}}

1. **JWT**: Stateless, token expiration, refresh tokens
2. **OAuth 2.0**: Third-party auth, scopes, auth code flow
3. **API Key**: Simple, key rotation, rate limiting

### Security Practices

**Password Policy**
- Min length: {{password_min_length}}
- Complexity: uppercase, lowercase, numbers, special chars

**Session Management**
- Timeout: {{session_timeout}}
- Secure cookies: HttpOnly, Secure, SameSite
- CSRF protection

**Access Control**
- Role-based permissions
- Least privilege
- Audit logging

### Protection

- Password hashing (bcrypt/Argon2)
- Data encryption
- HTTPS required
- Brute force protection
