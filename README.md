# ⚡ Custom LazyVim Configuration

My Neovim configuration built on top of the [LazyVim](https://github.com/LazyVim/LazyVim) framework. Engineered to make Neovim your one and only code editor! 🚀

---

## ✨ Features

### 🤖 AI-Assisted Development (`plugins/ai/`)
- **GitHub Copilot:** Seamless inline auto-completions and code suggestions.
- **Ollama:** Integration for local, private Large Language Models.
- **OpenCode:** Tailored code intelligence extensions.

### 🐙 GitHub Integration (`plugins/api/`)
- **Octo.nvim:** Review PRs, manage issues, add comments, and handle git workflows directly from inside your editor buffer.

### 🎛️ Language Specific Environments (`plugins/lang/`)
- **Python (Conda):** Seamlessly swap and manage conda environments without breaking your active LSP session via `nvim-conda`.
- **Typst:** Fast, responsive live-previewing and compilation support for the modern typesetting language via `typst-preview`.

### ⚙️ Core Enhancements
- **LSP Configuration:** Tailored code navigation, diagnostics, and hover handlers.
- **Formatting (`conform.nvim`):** High-performance, asynchronous code formatting on save.
- **Polished UI:** Custom keymaps, autocommands, and specialized window/buffer views.

---

## 🚀 Setup Guide

### 📋 Prerequisites
Ensure your system meets the minimum requirements before proceeding:
- **Neovim:** Version `0.10.0` or higher.
- **Git:** For plugin cloning and update syncing.
- **External CLI Tools:** `ripgrep` (search), `fd` (find), and a [Nerd Font](https://www.nerdfonts.com/) for rich icons.

### 📦 Installation

1. **Back up your existing configuration** (if applicable):
   ```bash
   # Linux / macOS
   mv ~/.config/nvim ~/.config/nvim.bak
   mv ~/.local/share/nvim ~/.local/share/nvim.bak
   mv ~/.local/state/nvim ~/.local/state/nvim.bak
   mv ~/.cache/nvim ~/.cache/nvim.bak
   ```

2. **Clone this repository** into your Neovim configuration directory:
   ```bash
   git clone https://github.com/your-username/your-repo-name.git ~/.config/nvim
   ```

3. **Launch Neovim:**
   ```bash
   nvim
   ```
   *Lazy.nvim will automatically bootstrap itself and begin downloading all configured plugins. Once completed, restart Neovim to initialize the language servers.*

---

## 📚 Documentation & Reference

This setup is built as a superset of **LazyVim**. For full control over configuration paradigms, advanced keymaps, and built-in features, consult the primary documentation resources:

- [LazyVim Official Documentation](https://lazyvim.github.io)
- [LazyVim Installation Guide](https://lazyvim.github.io/installation)
- [LazyVim Keymaps & Plugins Reference](https://lazyvim.github.io/keymaps)

---

## 🎨 Obligatory xkcd

While you're here, please enjoy this xkcd:

[![xkcd Comic](https://imgs.xkcd.com/comics/real_programmers.png)](https://xkcd.com/378/)
