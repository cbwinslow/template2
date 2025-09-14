# Contributing to Template2

Thank you for your interest in contributing to Template2! This document provides guidelines and information for contributors.

## 🎯 How to Contribute

### Reporting Issues
- Use the issue templates provided
- Search existing issues before creating new ones
- Provide clear reproduction steps
- Include system information and logs

### Suggesting Features
- Use the feature request template
- Describe the use case and benefits
- Consider implementation complexity
- Discuss alternatives considered

### Code Contributions
1. Fork the repository
2. Create a feature branch from `main`
3. Make your changes following our coding standards
4. Add tests for new functionality
5. Update documentation as needed
6. Submit a pull request

## 🏗️ Development Setup

### Prerequisites
- Git 2.0+
- Docker and Docker Compose
- Node.js 18+ (for Node.js examples)
- Python 3.9+ (for Python examples)
- Go 1.20+ (for Go examples)

### Local Development
1. Clone your fork
2. Run `docker-compose up -d` for full stack
3. Or run individual services as needed
4. Use GitHub Codespaces for instant setup

### Running Tests
```bash
# Python
cd examples/python && poetry run pytest

# Node.js
cd examples/nodejs && npm test

# Go
cd examples/go && go test ./...

# All services with Docker
docker-compose run --rm python-api pytest
```

## 📝 Coding Standards

### General Guidelines
- Follow language-specific conventions
- Write clear, self-documenting code
- Include appropriate error handling
- Add tests for new functionality
- Update documentation for public APIs

### Python
- Use Black for formatting
- Follow PEP 8 guidelines
- Use type hints
- Write docstrings for functions/classes
- Prefer async/await for I/O operations

### TypeScript/JavaScript
- Use Prettier for formatting
- Follow ESLint rules
- Use TypeScript for new code
- Write JSDoc for public APIs
- Prefer functional programming patterns

### Go
- Use gofmt and goimports
- Follow standard Go conventions
- Handle errors explicitly
- Write table-driven tests
- Use interfaces appropriately

## 🧪 Testing Guidelines

### Test Requirements
- All new code must have tests
- Maintain or improve coverage
- Test edge cases and error conditions
- Use appropriate test doubles/mocks
- Write integration tests for APIs

### Test Organization
- Unit tests alongside source code
- Integration tests in `tests/` directory
- E2E tests for critical workflows
- Performance tests for optimizations

## 📚 Documentation

### Documentation Standards
- Update README for significant changes
- Document public APIs and interfaces
- Include code examples in documentation
- Keep examples current and tested
- Write clear commit messages

### API Documentation
- Use OpenAPI/Swagger for REST APIs
- Include request/response examples
- Document error conditions
- Provide usage examples
- Version API documentation

## 🔄 Pull Request Process

### PR Requirements
- Fill out the PR template completely
- Reference related issues
- Include tests for changes
- Update documentation
- Ensure CI passes

### Review Process
1. Automated checks must pass
2. At least one code review required
3. Address all review feedback
4. Maintain up-to-date branch
5. Squash commits if requested

### Merge Criteria
- All tests passing
- Code review approved
- Documentation updated
- No merge conflicts
- Meets coding standards

## 🏷️ Labeling and Issues

### Issue Labels
- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Improvements to docs
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed

### Priority Labels
- `priority: critical` - Critical issues
- `priority: high` - High priority
- `priority: medium` - Medium priority
- `priority: low` - Low priority

## 🚀 Release Process

### Versioning
- We use Semantic Versioning (SemVer)
- Breaking changes increment major version
- New features increment minor version
- Bug fixes increment patch version

### Release Workflow
1. Changes merged to `main`
2. Automated tests pass
3. Release created automatically
4. Changelog generated
5. Documentation updated

## 🤖 AI and Automation

### GitHub Copilot Usage
- Use Copilot for code generation
- Review all generated code
- Ensure generated code follows standards
- Add appropriate tests and documentation

### Automated Tools
- Pre-commit hooks for code quality
- Automated dependency updates
- Security scanning on all PRs
- Performance regression detection

## 🔒 Security

### Security Guidelines
- Never commit secrets or credentials
- Use environment variables for config
- Follow security best practices
- Report security issues privately
- Keep dependencies updated

### Reporting Security Issues
- Email security issues privately
- Don't create public issues for vulnerabilities
- Provide detailed reproduction steps
- Allow time for fixes before disclosure

## 📞 Getting Help

### Communication Channels
- GitHub Issues for bugs and features
- GitHub Discussions for questions
- Discord for real-time chat
- Email for private matters

### Community Guidelines
- Be respectful and inclusive
- Help others learn and grow
- Share knowledge and experience
- Follow our Code of Conduct

Thank you for contributing to Template2! 🙏