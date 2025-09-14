# Template2 Development Makefile
# This Makefile provides convenient commands for development tasks

.PHONY: help install test lint format clean build up down logs status

# Default target
.DEFAULT_GOAL := help

# Colors for output
BLUE := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
NC := \033[0m # No Color

# Help target
help: ## Show this help message
	@echo "$(BLUE)Template2 Development Commands$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2}'

# Installation and setup
install: ## Install all dependencies
	@echo "$(BLUE)Installing dependencies...$(NC)"
	@./scripts/setup.sh

install-python: ## Install Python dependencies
	@echo "$(BLUE)Installing Python dependencies...$(NC)"
	@cd examples/python && poetry install

install-nodejs: ## Install Node.js dependencies
	@echo "$(BLUE)Installing Node.js dependencies...$(NC)"
	@cd examples/nodejs && npm install

install-go: ## Install Go dependencies
	@echo "$(BLUE)Installing Go dependencies...$(NC)"
	@cd examples/go && go mod download

install-java: ## Install Java dependencies
	@echo "$(BLUE)Installing Java dependencies...$(NC)"
	@cd examples/java && mvn dependency:resolve

# Testing
test: ## Run all tests
	@echo "$(BLUE)Running all tests...$(NC)"
	@$(MAKE) test-python
	@$(MAKE) test-nodejs
	@$(MAKE) test-go
	@$(MAKE) test-java

test-python: ## Run Python tests
	@echo "$(BLUE)Running Python tests...$(NC)"
	@cd examples/python && poetry run pytest -v --cov=src --cov-report=term-missing

test-nodejs: ## Run Node.js tests
	@echo "$(BLUE)Running Node.js tests...$(NC)"
	@cd examples/nodejs && npm test

test-go: ## Run Go tests
	@echo "$(BLUE)Running Go tests...$(NC)"
	@cd examples/go && go test -v -race -coverprofile=coverage.out ./...

test-java: ## Run Java tests
	@echo "$(BLUE)Running Java tests...$(NC)"
	@cd examples/java && mvn test

test-integration: ## Run integration tests
	@echo "$(BLUE)Running integration tests...$(NC)"
	@docker-compose up -d
	@sleep 10
	@./scripts/integration-tests.sh || true
	@docker-compose down

# Linting and formatting
lint: ## Lint all code
	@echo "$(BLUE)Linting all code...$(NC)"
	@$(MAKE) lint-python
	@$(MAKE) lint-nodejs
	@$(MAKE) lint-go
	@$(MAKE) lint-java

lint-python: ## Lint Python code
	@echo "$(BLUE)Linting Python code...$(NC)"
	@cd examples/python && poetry run flake8 src tests
	@cd examples/python && poetry run mypy src

lint-nodejs: ## Lint Node.js code
	@echo "$(BLUE)Linting Node.js code...$(NC)"
	@cd examples/nodejs && npm run lint

lint-go: ## Lint Go code
	@echo "$(BLUE)Linting Go code...$(NC)"
	@cd examples/go && golangci-lint run

lint-java: ## Lint Java code
	@echo "$(BLUE)Linting Java code...$(NC)"
	@cd examples/java && mvn checkstyle:check

format: ## Format all code
	@echo "$(BLUE)Formatting all code...$(NC)"
	@$(MAKE) format-python
	@$(MAKE) format-nodejs
	@$(MAKE) format-go
	@$(MAKE) format-java

format-python: ## Format Python code
	@echo "$(BLUE)Formatting Python code...$(NC)"
	@cd examples/python && poetry run black src tests
	@cd examples/python && poetry run isort src tests

format-nodejs: ## Format Node.js code
	@echo "$(BLUE)Formatting Node.js code...$(NC)"
	@cd examples/nodejs && npm run format

format-go: ## Format Go code
	@echo "$(BLUE)Formatting Go code...$(NC)"
	@cd examples/go && go fmt ./...
	@cd examples/go && goimports -w .

format-java: ## Format Java code
	@echo "$(BLUE)Formatting Java code...$(NC)"
	@cd examples/java && mvn spotless:apply || echo "Spotless not configured"

# Docker operations
build: ## Build all Docker images
	@echo "$(BLUE)Building Docker images...$(NC)"
	@docker-compose build

up: ## Start all services
	@echo "$(BLUE)Starting all services...$(NC)"
	@docker-compose up -d
	@echo "$(GREEN)Services started!$(NC)"
	@echo "Python API: http://localhost:8000"
	@echo "Node.js API: http://localhost:3000"
	@echo "Go API: http://localhost:8080"
	@echo "Grafana: http://localhost:3001"
	@echo "Prometheus: http://localhost:9090"

down: ## Stop all services
	@echo "$(BLUE)Stopping all services...$(NC)"
	@docker-compose down

restart: ## Restart all services
	@echo "$(BLUE)Restarting all services...$(NC)"
	@docker-compose restart

logs: ## Show logs from all services
	@docker-compose logs -f

logs-python: ## Show Python service logs
	@docker-compose logs -f python-api

logs-nodejs: ## Show Node.js service logs
	@docker-compose logs -f nodejs-api

logs-go: ## Show Go service logs
	@docker-compose logs -f go-api

status: ## Show status of all services
	@docker-compose ps

# Development servers
dev-python: ## Start Python development server
	@echo "$(BLUE)Starting Python development server...$(NC)"
	@cd examples/python && poetry run uvicorn src.main:app --reload --host 0.0.0.0 --port 8000

dev-nodejs: ## Start Node.js development server
	@echo "$(BLUE)Starting Node.js development server...$(NC)"
	@cd examples/nodejs && npm run dev

dev-go: ## Start Go development server
	@echo "$(BLUE)Starting Go development server...$(NC)"
	@cd examples/go && go run cmd/main.go

dev-java: ## Start Java development server
	@echo "$(BLUE)Starting Java development server...$(NC)"
	@cd examples/java && mvn spring-boot:run

# Database operations
db-migrate: ## Run database migrations
	@echo "$(BLUE)Running database migrations...$(NC)"
	@cd examples/python && poetry run alembic upgrade head

db-reset: ## Reset database
	@echo "$(BLUE)Resetting database...$(NC)"
	@docker-compose down postgres
	@docker-compose up -d postgres
	@sleep 5
	@$(MAKE) db-migrate

# Security
security-scan: ## Run security scans
	@echo "$(BLUE)Running security scans...$(NC)"
	@cd examples/python && poetry run bandit -r src
	@cd examples/nodejs && npm audit
	@docker run --rm -v $(PWD):/app aquasec/trivy fs /app

# Cleanup
clean: ## Clean up generated files
	@echo "$(BLUE)Cleaning up...$(NC)"
	@docker-compose down -v
	@docker system prune -f
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
	@find . -type d -name "node_modules" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "coverage.out" -delete
	@find . -type d -name "target" -exec rm -rf {} + 2>/dev/null || true

clean-docker: ## Clean up Docker resources
	@echo "$(BLUE)Cleaning up Docker resources...$(NC)"
	@docker-compose down -v --remove-orphans
	@docker system prune -af

# Documentation
docs: ## Generate documentation
	@echo "$(BLUE)Generating documentation...$(NC)"
	@echo "Documentation available at:"
	@echo "Python API: http://localhost:8000/docs"
	@echo "Node.js API: http://localhost:3000/docs"
	@echo "Go API: http://localhost:8080/swagger/index.html"

# Git hooks
hooks: ## Install pre-commit hooks
	@echo "$(BLUE)Installing pre-commit hooks...$(NC)"
	@pre-commit install
	@pre-commit install --hook-type commit-msg

# Health checks
health: ## Check health of all services
	@echo "$(BLUE)Checking service health...$(NC)"
	@curl -f http://localhost:8000/health || echo "$(RED)Python API is down$(NC)"
	@curl -f http://localhost:3000/health || echo "$(RED)Node.js API is down$(NC)"
	@curl -f http://localhost:8080/api/v1/health || echo "$(RED)Go API is down$(NC)"

# Performance testing
perf: ## Run performance tests
	@echo "$(BLUE)Running performance tests...$(NC)"
	@k6 run scripts/performance-test.js

# All-in-one commands
setup: install hooks ## Complete setup (install + hooks)
	@echo "$(GREEN)Setup complete!$(NC)"

ci: lint test ## Run CI checks locally
	@echo "$(GREEN)CI checks passed!$(NC)"

deploy: build up ## Build and deploy locally
	@echo "$(GREEN)Local deployment complete!$(NC)"