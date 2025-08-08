#!/bin/bash

# setup_and_run.sh - Auto setup virtual environment and run the application

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
VENV_NAME="venv"
PYTHON_FILE="db_man_zmq.py"  # Change this to your actual Python file name
REQUIREMENTS_FILE="requirements.txt"

echo -e "${GREEN}Starting automated setup...${NC}"

# Check if Python is installed
if ! command -v python &> /dev/null && ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python is not installed or not in PATH${NC}"
    exit 1
fi

# Use python3 if available, otherwise python
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
else
    PYTHON_CMD="python"
fi

echo -e "${YELLOW}Using Python command: $PYTHON_CMD${NC}"

# Check if virtual environment already exists
if [ -d "$VENV_NAME" ]; then
    echo -e "${YELLOW}Virtual environment '$VENV_NAME' already exists. Removing it...${NC}"
    rm -rf "$VENV_NAME"
fi

# Create virtual environment
echo -e "${GREEN}Creating virtual environment...${NC}"
$PYTHON_CMD -m venv "$VENV_NAME"

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to create virtual environment${NC}"
    exit 1
fi

# Activate virtual environment
echo -e "${GREEN}Activating virtual environment...${NC}"
source "$VENV_NAME/bin/activate"

# Upgrade pip
echo -e "${GREEN}Upgrading pip...${NC}"
pip install --upgrade pip

# Create requirements.txt if it doesn't exist
if [ ! -f "$REQUIREMENTS_FILE" ]; then
    echo -e "${YELLOW}Creating $REQUIREMENTS_FILE...${NC}"
    cat > "$REQUIREMENTS_FILE" << EOF
pyzmq==27.0.1
EOF
fi

# Install requirements
echo -e "${GREEN}Installing requirements...${NC}"
if [ -f "$REQUIREMENTS_FILE" ]; then
    pip install -r "$REQUIREMENTS_FILE"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to install requirements${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}No requirements.txt found, installing pyzmq directly...${NC}"
    pip install pyzmq
fi

# Check if Python file exists
if [ ! -f "$PYTHON_FILE" ]; then
    echo -e "${RED}Error: Python file '$PYTHON_FILE' not found${NC}"
    echo -e "${YELLOW}Available Python files:${NC}"
    ls *.py 2>/dev/null || echo "No Python files found"
    exit 1
fi

# Test import
echo -e "${GREEN}Testing pyzmq installation...${NC}"
python -c "import zmq; print('✓ PyZMQ successfully imported')" 2>/dev/null

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to import zmq${NC}"
    exit 1
fi

# Run the Python script
echo -e "${GREEN}Running $PYTHON_FILE...${NC}"
echo -e "${YELLOW}=================================${NC}"

python "$PYTHON_FILE"

# Capture exit code
EXIT_CODE=$?

echo -e "${YELLOW}=================================${NC}"

if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}Script completed successfully${NC}"
else
    echo -e "${RED}Script exited with code: $EXIT_CODE${NC}"
fi

# Keep virtual environment activated
echo -e "${YELLOW}Virtual environment is still active. To deactivate, run: deactivate${NC}"