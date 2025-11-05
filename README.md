# dev-serve

A smart command-line tool that automatically detects and runs development servers for your projects. Say goodbye to remembering different commands for Rails, Node.js, Next.js, and other project types!

## ✨ Features

- 🚀 **Zero Configuration** - Auto-detects Rails, Next.js, and Node.js projects
- ⚙️ **Flexible Configuration** - Override defaults with local or global config files
- 🎯 **Smart Detection** - Reads `package.json` scripts and identifies project types
- 🌍 **Multi-Project Support** - Manage all your projects from a single global config
- 🏷️ **Named Projects** - Start servers by project name from anywhere
- 🔧 **Environment Variables** - Set environment variables per project
- ⚡ **Pre-Commands** - Run setup commands (like `git pull`) before starting the server
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
curl -fsSL https://raw.githubusercontent.com/maniz-stha/dev-serve/main/install.sh | bash
```

Or using wget:
```bash
wget -qO- https://raw.githubusercontent.com/maniz-stha/dev-serve/main/install.sh | bash
```

This will:
1. Download the `dev-serve` script
2. Install it to `~/.local/bin/dev-serve`
3. Make it executable
4. Add it to your PATH if needed
5. Verify the installation

### Manual Installation

#### Step 1: Download the Script

```bash
# Create the bin directory
mkdir -p ~/.local/bin

# Download the script (replace with actual URL or copy the file)
curl -o ~/.local/bin/dev-serve https://raw.githubusercontent.com/maniz-stha/dev-serve/main/dev-serve

# Or if you have the file locally
cp dev-serve ~/.local/bin/dev-serve

# Make it executable
chmod +x ~/.local/bin/dev-serve
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
dev-serve --help
```

If you see the help message, you're all set! 🎉

### Troubleshooting Installation

**Command not found after installation:**
1. Make sure you've sourced your shell config: `source ~/.bashrc` (or `~/.zshrc`)
2. Verify the file exists: `ls -la ~/.local/bin/dev-serve`
3. Check if it's executable: `chmod +x ~/.local/bin/dev-serve`
4. Restart your terminal

**Ruby not found:**
- **macOS**: Ruby comes pre-installed. If missing, install via Homebrew: `brew install ruby`
- **Linux**: Install via package manager:
  - Ubuntu/Debian: `sudo apt-get install ruby`
  - Fedora: `sudo dnf install ruby`
  - Arch: `sudo pacman -S ruby`

## 🚀 Usage

### Basic Usage

#### Option 1: Run from Project Directory
Navigate to your project directory and run:

```bash
cd ~/projects/my-rails-app
dev-serve
```

#### Option 2: Run by Project Name (NEW!)
Start any project from anywhere using its name:

```bash
dev-serve my-app-backend
```

That's it! `dev-serve` will:
1. Check for a local config file (`.dev-serve.yml`)
2. Check your global config (`~/.config/dev-serve/config.yml`)
3. Auto-detect the project type and run the appropriate command

### Initialize Project Config

Create a project-specific configuration:

```bash
cd ~/projects/my-project
dev-serve --init
```

This creates a `.dev-serve.yml` file in your current directory with smart defaults based on your project type.

### Command Line Options

```bash
dev-serve [project-name] [options]

Options:
  --init              Initialize config file in current directory
  --run-pre-command   Run the 'pre-command' (if configured) before starting the server
  -h, --help          Show help message

Examples:
  dev-serve                        # Run server in current directory
  dev-serve my-app-backend         # Run server for named project
  dev-serve --init                 # Initialize config file
  dev-serve my-app-backend --run-pre-command # Run 'pre-command' then start server
```

## ⚙️ Configuration

### Configuration Priority

`dev-serve` checks configurations in this order:
1. **Local config** (`.dev-serve.yml` in project root) - Highest priority
2. **Global config** (`~/.config/dev-serve/config.yml`) - Path-based matching
3. **Auto-detection** - Fallback based on project type

### Local Configuration

Create a `.dev-serve.yml` file in your project root:

```yaml
# Rails project example
command: "bin/rails server"
pre-command: "git pull origin main"  # Optional: run before starting server
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

Manage multiple projects from a single file at `~/.config/dev-serve/config.yml`:

```yaml
projects:
  # Rails backend
  - path: ~/projects/my-app-backend
    name: my-app-backend
    command: bin/rails server
    pre-command: git pull origin main  # Optional: run before starting server
    env:
      RAILS_ENV: development
      DATABASE_URL: postgres://localhost/myapp_dev

  # Next.js frontend
  - path: ~/projects/my-app-frontend
    name: my-app-frontend
    command: npm run dev
    env:
      NEXT_PUBLIC_API_URL: http://localhost:3000

  # React Native admin panel
  - path: ~/projects/my-app-admin
    name: my-app-admin
    command: pnpm dev

  # Express.js middleware
  - path: ~/projects/my-app-middleware
    name: my-app-middleware
    command: npm run start:dev
    env:
      NODE_ENV: development
      LOG_LEVEL: debug
```

**Important**: Use absolute paths in the global config. The `~` character will be expanded automatically.

