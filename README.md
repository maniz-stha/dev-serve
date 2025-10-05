# local-serve

A smart command-line tool that automatically detects and runs development servers for your projects. Say goodbye to remembering different commands for Rails, Node.js, Next.js, and other project types!

## ✨ Features

- 🚀 **Zero Configuration** - Auto-detects Rails, Next.js, and Node.js projects
- ⚙️ **Flexible Configuration** - Override defaults with local or global config files
- 🎯 **Smart Detection** - Reads `package.json` scripts and identifies project types
- 🌍 **Multi-Project Support** - Manage all your projects from a single global config
- 🔧 **Environment Variables** - Set environment variables per project
- 📦 **Lightweight** - Single Ruby script, no dependencies

## 🎬 Quick Start

### Prerequisites

- Ruby 2.5 or higher (usually pre-installed on macOS and most Linux distributions)

Check your Ruby version:
```bash
ruby --version
```

## 📥 Installation

### Automated Installation (Recommended)

#### macOS & Linux

Run this one-liner in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/maniz-stha/local-serve/main/install.sh | bash
```

Or using wget:
```bash
wget -qO- https://raw.githubusercontent.com/maniz-stha/local-serve/main/install.sh | bash
```

This will:
1. Download the `local-serve` script
2. Install it to `~/.local/bin/local-serve`
3. Make it executable
4. Add it to your PATH if needed
5. Verify the installation

### Manual Installation

#### Step 1: Download the Script

```bash
# Create the bin directory
mkdir -p ~/.local/bin

# Download the script (replace with actual URL or copy the file)
curl -o ~/.local/bin/local-serve https://raw.githubusercontent.com/maniz-stha/local-serve/main/local-serve

# Or if you have the file locally
cp local-serve ~/.local/bin/local-serve

# Make it executable
chmod +x ~/.local/bin/local-serve
```

#### Step 2: Add to PATH

Add `~/.local/bin` to your PATH by adding this line to your shell configuration file:

**For Bash** (`~/.bashrc` or `~/.bash_profile`):
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**For Zsh** (`~/.zshrc`):
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**For Fish** (`~/.config/fish/config.fish`):
```bash
echo 'set -gx PATH $HOME/.local/bin $PATH' >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish
```

#### Step 3: Verify Installation

```bash
local-serve --help
```

If you see the help message, you're all set! 🎉

### Troubleshooting Installation

**Command not found after installation:**
1. Make sure you've sourced your shell config: `source ~/.bashrc` (or `~/.zshrc`)
2. Verify the file exists: `ls -la ~/.local/bin/local-serve`
3. Check if it's executable: `chmod +x ~/.local/bin/local-serve`
4. Restart your terminal

**Ruby not found:**
- **macOS**: Ruby comes pre-installed. If missing, install via Homebrew: `brew install ruby`
- **Linux**: Install via package manager:
  - Ubuntu/Debian: `sudo apt-get install ruby`
  - Fedora: `sudo dnf install ruby`
  - Arch: `sudo pacman -S ruby`

## 🚀 Usage

### Basic Usage

Simply navigate to your project directory and run:

```bash
cd ~/projects/my-rails-app
local-serve
```

That's it! `local-serve` will:
1. Check for a local config file (`.local-serve.yml`)
2. Check your global config (`~/.config/local-serve/config.yml`)
3. Auto-detect the project type and run the appropriate command

### Initialize Project Config

Create a project-specific configuration:

```bash
cd ~/projects/my-project
local-serve --init
```

This creates a `.local-serve.yml` file in your current directory with smart defaults based on your project type.

### Command Line Options

```bash
local-serve [options]

Options:
  --init          Initialize config file in current directory
  -h, --help      Show help message
```

## ⚙️ Configuration

### Configuration Priority

`local-serve` checks configurations in this order:
1. **Local config** (`.local-serve.yml` in project root) - Highest priority
2. **Global config** (`~/.config/local-serve/config.yml`) - Path-based matching
3. **Auto-detection** - Fallback based on project type

### Local Configuration

Create a `.local-serve.yml` file in your project root:

```yaml
# Rails project example
command: "bin/rails server"
env:
  RAILS_ENV: development
  DATABASE_URL: postgres://localhost/myapp_dev
```

```yaml
# Node.js/Next.js project example
command: "npm run dev"
env:
  NODE_ENV: development
  API_URL: http://localhost:3001
```

```yaml
# Custom command with options
command: "pnpm dev --turbo --port 3002"
```

### Global Configuration

Manage multiple projects from a single file at `~/.config/local-serve/config.yml`:

```yaml
projects:
  # Rails backend
  - path: ~/projects/my-app-backend
    command: bin/rails server
    env:
      RAILS_ENV: development
      DATABASE_URL: postgres://localhost/myapp_dev

  # Next.js frontend
  - path: ~/projects/my-app-frontend
    command: npm run dev
    env:
      NEXT_PUBLIC_API_URL: http://localhost:3000

  # React Native admin panel
  - path: ~/projects/my-app-admin
    command: pnpm dev

  # Express.js middleware
  - path: ~/projects/my-app-middleware
    command: npm run start:dev
    env:
      NODE_ENV: development
      LOG_LEVEL: debug
