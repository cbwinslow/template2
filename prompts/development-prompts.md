# Development Workflow Prompts

## Feature Development Prompt
```
Help me implement a new feature with the following requirements:
[FEATURE_DESCRIPTION]

Please consider:
1. **Architecture**: How should this integrate with existing code?
2. **Database Changes**: What schema changes are needed?
3. **API Design**: What endpoints and data structures are required?
4. **Testing Strategy**: What tests should be written?
5. **Documentation**: What documentation updates are needed?
6. **Security**: What security considerations apply?
7. **Performance**: What performance implications exist?
8. **Deployment**: What deployment considerations exist?

Provide a step-by-step implementation plan with code examples.
```

## Bug Investigation Prompt
```
I'm investigating a bug with the following symptoms:
[BUG_DESCRIPTION]

Please help me:
1. **Root Cause Analysis**: What could be causing this issue?
2. **Debugging Strategy**: What steps should I take to investigate?
3. **Potential Fixes**: What are possible solutions?
4. **Prevention**: How can we prevent similar issues?
5. **Testing**: How should we test the fix?
6. **Monitoring**: What metrics/logging should we add?

Provide a systematic debugging approach.
```

## Refactoring Prompt
```
I need to refactor this code to improve:
[REFACTORING_GOALS]

Current code:
[CODE_SNIPPET]

Please suggest:
1. **Design Patterns**: What patterns would improve this code?
2. **Code Organization**: How should the code be restructured?
3. **Performance**: What performance improvements are possible?
4. **Maintainability**: How can we make this more maintainable?
5. **Testing**: How should we ensure refactoring doesn't break functionality?
6. **Migration Strategy**: How should we safely deploy these changes?

Provide refactored code with explanations.
```

## Documentation Generation Prompt
```
Generate comprehensive documentation for this code:
[CODE_SNIPPET]

Include:
1. **Overview**: What does this code do?
2. **Usage Examples**: How should developers use this?
3. **Parameters**: What parameters does it accept?
4. **Return Values**: What does it return?
5. **Exceptions**: What errors might it throw?
6. **Dependencies**: What does it depend on?
7. **Side Effects**: What side effects does it have?
8. **Performance Notes**: Any performance considerations?

Format as markdown with proper code blocks and examples.
```

## Code Generation Prompt
```
Generate production-ready code for:
[FUNCTIONALITY_DESCRIPTION]

Requirements:
- Language: [LANGUAGE]
- Framework: [FRAMEWORK]
- Pattern: [DESIGN_PATTERN]
- Testing: Include comprehensive tests
- Documentation: Include inline documentation
- Error Handling: Robust error handling
- Security: Follow security best practices
- Performance: Optimize for performance
- Maintainability: Clean, readable code

Provide complete implementation with tests and documentation.
```