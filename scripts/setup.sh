#!/bin/bash

# Template2 Development Setup Script
# This script sets up the development environment for all language examples

set -e

echo "🚀 Setting up Template2 development environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check system requirements
check_requirements() {
    print_status "Checking system requirements..."
    
    local missing_deps=()
    
    if ! command_exists docker; then
        missing_deps+=("docker")
    fi
    
    if ! command_exists docker-compose; then
        missing_deps+=("docker-compose")
    fi
    
    if ! command_exists git; then
        missing_deps+=("git")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_status "Please install the missing dependencies and run this script again."
        exit 1
    fi
    
    print_success "All required dependencies are installed!"
}

# Setup Python environment
setup_python() {
    print_status "Setting up Python environment..."
    
    if [ -d "examples/python" ]; then
        cd examples/python
        
        if command_exists poetry; then
            print_status "Installing Python dependencies with Poetry..."
            poetry install
            print_success "Python environment setup complete!"
        elif command_exists pip; then
            print_status "Installing Python dependencies with pip..."
            pip install -r requirements.txt 2>/dev/null || print_warning "No requirements.txt found"
        else
            print_warning "Neither Poetry nor pip found. Skipping Python setup."
        fi
        
        cd ../..
    else
        print_warning "Python example directory not found. Skipping Python setup."
    fi
}

# Setup Node.js environment
setup_nodejs() {
    print_status "Setting up Node.js environment..."
    
    if [ -d "examples/nodejs" ]; then
        cd examples/nodejs
        
        if command_exists npm; then
            print_status "Installing Node.js dependencies with npm..."
            npm install
            print_success "Node.js environment setup complete!"
        elif command_exists yarn; then
            print_status "Installing Node.js dependencies with yarn..."
            yarn install
            print_success "Node.js environment setup complete!"
        else
            print_warning "Neither npm nor yarn found. Skipping Node.js setup."
        fi
        
        cd ../..
    else
        print_warning "Node.js example directory not found. Skipping Node.js setup."
    fi
}

# Setup Go environment
setup_go() {
    print_status "Setting up Go environment..."
    
    if [ -d "examples/go" ]; then
        cd examples/go
        
        if command_exists go; then
            print_status "Downloading Go dependencies..."
            go mod download
            print_success "Go environment setup complete!"
        else
            print_warning "Go not found. Skipping Go setup."
        fi
        
        cd ../..
    else
        print_warning "Go example directory not found. Skipping Go setup."
    fi
}

# Setup Java environment
setup_java() {
    print_status "Setting up Java environment..."
    
    if [ -d "examples/java" ]; then
        cd examples/java
        
        if command_exists mvn; then
            print_status "Installing Java dependencies with Maven..."
            mvn dependency:resolve
            print_success "Java environment setup complete!"
        elif command_exists gradle; then
            print_status "Installing Java dependencies with Gradle..."
            gradle build --exclude-task test
            print_success "Java environment setup complete!"
        else
            print_warning "Neither Maven nor Gradle found. Skipping Java setup."
        fi
        
        cd ../..
    else
        print_warning "Java example directory not found. Skipping Java setup."
    fi
}

# Setup pre-commit hooks
setup_precommit() {
    print_status "Setting up pre-commit hooks..."
    
    if command_exists pre-commit; then
        pre-commit install
        print_success "Pre-commit hooks installed!"
    else
        print_warning "pre-commit not found. Skipping pre-commit setup."
        print_status "You can install it with: pip install pre-commit"
    fi
}

# Setup Docker development environment
setup_docker() {
    print_status "Setting up Docker development environment..."
    
    if [ -f "docker-compose.yml" ]; then
        print_status "Building Docker images..."
        docker-compose build
        print_success "Docker images built successfully!"
        
        print_status "Starting services in background..."
        docker-compose up -d postgres redis
        print_success "Database services started!"
    else
        print_warning "docker-compose.yml not found. Skipping Docker setup."
    fi
}

# Run all setup functions
main() {
    print_status "Starting Template2 development environment setup..."
    
    check_requirements
    setup_python
    setup_nodejs
    setup_go
    setup_java
    setup_precommit
    setup_docker
    
    print_success "🎉 Development environment setup complete!"
    print_status "You can now start developing with Template2!"
    print_status ""
    print_status "Quick start commands:"
    print_status "  - Start all services: docker-compose up"
    print_status "  - Run Python API: cd examples/python && poetry run uvicorn src.main:app --reload"
    print_status "  - Run Node.js API: cd examples/nodejs && npm run dev"
    print_status "  - Run Go API: cd examples/go && go run cmd/main.go"
    print_status "  - Run Java API: cd examples/java && mvn spring-boot:run"
    print_status ""
    print_status "Visit the APIs:"
    print_status "  - Python: http://localhost:8000"
    print_status "  - Node.js: http://localhost:3000"
    print_status "  - Go: http://localhost:8080"
    print_status "  - Java: http://localhost:8090"
}

# Run main function
main "$@"