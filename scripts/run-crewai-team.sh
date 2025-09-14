#!/bin/bash

# CrewAI Development Team Runner Script
# This script provides a convenient way to run the AI development team analysis

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
CREWAI_DIR="$PROJECT_ROOT/examples/ai-ml/crewai-dev-team"
REPORTS_DIR="$PROJECT_ROOT/reports"

echo -e "${BLUE}🤖 CrewAI Development Team Runner${NC}"
echo -e "${BLUE}===================================${NC}"
echo ""

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "$CREWAI_DIR/crew.py" ]; then
    print_error "CrewAI crew.py not found. Make sure you're running this from the correct directory."
    exit 1
fi

# Parse command line arguments
ANALYSIS_TYPE="full"
PROJECT_PATH="$PROJECT_ROOT"
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--type)
            ANALYSIS_TYPE="$2"
            shift 2
            ;;
        -p|--path)
            PROJECT_PATH="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -t, --type TYPE       Analysis type (full, code-review, architecture, documentation, security, devops)"
            echo "  -p, --path PATH       Project path to analyze (default: repository root)"
            echo "  -v, --verbose         Enable verbose output"
            echo "  -h, --help           Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                              # Run full analysis on repository"
            echo "  $0 -t code-review              # Run only code review"
            echo "  $0 -p /path/to/project -v       # Analyze specific project with verbose output"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

print_status "Starting CrewAI Development Team Analysis..."
echo ""
echo "📊 Configuration:"
echo "   Analysis Type: $ANALYSIS_TYPE"
echo "   Project Path: $PROJECT_PATH"
echo "   Reports Dir: $REPORTS_DIR"
echo "   Verbose: $VERBOSE"
echo ""

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    print_error "Python3 is required but not found. Please install Python 3.8 or higher."
    exit 1
fi

# Check if virtual environment exists, create if not
VENV_DIR="$CREWAI_DIR/.venv"
if [ ! -d "$VENV_DIR" ]; then
    print_status "Creating Python virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

# Activate virtual environment
print_status "Activating virtual environment..."
source "$VENV_DIR/bin/activate"

# Install/upgrade dependencies
print_status "Installing/updating dependencies..."
pip install --quiet --upgrade pip
pip install --quiet -r "$CREWAI_DIR/requirements.txt"

# Check for environment variables
if [ -z "$OPENAI_API_KEY" ]; then
    if [ -f "$CREWAI_DIR/.env" ]; then
        print_status "Loading environment variables from .env file..."
        export $(cat "$CREWAI_DIR/.env" | grep -v '^#' | xargs)
    else
        print_warning "OPENAI_API_KEY not set. Creating .env file from template..."
        cp "$CREWAI_DIR/.env.example" "$CREWAI_DIR/.env"
        print_error "Please edit $CREWAI_DIR/.env and add your API keys, then run this script again."
        exit 1
    fi
fi

if [ -z "$OPENAI_API_KEY" ] || [ "$OPENAI_API_KEY" = "your-openai-api-key-here" ]; then
    print_error "Please set your OPENAI_API_KEY in the environment or $CREWAI_DIR/.env file."
    exit 1
fi

# Create reports directory
mkdir -p "$REPORTS_DIR"

# Set environment variables for the crew
export PROJECT_PATH="$PROJECT_PATH"
export REPORTS_DIR="$REPORTS_DIR"
export CREW_VERBOSE="$VERBOSE"
export ANALYSIS_TYPE="$ANALYSIS_TYPE"

print_status "🚀 Launching AI Development Team..."
echo ""

# Change to CrewAI directory and run the analysis
cd "$CREWAI_DIR"

# Run the crew with proper error handling
if python crew.py --path "$PROJECT_PATH"; then
    print_status "✅ Analysis completed successfully!"
    echo ""
    echo "📄 Reports generated in: $REPORTS_DIR"
    echo ""
    
    # List generated reports
    if [ -d "$REPORTS_DIR" ] && [ "$(ls -A $REPORTS_DIR)" ]; then
        echo "📋 Generated Reports:"
        ls -la "$REPORTS_DIR" | grep -E '\.(md|json|html)$' | while read -r line; do
            echo "   📝 $(echo $line | awk '{print $9}')"
        done
        echo ""
    fi
    
    # Show summary if available
    LATEST_REPORT=$(ls -t "$REPORTS_DIR"/analysis_report_*.md 2>/dev/null | head -1)
    if [ -n "$LATEST_REPORT" ]; then
        echo "📊 Quick Summary from latest report:"
        echo "----------------------------------------"
        head -20 "$LATEST_REPORT" | sed 's/^/   /'
        echo "   ..."
        echo "   (See full report at: $LATEST_REPORT)"
        echo ""
    fi
    
    print_status "🎉 AI Development Team analysis complete!"
    echo ""
    echo "💡 Next steps:"
    echo "   1. Review the generated reports"
    echo "   2. Address any identified issues"
    echo "   3. Implement suggested improvements"
    echo "   4. Re-run analysis to track progress"
    
else
    print_error "❌ Analysis failed. Check the output above for details."
    echo ""
    echo "🔧 Troubleshooting:"
    echo "   1. Ensure OPENAI_API_KEY is valid"
    echo "   2. Check network connectivity"
    echo "   3. Verify project path is accessible"
    echo "   4. Run with --verbose for more details"
    exit 1
fi

# Deactivate virtual environment
deactivate

echo ""
print_status "🏁 CrewAI Development Team Runner finished."