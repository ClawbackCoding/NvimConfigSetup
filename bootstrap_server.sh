#!/usr/bin/env bash
set -euo pipefail

GIT_NAME="ClawbackCoding"
GIT_EMAIL="tom@clawback.money"
NVIM_REPO_SSH="git@github.com:ClawbackCoding/NVIMConfigSetup.git"
NVIM_BRANCH="main"

echo "Starting Clawback VPS bootstrap"
echo

# Base packages
apt update
apt install -y git curl ca-certificates unzip tar xz-utils ripgrep fd-find

# Clipboard support for Neovim (X11 clipboard provider)
apt install -y xclip

# Fix fd name on Ubuntu
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" /usr/local/bin/fd || true
fi

# Git config
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global init.defaultBranch main

# SSH setup for GitHub
mkdir -p ~/.ssh
chmod 700 ~/.ssh

KEY_PATH="$HOME/.ssh/id_ed25519_github"

if [ ! -f "$KEY_PATH" ]; then
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$KEY_PATH" -N ""
fi

cat > ~/.ssh/config <<CONFIG
Host github.com
    HostName github.com
    User git
    IdentityFile $KEY_PATH
    IdentitiesOnly yes
CONFIG

chmod 600 ~/.ssh/config

echo
echo "Add this SSH key to GitHub"
echo "Settings -> SSH and GPG keys -> New SSH key"
echo
cat "${KEY_PATH}.pub"
echo
read -r -p "Press Enter after adding the key to GitHub: "

ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null || true
chmod 600 ~/.ssh/known_hosts

echo
echo "Testing GitHub SSH connection"
ssh -T git@github.com || true
echo

# Install Node 20
if ! command -v node >/dev/null 2>&1 || ! node -v | grep -qE '^v20\.'; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt install -y nodejs
fi

echo "Node: $(node -v)"
echo

# Install latest Neovim
TMP_DIR="$(mktemp -d)"
cd "$TMP_DIR"

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
rm -rf /opt/nvim-linux-x86_64
tar -C /opt -xzf nvim-linux-x86_64.tar.gz
ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

echo "Neovim installed:"
nvim --version | head -n 2
echo

# Install Claude
curl -fsSL https://claude.ai/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"

# Install Codex
npm i -g @openai/codex@latest

echo "Codex version:"
codex --version || true
echo

# Clone NVIM config
mkdir -p ~/.config
if [ -d ~/.config/nvim ]; then
  mv ~/.config/nvim ~/.config/nvim.backup.$(date +%s)
fi

git clone --branch "$NVIM_BRANCH" "$NVIM_REPO_SSH" ~/.config/nvim

# Force Neovim to use system clipboard by default
# Equivalent to running :set clipboard=unnamedplus
INIT_LUA="$HOME/.config/nvim/init.lua"
if [ -f "$INIT_LUA" ]; then
  if ! grep -q "clipboard=unnamedplus" "$INIT_LUA"; then
    cat >> "$INIT_LUA" <<'LUA'

-- Added by VPS bootstrap: use system clipboard by default
vim.opt.clipboard = "unnamedplus"
LUA
  fi
fi

# Create workspace directory
mkdir -p /workspace
chmod 755 /workspace

# Auto cd into workspace on login
if ! grep -q "/workspace" ~/.bashrc; then
  echo '[ -d /workspace ] && cd /workspace' >> ~/.bashrc
fi

echo
echo "Bootstrap complete"
echo "Open a new SSH session and you will land in /workspace"
echo "Then run: nvim"