```

**Important**: Use absolute paths in the global config. The `~` character will be expanded automatically.

### Configuration Options

| Option | Description | Example |
|--------|-------------|---------|
| `command` | Command to run the dev server | `bin/rails server`, `npm run dev` |
| `env` | Environment variables (optional) | `RAILS_ENV: development` |

## 🔍 Auto-Detection

When no configuration is found, `local-serve` automatically detects:

### Rails Projects
- **Detection**: Looks for `Gemfile` and `config/application.rb`
- **Command**: `bin/rails server`

### Next.js Projects
- **Detection**: Looks for `next.config.js` or `next.config.mjs`
- **Command**: Reads from `package.json` scripts (`dev`, `start:dev`, `develop`, or `start`)

### Node.js Projects
- **Detection**: Looks for `package.json`
- **Command**: Reads from `package.json` scripts in this order:
  1. `dev`
  2. `start:dev`
  3. `develop`
  4. `start`

## 📖 Examples

### Example 1: Rails API with Custom Port

**.local-serve.yml:**
```yaml
command: "bin/rails server -p 3001"
env:
  RAILS_ENV: development
  RAILS_LOG_LEVEL: debug
```

### Example 2: Next.js with Turbopack

**.local-serve.yml:**
```yaml
command: "npm run dev -- --turbo"
env:
  NEXT_PUBLIC_API_URL: http://localhost:3001
  NEXT_PUBLIC_FEATURE_FLAG: true
```

### Example 3: Multiple Projects in Global Config

**~/.config/local-serve/config.yml:**
```yaml
projects:
  # E-commerce backend
  - path: /Users/john/projects/ecommerce/api
    command: bin/rails server

  # E-commerce frontend
  - path: /Users/john/projects/ecommerce/web
    command: npm run dev

  # E-commerce admin dashboard
  - path: /Users/john/projects/ecommerce/admin
    command: pnpm dev

  # Blog site
  - path: /Users/john/projects/blog
    command: hugo server -D
```

Now you can run `local-serve` in any of these directories and it will use the right command!

### Example 4: Monorepo Setup

For projects within a monorepo, the global config matches the most specific path:

```yaml
projects:
  # Parent monorepo - won't match if more specific path exists
  - path: /Users/john/projects/monorepo
    command: npm run dev

  # Specific apps in monorepo
  - path: /Users/john/projects/monorepo/apps/web
    command: npm run dev --workspace=web

  - path: /Users/john/projects/monorepo/apps/api
    command: npm run dev --workspace=api
```

## 🛠️ Advanced Usage

### Using with Different Package Managers

`local-serve` works with any package manager:

```yaml
# npm
command: "npm run dev"

# yarn
command: "yarn dev"

# pnpm
command: "pnpm dev"

# bun
command: "bun run dev"
```

### Custom Development Commands

Not all projects use standard commands:

```yaml
# Django
command: "python manage.py runserver"

# Laravel
command: "php artisan serve"

# Hugo
command: "hugo server -D"

# Vite
command: "vite"

# Make-based projects
command: "make dev"

# Docker Compose
command: "docker-compose up"
```

### Environment Variables

Set environment variables that will be available to your development server:

```yaml
command: "bin/rails server"
env:
  RAILS_ENV: development
  DATABASE_URL: postgres://localhost/myapp_dev
  REDIS_URL: redis://localhost:6379
  SECRET_KEY_BASE: your-secret-key
  AWS_ACCESS_KEY_ID: your-key
  AWS_SECRET_ACCESS_KEY: your-secret
```

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

MIT License - feel free to use this project however you'd like!

## 🐛 Troubleshooting

### Command not found
- Verify installation: `which local-serve`
- Check PATH: `echo $PATH | grep .local/bin`
- Re-source your shell config: `source ~/.bashrc` or `source ~/.zshrc`

### Wrong command being executed
1. Check for local config: `ls -la .local-serve.yml`
2. Check global config: `cat ~/.config/local-serve/config.yml`
3. Verify path matching - more specific paths are matched first
4. Remember: Local config (`.local-serve.yml`) always takes priority

### YAML parsing errors
- Ensure consistent indentation (2 spaces, not tabs)
- Validate your YAML: https://www.yamllint.com/
- Check for special characters in strings - wrap in quotes if needed

### Permission denied
```bash
chmod +x ~/.local/bin/local-serve
```

## 💡 Tips & Tricks

1. **Project Templates**: Create a `.local-serve.yml` template and copy it to new projects
2. **Team Sharing**: Commit `.local-serve.yml` to your repository for team consistency
3. **Quick Switching**: Use the global config to quickly switch between projects
4. **Debugging**: Add `set -x` at the top of the script to see what's being executed
5. **Multiple Configs**: Use local configs for project-specific settings and global config for shared settings

## 📮 Support

Found a bug? Have a feature request?
- Open an issue on GitHub
- Check existing issues first to avoid duplicates

## 🎯 Roadmap

- [ ] Support for `.env` file loading
- [ ] Project aliases (run by name instead of path)
- [ ] Multi-command support (run multiple servers)
- [ ] Interactive project selector
- [ ] Health check and auto-restart
- [ ] Log file management
- [ ] Plugin system for custom project types

---

Made with ❤️ for developers who are tired of remembering different commands for different projects.