### Named Projects

With named projects, you can start any development server from anywhere by using the project name:

```bash
# From any directory, start your Rails backend
dev-serve my-app-backend

# Start your Next.js frontend
dev-serve my-app-frontend

# Start your admin panel
dev-serve my-app-admin
```

The script will:
1. Look up the project in your global config by name
2. Change to the project directory
3. Run the configured command

If a project name is not found, the script will show you all available projects:

```bash
$ dev-serve unknown-project
❌ Project 'unknown-project' not found in global config
Available projects:
  - my-app-backend (~/projects/my-app-backend)
  - my-app-frontend (~/projects/my-app-frontend)
  - my-app-admin (~/projects/my-app-admin)

Check your global config at ~/.config/dev-serve/config.yml
```

### Configuration Options

| Option | Description | Example |
|--------|-------------|---------|
| `path` | Project directory path | `~/projects/my-app` |
| `name` | Project name for running by name | `my-app-backend` |
| `command` | Command to run the dev server | `bin/rails server`, `npm run dev` |
| `pre-command` | Command to run before starting server (optional) | `git pull origin main`, `npm install` |
| `env` | Environment variables (optional) | `RAILS_ENV: development` |

## 🔍 Auto-Detection

When no configuration is found, `dev-serve` automatically detects:

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

**.dev-serve.yml:**
```yaml
command: "bin/rails server -p 3001"
env:
  RAILS_ENV: development
  RAILS_LOG_LEVEL: debug
```

### Example 2: Next.js with Turbopack

**.dev-serve.yml:**
```yaml
command: "npm run dev -- --turbo"
env:
  NEXT_PUBLIC_API_URL: http://localhost:3001
  NEXT_PUBLIC_FEATURE_FLAG: true
```

### Example 3: Multiple Projects in Global Config

**~/.config/dev-serve/config.yml:**
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

Now you can run `dev-serve` in any of these directories and it will use the right command!

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

### Example 5: Using Pre-Command

Run setup commands before starting your development server:

**~/.config/dev-serve/config.yml:**
```yaml
projects:
  - path: /Users/john/projects/apps/admin
    name: admin
    command: bin/rails server
    pre-command: git pull origin main
```

Then run:
```bash
dev-serve admin --run-pre-command
```

This will:
1. Run `git pull origin main` first
2. Then start `bin/rails server`

**Local config example (.dev-serve.yml):**
```yaml
command: "npm run dev"
pre-command: "git pull && npm install"
```

Use `--run-pre-command` to execute the pre-command before starting the server. If the pre-command fails, the server won't start.

## 🛠️ Advanced Usage

### Using with Different Package Managers

`dev-serve` works with any package manager:

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

### Pre-Commands

Run setup commands before starting your development server. Use the `--run-pre-command` flag to execute the pre-command:

```yaml
command: "bin/rails server"
pre-command: "git pull origin main"
```

Common use cases:
- Pull latest changes: `pre-command: git pull origin main`
- Install dependencies: `pre-command: npm install`
- Run migrations: `pre-command: bin/rails db:migrate`
- Multiple commands: `pre-command: "git pull && npm install"`

**Important**: The pre-command only runs when you use the `--run-pre-command` flag. If the pre-command fails (non-zero exit code), the server won't start.

### Environment Variables

Set environment variables that will be available to your development server:

```yaml
command: "bin/rails server"
pre-command: "git pull origin main"  # Optional
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
- Verify installation: `which dev-serve`
- Check PATH: `echo $PATH | grep .local/bin`
- Re-source your shell config: `source ~/.bashrc` or `source ~/.zshrc`

### Wrong command being executed
1. Check for local config: `ls -la .dev-serve.yml`
2. Check global config: `cat ~/.config/dev-serve/config.yml`
3. Verify path matching - more specific paths are matched first
4. Remember: Local config (`.dev-serve.yml`) always takes priority

### YAML parsing errors
- Ensure consistent indentation (2 spaces, not tabs)
- Validate your YAML: https://www.yamllint.com/
- Check for special characters in strings - wrap in quotes if needed

### Permission denied
```bash
chmod +x ~/.local/bin/dev-serve
```

## 💡 Tips & Tricks

1. **Project Templates**: Create a `.dev-serve.yml` template and copy it to new projects
2. **Team Sharing**: Commit `.dev-serve.yml` to your repository for team consistency
3. **Quick Switching**: Use the global config to quickly switch between projects
4. **Debugging**: Add `set -x` at the top of the script to see what's being executed
5. **Multiple Configs**: Use local configs for project-specific settings and global config for shared settings

## 📮 Support

Found a bug? Have a feature request?
- Open an issue on GitHub
- Check existing issues first to avoid duplicates

## 🎯 Roadmap

- [ ] Support for `.env` file loading
- [x] Project aliases (run by name instead of path) ✅
- [ ] Multi-command support (run multiple servers)
- [ ] Interactive project selector
- [ ] Health check and auto-restart
- [ ] Log file management
- [ ] Plugin system for custom project types

---

Made with ❤️ for developers who are tired of remembering different commands for different projects.
