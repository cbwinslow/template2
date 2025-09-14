# Code Review Prompts for AI Assistants

## General Code Review Prompt
```
Please review the following code for:
1. **Code Quality**: Clean code principles, readability, maintainability
2. **Performance**: Potential bottlenecks, optimization opportunities
3. **Security**: Common vulnerabilities, security best practices
4. **Testing**: Test coverage, edge cases, testability
5. **Documentation**: Comments, docstrings, API documentation
6. **Best Practices**: Language-specific conventions, design patterns
7. **Architecture**: Code organization, separation of concerns
8. **Error Handling**: Proper exception handling, graceful failures

Please provide specific suggestions with examples where applicable.
```

## Security Review Prompt
```
Conduct a security review focusing on:
- Input validation and sanitization
- Authentication and authorization
- SQL injection vulnerabilities
- Cross-site scripting (XSS) prevention
- Cross-site request forgery (CSRF) protection
- Sensitive data exposure
- Insecure direct object references
- Security misconfiguration
- Known vulnerable components
- Insufficient logging and monitoring

Flag any security concerns and suggest secure alternatives.
```

## Performance Review Prompt
```
Analyze this code for performance issues:
- Time complexity analysis
- Space complexity considerations
- Database query optimization
- Caching opportunities
- Async/parallel processing potential
- Memory leaks or excessive allocations
- Network request optimization
- Algorithm efficiency improvements

Provide specific optimization recommendations with estimated impact.
```

## API Design Review Prompt
```
Review this API design for:
- RESTful principles compliance
- HTTP status code usage
- Request/response structure consistency
- Error response standardization
- API versioning strategy
- Rate limiting considerations
- Authentication/authorization patterns
- Documentation completeness
- Backward compatibility
- Scalability concerns

Suggest improvements aligned with industry standards.
```

## Testing Strategy Prompt
```
Evaluate the testing approach for:
- Unit test coverage and quality
- Integration test scenarios
- End-to-end test cases
- Edge case handling
- Mock usage appropriateness
- Test data management
- Test organization and structure
- Performance testing needs
- Security testing considerations
- Accessibility testing requirements

Recommend additional tests and testing strategies.
```