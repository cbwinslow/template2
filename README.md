# 🚀 Template2 - Comprehensive GitHub Features Showcase

[![CI Pipeline](https://github.com/cbwinslow/template2/actions/workflows/ci-multi-language.yml/badge.svg)](https://github.com/cbwinslow/template2/actions)
[![Security Scan](https://github.com/cbwinslow/template2/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/cbwinslow/template2/actions)
[![Deploy Pages](https://github.com/cbwinslow/template2/actions/workflows/deploy-pages.yml/badge.svg)](https://github.com/cbwinslow/template2/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive template repository showcasing modern development practices, GitHub features, CI/CD pipelines, containerization, AI integration, and multi-language support. This repository serves as a reference implementation and starting point for new projects.

## ✨ Features

### 🔄 CI/CD & Automation
- **Multi-language CI pipelines** with GitHub Actions
- **Automated testing** across Python, Node.js, Go, Java, and .NET
- **Security scanning** with CodeQL and dependency review
- **Automated deployment** to GitHub Pages
- **Release automation** with changelog generation
- **Dependency updates** with Dependabot

### 🏗️ Development Environment
- **GitHub Codespaces** with devcontainer configuration
- **Multi-language support** with proper tooling
- **Docker** containerization with multi-stage builds
- **Docker Compose** for full-stack development
- **Pre-commit hooks** for code quality
- **EditorConfig** for consistent coding styles

### 🌐 Language Examples
- **Python** - FastAPI with async support, SQLAlchemy, Pydantic
- **Node.js/TypeScript** - Express with modern tooling, Zod validation
- **Go** - Gin framework with structured logging, middleware
- **Java** - Spring Boot with Maven/Gradle examples
- **C#/.NET** - ASP.NET Core with Entity Framework

### 🤖 AI & Automation
- **GitHub Copilot** configuration and prompts
- **AI-powered code review** templates
- **Automated issue labeling** and triage
- **Smart PR descriptions** and commit messages
- **Code quality analysis** with AI suggestions

### 🔒 Security & Best Practices
- **Security scanning** with multiple tools
- **Dependency vulnerability** monitoring
- **Secrets management** examples
- **Authentication** and authorization patterns
- **HTTPS/TLS** configuration
- **Rate limiting** and abuse prevention

### 📊 Monitoring & Observability
- **Prometheus** metrics collection
- **Grafana** dashboards
- **Structured logging** across all services
- **Health checks** and readiness probes
- **Performance monitoring** examples

## 🚀 Quick Start

### Prerequisites
- **Git** 2.0+
- **Docker** 20.0+ and Docker Compose
- **Node.js** 18+ (for Node.js examples)
- **Python** 3.9+ (for Python examples)
- **Go** 1.20+ (for Go examples)

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/cbwinslow/template2.git
   cd template2
   ```

2. **Start with Docker Compose**
   ```bash
   docker-compose up -d
   ```

3. **Access the services**
   - Python API: http://localhost:8000
   - Node.js API: http://localhost:3000
   - Go API: http://localhost:8080
   - Grafana: http://localhost:3001
   - Prometheus: http://localhost:9090

4. **GitHub Codespaces** (Recommended)
   - Click "Code" → "Create codespace on main"
   - Everything is pre-configured and ready to use

### Running Individual Examples

#### Python Example
```bash
cd examples/python
poetry install
poetry run uvicorn src.main:app --reload
```

#### Node.js Example
```bash
cd examples/nodejs
npm install
npm run dev
```

#### Go Example
```bash
cd examples/go
go mod download
go run cmd/main.go
```

## 📁 Repository Structure

```
template2/
├── .github/                    # GitHub configuration
│   ├── workflows/             # CI/CD pipelines
│   ├── ISSUE_TEMPLATE/        # Issue templates
│   └── PULL_REQUEST_TEMPLATE/ # PR templates
├── .devcontainer/             # Codespaces configuration
├── examples/                  # Language-specific examples
│   ├── python/               # FastAPI example
│   ├── nodejs/               # Express.js example
│   ├── go/                   # Gin example
│   ├── java/                 # Spring Boot example
│   └── dotnet/               # ASP.NET Core example
├── ai-configs/               # AI tool configurations
├── prompts/                  # AI prompt templates
├── docker/                   # Docker configurations
├── docs/                     # Documentation
└── scripts/                  # Utility scripts
```

## 🛠️ GitHub Actions Workflows

### Available Workflows

1. **Multi-Language CI** - Tests and builds all language examples
2. **Security Analysis** - CodeQL and dependency scanning
3. **Deploy Pages** - Builds and deploys documentation
4. **Dependency Review** - Reviews dependency changes in PRs
5. **Auto-merge** - Automatically merges dependabot PRs
6. **Release** - Creates releases and changelogs

### Workflow Features

- **Path-based triggering** - Only runs relevant tests
- **Matrix builds** - Tests multiple versions of each language
- **Caching** - Optimized build times with dependency caching
- **Parallel execution** - Runs tests concurrently
- **Security scanning** - Integrated security analysis
- **Deployment** - Automated deployment to multiple environments

## 🏗️ Architecture Patterns

### Microservices Architecture
- Independent service deployment
- API gateway with Nginx
- Service discovery patterns
- Inter-service communication

### Security Patterns
- JWT authentication
- Rate limiting
- Input validation
- HTTPS enforcement
- Secrets management

### Observability Patterns
- Structured logging
- Metrics collection
- Distributed tracing
- Health checks
- Error tracking

## 🤖 AI Integration

### GitHub Copilot Configuration
- Language-specific settings in `ai-configs/copilot-config.yml`
- Custom prompts for different development scenarios
- Code review templates with AI assistance

### AI-Powered Features
- **Automated code review** with quality suggestions
- **Smart commit messages** based on changes
- **Issue auto-labeling** using AI analysis
- **Documentation generation** from code
- **Test case suggestions** for new features

## 📚 Documentation

### Available Documentation
- **API Documentation** - OpenAPI/Swagger specs for all services
- **Development Guide** - Setup and contribution guidelines
- **Architecture Documentation** - System design and patterns
- **Security Guidelines** - Security best practices
- **Deployment Guide** - Production deployment instructions

### Documentation Features
- **Auto-generated** from code comments
- **Version controlled** with the code
- **Multi-format** (Markdown, OpenAPI, JSDoc)
- **Interactive examples** with code samples

## 🔧 Configuration Management

### Environment Configuration
- **Development** - Local development settings
- **Testing** - CI/CD testing configuration
- **Production** - Production-ready settings
- **Docker** - Containerized environments

### Configuration Features
- **Environment variables** for all settings
- **Secrets management** with secure storage
- **Configuration validation** at startup
- **Hot reloading** for development

## 🚀 Deployment Options

### Supported Platforms
- **GitHub Pages** - Static sites and documentation
- **Docker** - Containerized applications
- **Kubernetes** - Container orchestration
- **Cloud Providers** - AWS, Azure, GCP
- **Serverless** - Functions and edge computing

### Deployment Features
- **Blue-green deployments** for zero downtime
- **Rolling updates** with health checks
- **Rollback capabilities** for quick recovery
- **Multi-environment** support
- **Infrastructure as Code** with Terraform

## 🧪 Testing Strategy

### Testing Levels
- **Unit Tests** - Individual component testing
- **Integration Tests** - Service interaction testing
- **End-to-End Tests** - Full workflow testing
- **Performance Tests** - Load and stress testing
- **Security Tests** - Vulnerability scanning

### Testing Tools
- **Python** - pytest, coverage, bandit
- **Node.js** - Jest, Supertest, Artillery
- **Go** - Standard library, testify, benchmarks
- **Cross-language** - Docker, Newman, k6

## 📊 Monitoring & Metrics

### Metrics Collection
- **Application metrics** - Custom business metrics
- **System metrics** - CPU, memory, disk usage
- **Network metrics** - Request rates, latencies
- **Error metrics** - Error rates, stack traces

### Monitoring Stack
- **Prometheus** - Metrics collection and storage
- **Grafana** - Visualization and alerting
- **AlertManager** - Alert routing and notification
- **Jaeger** - Distributed tracing

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Getting Started
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Update documentation
6. Submit a pull request

### Development Workflow
1. **Issues** - Use issue templates for bugs and features
2. **Branches** - Follow the branching strategy
3. **Commits** - Use conventional commit messages
4. **PRs** - Fill out the PR template completely
5. **Reviews** - Address all review feedback

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **GitHub** for the excellent platform and tools
- **Open Source Community** for the amazing libraries and frameworks
- **Contributors** who help improve this template

## 📞 Support

- **Documentation** - Check the docs/ directory
- **Issues** - Create an issue for bugs or questions
- **Discussions** - Use GitHub Discussions for general questions
- **Community** - Join our Discord server

---

⭐ If you find this repository helpful, please star it and share it with others!