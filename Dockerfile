FROM debian:trixie

ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG NODE_VERSION=24.11.1

ENV DEVCONTAINER=true

# Install development tools and utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    bzip2 \
    ca-certificates \
    chromium \
    curl \
    dnsutils \
    fonts-noto-cjk \
    git \
    gnupg \
    imagemagick \
    iproute2 \
    jq \
    less \
    locales \
    lsb-release \
    lsof \
    mariadb-client \
    ncdu \
    openssh-client \
    pkg-config \
    postgresql-client \
    procps \
    rsync \
    shellcheck \
    sqlite3 \
    sudo \
    tree \
    unzip \
    wget \
    vim \
    yq \
    zip \
    zsh \
    # Additional tools for development
    tmux \
    ripgrep \
    fd-find \
    bat \
    eza \
    fzf \
    gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure locale, create user, and set up workspace
RUN : \
    # user
    && groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd -s /bin/zsh --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    # work directory
    && mkdir -p /workspace \
    && chown ${USERNAME}:${USERNAME} /workspace

# Install uv (Python package manager)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Remove Chromium desktop entry
RUN rm -f /usr/share/applications/chromium.desktop

# Install Starship prompt (as non-root user)
RUN su ${USERNAME} -c 'curl -sS https://starship.rs/install.sh | sh -s -- --yes'

# Install Oh My Zsh and plugins in a single layer
RUN su ${USERNAME} -c 'git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh \
    # Plugins
    && git clone --depth=1 https://github.com/marlonrichert/zsh-autocomplete ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete \
    && git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'

# Install mise and Node.js
RUN su ${USERNAME} -c 'curl https://mise.run | sh'
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"
RUN su ${USERNAME} -c 'mise use --global node@${NODE_VERSION}'

# Copy custom zsh configuration files
COPY --chown=${USERNAME}:${USERNAME} config/.zshrc /home/${USERNAME}/.zshrc
COPY --chown=${USERNAME}:${USERNAME} config/.zshrc.alias /home/${USERNAME}/.zshrc.alias
COPY --chown=${USERNAME}:${USERNAME} config/.zshrc.history /home/${USERNAME}/.zshrc.history
COPY --chown=${USERNAME}:${USERNAME} config/.zshrc.oh-my-zsh /home/${USERNAME}/.zshrc.oh-my-zsh
COPY --chown=${USERNAME}:${USERNAME} config/starship.toml /home/${USERNAME}/.config/starship.toml

# Set environment variables
ENV SHELL=/bin/zsh

# Set working directory
WORKDIR /workspace
