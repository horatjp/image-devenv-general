FROM debian:trixie

ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

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
    lazygit \
    git-delta \
    btop \
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

# Remove Chromium desktop entry
RUN rm -f /usr/share/applications/chromium.desktop

# Install Starship prompt (as non-root user)
RUN su ${USERNAME} -c 'curl -sS https://starship.rs/install.sh | sh -s -- --yes'

# Install Znap (Zsh plugin manager) and pre-install plugins
RUN su ${USERNAME} -c 'git clone --depth=1 https://github.com/marlonrichert/zsh-snap.git /home/${USERNAME}/.zsh-snap \
    && source /home/${USERNAME}/.zsh-snap/znap.zsh \
    && znap clone marlonrichert/zsh-autocomplete \
    && znap clone zsh-users/zsh-autosuggestions \
    && znap clone zsh-users/zsh-syntax-highlighting'

# Install mise
RUN su ${USERNAME} -c 'curl https://mise.run | sh'
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"
ENV MISE_TRUSTED_CONFIG_PATHS="/workspace"

# Install usage CLI for better mise completions
RUN su ${USERNAME} -c 'mise use -g usage@latest'

# Copy custom configuration files
COPY --chown=${USERNAME}:${USERNAME} config/.zshrc /home/${USERNAME}/.zshrc
COPY --chown=${USERNAME}:${USERNAME} config/.zshrc.alias /home/${USERNAME}/.zshrc.alias
COPY --chown=${USERNAME}:${USERNAME} config/.zshrc.history /home/${USERNAME}/.zshrc.history
COPY --chown=${USERNAME}:${USERNAME} config/.zshrc.znap /home/${USERNAME}/.zshrc.znap
COPY --chown=${USERNAME}:${USERNAME} config/starship.toml /home/${USERNAME}/.config/starship.toml
COPY --chown=${USERNAME}:${USERNAME} config/.vimrc /home/${USERNAME}/.vimrc

# Set environment variables
ENV SHELL=/bin/zsh

# Set working directory
WORKDIR /workspace
