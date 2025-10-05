#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="dev-serve"
SCRIPT_URL="https://raw.githubusercontent.com/maniz-stha/dev-serve/main/dev-serve"
SHELL_CONFIG=""

# Helper functions
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Detect shell and config file
detect_shell() {
    if [ -n "$BASH_VERSION" ]; then
        if [ -f "$HOME/.bashrc" ]; then
            SHELL_CONFIG="$HOME/.bashrc"
        elif [ -f "$HOME/.bash_profile" ]; then
            SHELL_CONFIG="$HOME/.bash_profile"
        fi
        SHELL_NAME="bash"
    elif [ -n "$ZSH_VERSION" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
        SHELL_NAME="zsh"
    elif [ -n "$FISH_VERSION" ]; then
        SHELL_CONFIG="$HOME/.config/fish/config.fish"
        SHELL_NAME="fish"
    else
        # Try to detect from SHELL variable
        case "$SHELL" in
            */bash)
                SHELL_NAME="bash"
                SHELL_CONFIG="$HOME/.bashrc"
                [ -f "$HOME/.bash_profile" ] && SHELL_CONFIG="$HOME/.bash_profile"
                ;;
            */zsh)
                SHELL_NAME="zsh"
                SHELL_CONFIG="$HOME/.zshrc"
                ;;
            */fish)
                SHELL_NAME="fish"
                SHELL_CONFIG="$HOME/.config/fish/config.fish"
                ;;
            *)
                SHELL_NAME="unknown"
                ;;
        esac
    fi
}

# Check if Ruby is installed
check_ruby() {
    print_step "Checking for Ruby..."
    
    if ! command -v ruby &> /dev/null; then
        print_error "Ruby is not installed!"
        echo ""
        echo "Please install Ruby first:"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "  brew install ruby"
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo "  Ubuntu/Debian: sudo apt-get install ruby"
            echo "  Fedora: sudo dnf install ruby"
            echo "  Arch: sudo pacman -S ruby"
        fi
        exit 1
    fi
    
    RUBY_VERSION=$(ruby --version | cut -d' ' -f2)
    print_success "Ruby $RUBY_VERSION found"
}

# Create installation directory
create_install_dir() {
    print_step "Creating installation directory..."
    
    if [ ! -d "$INSTALL_DIR" ]; then
        mkdir -p "$INSTALL_DIR"
        print_success "Created $INSTALL_DIR"
    else
        print_success "Directory $INSTALL_DIR already exists"
    fi
}

# Download the script
download_script() {
    print_step "Downloading dev-serve..."
    
    TEMP_FILE=$(mktemp)
    
    if command -v curl &> /dev/null; then
        if curl -fsSL "$SCRIPT_URL" -o "$TEMP_FILE"; then
            mv "$TEMP_FILE" "$INSTALL_DIR/$SCRIPT_NAME"
            print_success "Downloaded successfully"
        else
            print_error "Failed to download from $SCRIPT_URL"
            rm -f "$TEMP_FILE"
            exit 1
        fi
    elif command -v wget &> /dev/null; then
        if wget -qO "$TEMP_FILE" "$SCRIPT_URL"; then
            mv "$TEMP_FILE" "$INSTALL_DIR/$SCRIPT_NAME"
            print_success "Downloaded successfully"
        else
            print_error "Failed to download from $SCRIPT_URL"
            rm -f "$TEMP_FILE"
            exit 1
        fi
    else
        print_error "Neither curl nor wget is available"
        rm -f "$TEMP_FILE"
        exit 1
    fi
}

# Make script executable
make_executable() {
    print_step "Making script executable..."
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    print_success "Script is now executable"
}

# Check if PATH includes install directory
check_path() {
    if [[ ":$PATH:" == *":$INSTALL_DIR:"* ]]; then
        return 0
    else
        return 1
    fi
}

# Add to PATH
add_to_path() {
    print_step "Checking PATH configuration..."
    
    if check_path; then
        print_success "$INSTALL_DIR is already in PATH"
        return 0
    fi
    
    print_warning "$INSTALL_DIR is not in PATH"
    
    detect_shell
    
    if [ "$SHELL_NAME" = "unknown" ] || [ -z "$SHELL_CONFIG" ]; then
        print_warning "Could not detect shell configuration file"
        echo ""
        echo "Please add the following line to your shell configuration file:"
        echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
        echo ""
        return 1
    fi
    
    print_step "Adding to PATH in $SHELL_CONFIG..."
    
    # Create backup
    cp "$SHELL_CONFIG" "${SHELL_CONFIG}.backup"
    
    # Add PATH export based on shell
    if [ "$SHELL_NAME" = "fish" ]; then
        echo "" >> "$SHELL_CONFIG"
        echo "# Added by dev-serve installer" >> "$SHELL_CONFIG"
        echo "set -gx PATH \$HOME/.local/bin \$PATH" >> "$SHELL_CONFIG"
    else
        echo "" >> "$SHELL_CONFIG"
        echo "# Added by dev-serve installer" >> "$SHELL_CONFIG"
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_CONFIG"
    fi
    
    print_success "Added $INSTALL_DIR to PATH in $SHELL_CONFIG"
    print_warning "Please run: source $SHELL_CONFIG"
    echo "  Or restart your terminal for changes to take effect"
    
    return 0
}

# Verify installation
verify_installation() {
    print_step "Verifying installation..."
    
    # Add to PATH temporarily for verification
    export PATH="$INSTALL_DIR:$PATH"
    
    if command -v dev-serve &> /dev/null; then
        print_success "dev-serve is installed and accessible"
        
        # Try to run help command
        if "$INSTALL_DIR/$SCRIPT_NAME" --help &> /dev/null; then
            print_success "Script is working correctly"
            return 0
        else
            print_warning "Script exists but may have issues running"
            return 1
        fi
    else
        print_error "Installation verification failed"
        return 1
    fi
}

# Create initial global config directory
create_config_dir() {
    print_step "Setting up configuration directory..."
    
    CONFIG_DIR="$HOME/.config/dev-serve"
    
    if [ ! -d "$CONFIG_DIR" ]; then
        mkdir -p "$CONFIG_DIR"
        print_success "Created config directory: $CONFIG_DIR"
    else
        print_success "Config directory already exists"
    fi
}

# Main installation
main() {
    echo ""
    echo "╔═══════════════════════════════════════╗"
    echo "║   dev-serve Installation Script    ║"
    echo "╚═══════════════════════════════════════╝"
    echo ""
    
    check_ruby
    create_install_dir
    download_script
    make_executable
    create_config_dir
    add_to_path
    
    echo ""
    verify_installation
    VERIFY_STATUS=$?
    
    echo ""
    echo "╔═══════════════════════════════════════╗"
    echo "║          Installation Complete!       ║"
    echo "╚═══════════════════════════════════════╝"
    echo ""
    
    if [ $VERIFY_STATUS -eq 0 ]; then
        print_success "dev-serve has been successfully installed!"
        echo ""
        echo "Quick Start:"
        echo "  1. Navigate to a project directory"
        echo "  2. Run: dev-serve"
        echo ""
        echo "For more options, run: dev-serve --help"
        
        if ! check_path; then
            echo ""
            print_warning "Remember to reload your shell configuration:"
            echo "  source $SHELL_CONFIG"
            echo "  OR restart your terminal"
        fi
    else
        echo ""
        print_warning "Installation completed but verification had issues"
        echo "Try running: source $SHELL_CONFIG"
        echo "Then verify with: dev-serve --help"
    fi
    
    echo ""
    echo "Documentation: https://github.com/maniz-stha/dev-serve"
    echo ""
}

# Run installation
main