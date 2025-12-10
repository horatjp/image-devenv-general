# General Development Container Image

[![Docker Image](https://ghcr-badge.egpl.dev/horatjp/devenv-general/latest_tag?color=%2344cc11&ignore=latest&label=version&trim=)](https://github.com/horatjp/image-devenv-general/pkgs/container/devenv-general)
[![Docker Image Size](https://ghcr-badge.egpl.dev/horatjp/devenv-general/size)](https://github.com/horatjp/image-devenv-general/pkgs/container/devenv-general)

A versatile, lightweight development container based on Debian Trixie.
This container provides a comprehensive development environment with flexible runtime management and modern development tools.

## Features

- 🚀 Multi-language version management (mise)
- 🎨 Enhanced shell environment (Znap + Starship prompt)
- 🛠️ Modern development tools (lazygit, git-delta, btop, and more)
- 💾 Database clients
- 🎯 Zero pre-installed runtimes - install what you need via mise

### Runtime Version Management

- **mise**: Universal tool version manager for Node.js, Bun, Deno, Python, Ruby, Go, and more
- No pre-installed runtimes - keeps the image lightweight and flexible
- Install only what you need for your project
- Supports multiple language runtimes through a single unified tool

### Development Tools

- **Version Control**: git, gh (GitHub CLI), lazygit (Git TUI)
- **Git Enhancement**: git-delta (beautiful diff output)
- **Editors**: vim (with pre-configured .vimrc)
  - Line numbers, syntax highlighting
  - Dark color scheme with transparent background
  - Smart indent and search
  - Modern key mappings (Space as leader key)
  - Auto backup, undo, and swap files
- **Terminal Multiplexer**: tmux
- **System Monitor**: btop (modern resource monitor)
- **Modern CLI Tools**: ripgrep, fd-find, bat, eza, fzf
- **Shell**: zsh with Znap plugin manager and Starship prompt
  - Pre-installed plugins: zsh-autocomplete, zsh-autosuggestions, zsh-syntax-highlighting
- **Other Tools**: shellcheck, jq, yq, tree, ncdu, rsync

### Database Clients

- PostgreSQL client
- MariaDB client
- SQLite3

### Additional Tools

- **Browser**: Chromium
- **Image Processing**: ImageMagick
- **Build Tools**: build-essential, pkg-config
- **Network Utilities**: curl, wget, dnsutils, iproute2
- **Archive Tools**: zip, unzip, bzip2
- **System Tools**: sudo, less, procps, lsb-release
- **Security**: gnupg, ca-certificates, openssh-client
- **Fonts**: fonts-noto-cjk (Japanese, Chinese, Korean support)

## Building the Image

### Default Build

```bash
docker build -t devenv-general .
```

### Custom User Configuration

```bash
docker build \
  --build-arg USERNAME=myuser \
  --build-arg USER_UID=1001 \
  -t devenv-general .
```

## Runtime Version Management with mise

This image uses [mise](https://mise.jdx.dev/) for managing multiple language runtimes. mise is a modern, fast alternative to tools like nvm, rbenv, pyenv, etc., supporting many languages through a single unified interface.

**Note**: No runtimes are pre-installed. You install only what you need for your project, keeping the container lightweight and flexible.

### Quick Start Examples

```bash
# Install Node.js
mise use node@22

# Install Bun (fast JavaScript runtime)
mise use bun@latest

# Install Python
mise use python@3.12

# Install Deno
mise use deno@latest

# Install Go
mise use go@1.21

# Install Ruby
mise use ruby@3.2
```

### Common Commands

```bash
# List installed tools
mise list

# List available versions of a tool
mise ls-remote node

# Set globally (for all projects)
mise use --global node@20

# Set for current project only
mise use node@18

# Check current versions
mise current

# Install all tools defined in .mise.toml or .tool-versions
mise install
```

## Build Arguments

| Argument | Description | Default |
|----------|-------------|---------|
| `USERNAME` | Development user name | `devuser` |
| `USER_UID` | User ID | `1000` |
| `USER_GID` | Group ID | `USER_UID` |

## Usage Examples

### Basic Usage

```bash
docker run -it --rm --user devuser -v $(pwd):/workspace devenv-general zsh
```

### Development with Port Forwarding

```bash
docker run -it --rm \
  --user devuser \
  -v $(pwd):/workspace \
  -p 3000:3000 \
  devenv-general zsh
```

### VS Code Dev Container Configuration

Create `.devcontainer/devcontainer.json` in your project:

```json
{
  "name": "General Development Environment",
  "image": "ghcr.io/horatjp/devenv-general:latest",
  "remoteUser": "devuser",
  "customizations": {
    "vscode": {
      "extensions": [
        "EditorConfig.EditorConfig"
      ]
    }
  },
  "workspaceFolder": "/workspace",
  "workspaceMount": "source=${localWorkspaceFolder},target=/workspace,type=bind,consistency=cached"
}
```

### Installing Runtime at Container Creation

Use `postCreateCommand` to automatically install the runtime when the container is created:

```json
{
  "name": "General Development Environment",
  "image": "ghcr.io/horatjp/devenv-general:latest",
  "remoteUser": "devuser",
  "postCreateCommand": "mise use node@22 && mise use bun@latest",
  "workspaceFolder": "/workspace"
}
```

### Using mise with .mise.toml

You can define tool versions in a `.mise.toml` file in your project root:

```toml
[tools]
node = "22.11.0"
bun = "latest"
python = "3.12"
go = "1.21"
```

Or use `.tool-versions` (asdf-compatible format):

```
node 22.11.0
bun latest
python 3.12
go 1.21
```

The versions will be automatically activated when you enter the project directory. Simply run `mise install` to install all defined tools.

## License

MIT License
