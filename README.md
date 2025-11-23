# General Development Container Image

[![Docker Image](https://ghcr-badge.egpl.dev/horatjp/devenv-general/latest_tag?color=%2344cc11&ignore=latest&label=version&trim=)](https://github.com/horatjp/image-devenv-general/pkgs/container/devenv-general)
[![Docker Image Size](https://ghcr-badge.egpl.dev/horatjp/devenv-general/size)](https://github.com/horatjp/image-devenv-general/pkgs/container/devenv-general)

A versatile development container based on Debian Trixie.
This container provides a comprehensive development environment with multiple programming language support and essential development tools.

## Features

- Multi-language version management (mise)
- Python package manager (uv)
- Enhanced shell environment (Oh My Zsh + Starship prompt)
- Essential development tools
- Database clients

### Runtime Version Management

- **mise**: Universal tool version manager for Node.js, Python, Ruby, Go, and more
- **Default Node.js version**: 24.11.1 (customizable at build time)
- Supports multiple language runtimes through a single tool

### Python Environment

- **uv**: Fast Python package manager and installer

### Development Tools

- **Version Control**: git, gh (GitHub CLI)
- **Editors**: vim
- **Terminal Multiplexer**: tmux
- **Modern CLI Tools**: ripgrep, fd-find, bat, eza, fzf
- **Shell**: zsh with Oh My Zsh and Starship prompt
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

### Default Build (Node.js 24.11.1)

```bash
docker build -t devenv-general .
```

### Custom Node.js Version

```bash
docker build --build-arg NODE_VERSION=20.11.0 -t devenv-general .
```

### Custom User Configuration

```bash
docker build \
  --build-arg USERNAME=myuser \
  --build-arg USER_UID=1001 \
  --build-arg NODE_VERSION=18.19.0 \
  -t devenv-general .
```

## Runtime Version Management with mise

This image uses [mise](https://mise.jdx.dev/) for managing multiple language runtimes. mise is a modern, fast alternative to tools like nvm, rbenv, pyenv, etc., supporting many languages through a single unified interface.

### List Installed Tools

```bash
mise list
```

### Install Additional Node.js Versions

```bash
mise use node@20.11.0
mise use node@18.19.0
```

### Switch Between Versions

```bash
# Set globally
mise use --global node@20

# Set for current project
mise use node@18
```

### List Available Versions

```bash
mise ls-remote node
```

### Install Other Languages

```bash
# Install Python
mise use python@3.12

# Install Go
mise use go@1.21

# Install Ruby
mise use ruby@3.2
```

### Check Current Versions

```bash
mise current
```

## Build Arguments

| Argument | Description | Default |
|----------|-------------|---------|
| `USERNAME` | Development user name | `devuser` |
| `USER_UID` | User ID | `1000` |
| `USER_GID` | Group ID | `USER_UID` |
| `NODE_VERSION` | Node.js version to install | `24.11.1` |

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

### Custom Node.js Version with Dev Container

```json
{
  "name": "General Development Environment",
  "build": {
    "dockerfile": "Dockerfile",
    "args": {
      "NODE_VERSION": "20.11.0"
    }
  },
  "remoteUser": "devuser",
  "workspaceFolder": "/workspace",
  "workspaceMount": "source=${localWorkspaceFolder},target=/workspace,type=bind,consistency=cached"
}
```

Create `.devcontainer/Dockerfile`:

```dockerfile
FROM ghcr.io/horatjp/devenv-general:latest

# Additional customizations if needed
```

### Installing Different Node.js Version at Runtime

```json
{
  "name": "General Development Environment",
  "image": "ghcr.io/horatjp/devenv-general:latest",
  "remoteUser": "devuser",
  "postCreateCommand": "mise use node@18",
  "workspaceFolder": "/workspace"
}
```

### Using mise with .mise.toml

You can also define tool versions in a `.mise.toml` file in your project:

```toml
[tools]
node = "20.11.0"
python = "3.12"
```

The versions will be automatically activated when you enter the project directory.

## License

MIT License
