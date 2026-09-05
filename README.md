# 🌙 Neovim Config

A single-file Neovim configuration targeting the modern **React / React Native / Next.js / TypeScript / Node.js / NestJS / Express.js / PostgreSQL / MongoDB** full-stack.

Uses **`vim.pack`** — Neovim 0.12+'s built-in package manager. No Lazy.nvim, no Packer, no plugin-manager dependency.

---

## Requirements

| Tool | Purpose |
|------|---------|
| **Neovim 0.12+** | Required for `vim.pack` and `vim.lsp.config` APIs |
| **Git** | `vim.pack` clones plugins directly from GitHub |
| **Node.js / npm** | Needed by many LSPs (`ts_ls`, `biome`, etc.) |
| **lazygit** | LazyGit TUI (`brew install lazygit`) |
| **A Nerd Font** | Icons in nvim-tree, bufferline, lualine |

> **Optional formatters installed via Mason:** `prettier`, `stylua`, `sql-formatter`

---

## First-Launch Setup

```sh
# 1. Clone / copy this config to the right place (if you haven't already)
#    macOS/Linux: ~/.config/nvim/

# 2. Open Neovim — plugins install automatically on first source
nvim

# 3. Inside Neovim, install LSPs and formatters:
:MasonInstallAll

# 4. Install Treesitter parsers:
:TSUpdate
```

---

## Plugins

### 🎨 Colorscheme
| Plugin | Description |
|--------|-------------|
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Tokyo Night colorscheme |

### 🌳 Syntax & Parsing
| Plugin | Description |
|--------|-------------|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Real AST-based syntax highlighting, indentation, and folding |

**Installed parsers:** `typescript`, `tsx`, `javascript`, `json`, `html`, `css`, `scss`, `graphql`, `sql`, `yaml`, `markdown`, `lua`, `vim`, `vimdoc`, `bash`, `dockerfile`, `gitignore`

### 🔧 LSP
| Plugin | Description |
|--------|-------------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Default server configs consumed by `vim.lsp.config` |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP/tool installer UI |
| [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | Auto-installs servers from Mason |

**Auto-installed language servers:**

| Server | Language / Purpose |
|--------|--------------------|
| `ts_ls` | TypeScript, JavaScript, React, Next.js |
| `biome` | Linting + formatting (replaces ESLint/Prettier for JS/TS/JSON) |
| `html` | HTML |
| `cssls` | CSS |
| `tailwindcss` | Tailwind CSS |
| `jsonls` | JSON |
| `graphql` | GraphQL |
| `emmet_ls` | HTML/JSX Emmet expansion |
| `lua_ls` | Lua (for editing this config) |
| `bashls` | Bash |
| `sqlls` | PostgreSQL / SQL |
| `yamlls` | YAML |

### ✏️ Autocompletion
| Plugin | Description |
|--------|-------------|
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Completion engine |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | LSP completion source |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | Buffer word completion |
| [cmp-path](https://github.com/hrsh7th/cmp-path) | Filesystem path completion |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |
| [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) | LuaSnip completion source |

### 💅 Formatting
| Plugin | Description |
|--------|-------------|
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Format-on-save orchestrator |

**Formatter mapping:**

| Filetype | Formatter |
|----------|-----------|
| JS, JSX, TS, TSX, JSON, JSONC, GraphQL, CSS | `biome` |
| HTML, SCSS, Markdown, YAML | `prettier` |
| SQL | `sql_formatter` |
| Lua | `stylua` |

> Linting is handled entirely by the **Biome LSP** — no separate nvim-lint needed for JS/TS/JSON files.

### 🔭 Fuzzy Finder
| Plugin | Description |
|--------|-------------|
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy file/text search (Ctrl+P equivalent) |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua utility library (Telescope dependency) |

### 🗂️ File Explorer
| Plugin | Description |
|--------|-------------|
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | Explorer sidebar (VS Code Explorer equivalent) |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File icons |

### 🔀 Git
| Plugin | Description |
|--------|-------------|
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Gutter diff signs + inline blame |
| [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) | Full git TUI (commit, push, pull, branch, log) |

### 📊 UI Chrome
| Plugin | Description |
|--------|-------------|
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | VS Code-style buffer tabs |

### 🛠️ Quality of Life
| Plugin | Description |
|--------|-------------|
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets, quotes, etc. |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Toggle comments (`gcc`, `gc`) |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Pretty diagnostics list panel |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keybinding hint popup |

---

## Keymaps

> **Leader key:** `<Space>`

### LSP (active when an LSP is attached)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Completion (insert mode)

| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger completion |
| `<CR>` | Confirm selection |
| `<Tab>` | Next item |
| `<S-Tab>` | Previous item |

### Telescope

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fs` | Document symbols |

### File Explorer

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle nvim-tree |

### Git (gitsigns)

| Key | Action |
|-----|--------|
| `]h` | Next git hunk |
| `[h` | Previous git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk diff |
| `<leader>hb` | Blame line (full) |
| `<leader>hs` *(visual)* | Stage selected hunk |
| `<leader>hr` *(visual)* | Reset selected hunk |
| `<leader>hS` | Stage entire buffer |
| `<leader>hR` | Reset entire buffer |
| `<leader>tb` | Toggle inline blame |
| `<leader>td` | Toggle deleted lines |
| `<leader>gg` | Open LazyGit TUI |

### Buffers & Windows

| Key | Action |
|-----|--------|
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `<leader>bd` | Close buffer |
| `<leader>1–4` | Jump to buffer 1–4 |
| `<C-h/j/k/l>` | Navigate splits |

### Diagnostics

| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle Trouble diagnostics panel |

### Misc

| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `jk` *(insert)* | Escape to normal mode |

---

## Editor Settings

| Setting | Value |
|---------|-------|
| Line numbers | Absolute + relative |
| Tab / indent | 2 spaces, expandtab, smartindent |
| Clipboard | Shared with OS (`unnamedplus`) |
| Scroll offset | 8 lines |
| Search | Case-insensitive, smart-case |
| Undo | Persistent (`undofile`) |
| Folds | TreeSitter expr, open by default (`foldlevel = 99`) |
| Splits | Right + below |
| Diagnostics | Virtual text, underline, signs, not in insert mode |

---

## Custom Commands

| Command | Description |
|---------|-------------|
| `:MasonInstallAll` | Bulk-install all LSPs + `prettier`, `stylua`, `sql-formatter` |
| `:TSUpdate` | Update / install Treesitter parsers |

---

## File Structure

```
~/.config/nvim/
└── init.lua          # Single-file config — everything lives here
```
