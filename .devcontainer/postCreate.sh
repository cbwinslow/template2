#!/bin/bash

# Post-create script for setting up the development environment
echo "🚀 Setting up Template2 development environment..."

# Update package lists
sudo apt-get update

# Install additional development tools
sudo apt-get install -y \
    curl \
    wget \
    jq \
    tree \
    htop \
    vim \
    git-lfs \
    zsh \
    oh-my-zsh

# Setup Git LFS
git lfs install

# Install modern CLI tools
curl -sS https://starship.rs/install.sh | sh -s -- --yes
curl -sSfL https://raw.githubusercontent.com/cli/cli/trunk/install.sh | sudo bash

# Install language-specific tools and package managers

# Python tools
pip install --user pipx
pipx install poetry
pipx install pre-commit
pipx install black
pipx install flake8
pipx install mypy
pipx install pytest
pipx install bandit

# Node.js tools
npm install -g \
    @angular/cli \
    @vue/cli \
    create-react-app \
    typescript \
    ts-node \
    eslint \
    prettier \
    nodemon \
    npm-check-updates

# Go tools
go install golang.org/x/tools/gopls@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/swaggo/swag/cmd/swag@latest

# Create useful aliases
cat >> ~/.bashrc << 'EOF'

# Template2 Development Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dim='docker images'

# Kubernetes aliases
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias ka='kubectl apply'

# Development shortcuts
alias serve='python -m http.server'
alias weather='curl wttr.in'
alias myip='curl ipinfo.io/ip'

EOF

# Setup Starship prompt
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# Create project structure examples
mkdir -p /tmp/template2-examples
cd /tmp/template2-examples

echo "📁 Creating example project structures..."

# Create a sample workspace config
cat > workspace.code-workspace << 'EOF'
{
    "folders": [
        {
            "path": "./examples/python"
        },
        {
            "path": "./examples/nodejs"
        },
        {
            "path": "./examples/go"
        },
        {
            "path": "./examples/java"
        }
    ],
    "settings": {
        "python.defaultInterpreterPath": "/usr/local/python/current/bin/python",
        "go.gopath": "/go",
        "java.home": "/usr/lib/jvm/java-11-openjdk-amd64"
    },
    "extensions": {
        "recommendations": [
            "ms-python.python",
            "golang.go",
            "redhat.java",
            "ms-vscode.vscode-typescript-next",
            "github.copilot"
        ]
    }
}
EOF

echo "✅ Development environment setup complete!"
echo "🎯 You can now start developing with all the tools and configurations ready!"
echo "📚 Check the examples/ directory for language-specific project templates"