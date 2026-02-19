# 🚀 Clawback VPS Bootstrap + NVIM Setup

This repository contains my production Neovim configuration and a one-command VPS bootstrap process.
It is designed to turn a fresh Ubuntu VPS into a fully configured development environment with:

- Git configured for ClawbackCoding
- SSH authentication to GitHub
- Node.js 20
- Latest Neovim
- Claude CLI
- OpenAI Codex CLI
- Workspace directory auto-configured
- NVIM config cloned and ready

---

## 🧠 What This Does

When executed on a fresh VPS, the bootstrap script:

1. Installs system dependencies
2. Configures global Git identity
3. Generates a GitHub SSH key on the server
4. Pauses for you to add the key to GitHub
5. Installs Node.js 20
6. Installs latest Neovim
7. Installs Claude CLI
8. Installs OpenAI Codex CLI
9. Clones this NVIM config into `~/.config/nvim`
10. Creates `/workspace`
11. Automatically `cd`'s into `/workspace` on login

After setup, every new VPS behaves identically.

---

## 📦 Requirements

- Fresh Ubuntu VPS
- SSH access as root
- Your local machine with the bootstrap script saved

---

## 🖥 How To Use On A New VPS

From your local machine, open PowerShell in:
```
C:\Users\Pxrse
```

Then run:
```powershell
scp .\bootstrap_clawback.sh root@YOUR_SERVER_IP:/root/bootstrap_clawback.sh
```

> Replace `YOUR_SERVER_IP` with your actual VPS IP.

Then execute the script remotely:
```bash
ssh root@YOUR_SERVER_IP "chmod +x /root/bootstrap_clawback.sh && /root/bootstrap_clawback.sh"
```

---

## 🔐 SSH Key Step

During execution, the script will:

- Generate a GitHub SSH key on the VPS
- Display the public key
- Pause

You must:

1. Go to [GitHub](https://github.com)
2. Navigate to **Settings → SSH and GPG keys**
3. Click **New SSH key**
4. Paste the key
5. Press **Enter** in the VPS terminal

The script will continue automatically.

---

## 📁 Workspace Structure

After installation:
```
/
└── workspace/
```

Every new SSH session automatically lands inside `/workspace`, keeping projects separate from system directories.

---

## 🧰 Installed Tools

| Tool | Version | Source |
|------|---------|--------|
| Neovim | Latest stable release | GitHub releases |
| Node.js | 20.x | NodeSource |
| Claude CLI | Latest | Official installer |
| Codex CLI | Latest | npm global package |

---

## 🚀 After Setup

Open a new SSH session:
```bash
ssh root@YOUR_SERVER_IP
```

You will land in `/workspace`. Then start Neovim:
```bash
nvim
```

Lazy.nvim will automatically bootstrap plugins.

---

## 🔁 Reproducibility

This setup is:

- Stateless
- Repeatable
- Independent of GitHub to fetch the bootstrap script
- Designed for rapid server provisioning

Every VPS can be initialized in **under 3 minutes**.

---

## 🔒 Security Note

This script:

- Uses SSH authentication instead of Personal Access Tokens
- Does not hardcode credentials
- Keeps all secrets local to the server

---

## 📌 Philosophy

This repository is not just an NVIM config.

It is a standardized development environment bootstrap for:

- Trading systems
- Infra experiments
- AI pipelines
- Rapid VPS deployment

**One script. One config. Identical environments everywhere.**
