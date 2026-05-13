#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MARKER="# -------------- dotfiles install ---------------"

# Ask Y/n
function ask() {
    read -p "$1 (Y/n): " resp
    if [ -z "$resp" ]; then
        response_lc="y" # empty is Yes
    else
        response_lc=$(echo "$resp" | tr '[:upper:]' '[:lower:]') # case insensitive
    fi

    [ "$response_lc" = "y" ]
}

# Check what shell is being used
SH="${HOME}/.bashrc"
ZSHRC="${HOME}/.zshrc"
if [ -f "$ZSHRC" ]; then
    SH="$ZSHRC"
fi

# Remove previous dotfiles install block if present
if grep -qF "$MARKER" "$SH" 2>/dev/null; then
    sed -i "/$MARKER/,/$MARKER/d" "$SH"
    echo "Removed previous dotfiles config from $SH"
fi

echo >> "$SH"
echo "$MARKER" >> "$SH"

# Ask which files should be sourced
echo "Do you want $SH to source: "
for file in "$DOTFILES_DIR"/shell/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if ask "${filename}?"; then
            echo "source $file" >> "$SH"
        fi
    fi
done

echo "$MARKER" >> "$SH"

# Git config (one-time setup)
if ask "Do you want to configure git user?"; then
    read -p "Git user name: " git_name
    read -p "Git email: " git_email
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    echo "Git configured: $git_name <$git_email>"
fi

# SSH key
if [ -f "$HOME/.ssh/id_ed25519" ]; then
    echo "SSH key already exists."
    if ask "Do you want to print the public key?"; then
        echo ""
        cat "$HOME/.ssh/id_ed25519.pub"
        echo ""
    fi
elif ask "Do you want to generate an SSH key?"; then
    read -p "Email for SSH key: " ssh_email
    ssh-keygen -t ed25519 -C "$ssh_email"
    echo ""
    echo "Your public key (add this to GitHub, GitLab, etc.):"
    echo ""
    cat "$HOME/.ssh/id_ed25519.pub"
    echo ""
fi

# Authorized keys
if ask "Do you want to add public keys to ~/.ssh/authorized_keys?"; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    touch "$HOME/.ssh/authorized_keys"
    chmod 600 "$HOME/.ssh/authorized_keys"
    echo "Paste public keys one per line (empty line to finish):"
    while true; do
        read -r key
        [ -z "$key" ] && break
        if grep -qF "$key" "$HOME/.ssh/authorized_keys" 2>/dev/null; then
            echo "Key already present, skipping."
        else
            echo "$key" >> "$HOME/.ssh/authorized_keys"
            echo "Key added."
        fi
    done
fi

# Vim conf
if ask "Do you want to install .vimrc?"; then
    ln -sf "$DOTFILES_DIR/vimrc" ~/.vimrc
fi

# tmux conf
if ask "Do you want to install .tmux.conf?"; then
    ln -sf "$DOTFILES_DIR/tmuxconf" ~/.tmux.conf
fi

# Miniconda
if [ "$(uname -s)" = "Linux" ] && [ "$(uname -m)" = "x86_64" ]; then
    if command -v conda &>/dev/null; then
        echo "Miniconda is already installed, skipping."
    elif ask "Do you want to install Miniconda?"; then
        MINICONDA_INSTALLER="/tmp/miniconda_installer.sh"
        curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o "$MINICONDA_INSTALLER"
        bash "$MINICONDA_INSTALLER" -b -p "$HOME/miniconda3"
        rm "$MINICONDA_INSTALLER"
        "$HOME/miniconda3/bin/conda" init "$(basename "$SHELL")"
        echo "Miniconda installed. Restart your shell or run 'source $SH' to activate."
    fi
else
    echo "Skipping Miniconda install (only supported on Linux x86_64)."
fi

# uv
if command -v uv &>/dev/null; then
    echo "uv is already installed, skipping."
elif ask "Do you want to install uv?"; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    echo "uv installed. Restart your shell or run 'source $SH' to activate."
fi

# NVM
if [ -d "$HOME/.nvm" ] || command -v nvm &>/dev/null; then
    echo "NVM is already installed, skipping."
elif ask "Do you want to install NVM (Node Version Manager)?"; then
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
    echo "NVM installed. Restart your shell or run 'source $SH' to activate."
fi

# NPM global packages (requires npm)
if command -v npm &>/dev/null; then
    for pkg in "opencode-ai@latest" "@mariozechner/pi-coding-agent" "@anthropic-ai/claude-code"; do
        if ask "Do you want to install $pkg?"; then
            npm install -g "$pkg"
        fi
    done
else
    echo "Skipping npm packages (npm not found)."
fi
