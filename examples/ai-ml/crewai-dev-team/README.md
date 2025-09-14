# CrewAI Development Team

A comprehensive AI-powered development team using CrewAI that provides automated codebase analysis, review, documentation, and development suggestions.

## Features

### 🤖 AI Agents
- **Code Reviewer**: Senior-level code quality, security, and performance analysis
- **Architecture Advisor**: System design and architectural pattern recommendations  
- **Documentation Specialist**: Automated documentation generation and improvement
- **DevOps Engineer**: CI/CD optimization and infrastructure recommendations
- **Security Specialist**: Security vulnerability assessment and compliance checking

### 🛠️ Capabilities
- Comprehensive codebase analysis across multiple programming languages
- Architecture review and design pattern recommendations
- Automated documentation generation
- Security vulnerability identification
- DevOps workflow optimization
- Performance improvement suggestions
- Best practices enforcement

## Quick Start

### Prerequisites
- Python 3.8+
- OpenAI API key
- GitHub token (optional, for enhanced search capabilities)

### Installation

1. **Install dependencies:**
```bash
pip install -r requirements.txt
```

2. **Configure environment:**
```bash
cp .env.example .env
# Edit .env with your API keys
```

3. **Run analysis:**
```bash
python crew.py --path /path/to/your/project
```

## Configuration

### Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
# Required
OPENAI_API_KEY=your-openai-api-key-here

# Optional
GITHUB_TOKEN=your-github-token-here
PROJECT_PATH=.
REPORTS_DIR=./reports
```

### Agent Customization

Each agent can be customized by modifying their configuration in `crew.py`:

```python
# Example: Adjust code reviewer focus
self.code_reviewer = Agent(
    role="Senior Code Reviewer",
    goal="Focus on security and performance",
    # ... other configurations
)
```

## Usage Examples

### Basic Analysis
```bash
python crew.py
```

### Analyze Specific Project
```bash
python crew.py --path /path/to/project
```

### Custom Configuration
```bash
python crew.py --config custom_config.yaml
```

## Output Reports

The crew generates comprehensive reports in the `./reports/` directory:

- `analysis_report_YYYYMMDD_HHMMSS.md` - Main analysis report
- Individual agent reports for detailed findings
- JSON format for programmatic access

### Sample Report Structure

```markdown
# AI Development Team Analysis Report

## Code Review Findings
- Code quality assessment
- Security vulnerabilities
- Performance recommendations
- Best practices violations

## Architecture Analysis
- System design evaluation
- Design pattern recommendations
- Scalability considerations
- Technical debt identification

## Documentation Improvements
- Missing documentation
- API documentation generation
- README enhancements
- Code comment suggestions

## DevOps Optimization
- CI/CD pipeline improvements
- Workflow optimizations
- Deployment strategy recommendations
- Monitoring and observability

## Security Assessment
- Vulnerability findings
- Security best practices
- Compliance recommendations
- Risk mitigation strategies
```

## Integration with GitHub Actions

Create a workflow to run the crew automatically on code changes:

```yaml
name: AI Code Review
on:
  pull_request:
    branches: [ main ]

jobs:
  ai-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install -r examples/ai-ml/crewai-dev-team/requirements.txt
      
      - name: Run AI Development Team
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          cd examples/ai-ml/crewai-dev-team
          python crew.py --path ../../../
      
      - name: Upload Reports
        uses: actions/upload-artifact@v4
        with:
          name: ai-analysis-reports
          path: reports/
```

## Advanced Features

### Custom Agent Development

Create specialized agents for specific needs:

```python
# Example: Database optimization agent
self.db_optimizer = Agent(
    role="Database Performance Specialist",
    goal="Optimize database queries and schema design",
    backstory="Expert in database performance tuning...",
    tools=[file_read_tool, code_docs_search_tool],
    llm=llm
)
```

### Integration with External Tools

Connect with your existing development tools:

```python
# Example: Jira integration for issue tracking
from crewai_tools import JiraSearchTool
jira_tool = JiraSearchTool(
    url="your-jira-instance.com",
    username="username",
    api_token="token"
)
```

## Performance Optimization

### Resource Management
- Configure agent memory limits
- Set execution timeouts
- Optimize tool usage

### Parallel Execution
```python
# Enable parallel processing for independent tasks
self.crew = Crew(
    agents=agents,
    tasks=tasks,
    process=Process.parallel,  # Changed from sequential
    max_concurrent_tasks=3
)
```

## Troubleshooting

### Common Issues

1. **API Rate Limits**
   - Configure retry logic
   - Use appropriate model selection
   - Implement request throttling

2. **Memory Usage**
   - Limit context window size
   - Process large codebases in chunks
   - Clear agent memory between runs

3. **Token Limits**
   - Split large files into smaller chunks
   - Use summarization for large contexts
   - Optimize prompt engineering

### Debug Mode

Enable verbose logging for troubleshooting:

```bash
python crew.py --path . --verbose
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your improvements
4. Submit a pull request

### Development Setup

```bash
# Install development dependencies
pip install -r requirements-dev.txt

# Run tests
pytest tests/

# Format code
black crew.py

# Type checking
mypy crew.py
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [CrewAI](https://github.com/joaomdmoura/crewAI) for the multi-agent framework
- [LangChain](https://langchain.com/) for LLM integration
- [OpenAI](https://openai.com/) for the language models

## Support

For issues and questions:
- Create an issue in the repository
- Check the [CrewAI documentation](https://docs.crewai.com/)
- Review the [LangChain documentation](https://python.langchain.com/)