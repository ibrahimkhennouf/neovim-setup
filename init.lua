--[[
  init.lua
  Neovim config using vim.pack (built-in package manager, Neovim 0.12+)
  Stack targeted: React, React Native, Next.js, TypeScript, Node.js,
  NestJS, Express.js, PostgreSQL, MongoDB

  vim.pack.add() clones plugins straight from git — no plugin-manager
  dependency. Run :help vim.pack if anything here is unclear.
  On first launch, run:
    :Lazy is NOT used here, plugins install automatically on this file's
    first source. Then run :MasonInstallAll (defined near the bottom)
    to pull in the LSPs/formatters, and :TSUpdate for treesitter parsers.
--]]

-------------------------------------------------------------------
-- 0. Leader keys (set before plugins load)
-------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-------------------------------------------------------------------
-- 1. Core options (the "VS Code defaults" baseline)
-------------------------------------------------------------------
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"      -- share clipboard with OS
opt.signcolumn = "yes"             -- avoid text shifting when diagnostics appear
opt.termguicolors = true
opt.scrolloff = 8
opt.updatetime = 250
opt.timeoutlen = 400

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.splitright = true
opt.splitbelow = true
opt.undofile = true                -- persistent undo
opt.wrap = false

opt.completeopt = { "menu", "menuone", "noselect" }

opt.foldlevel = 99                 -- keep folds open by default
opt.foldlevelstart = 99
opt.foldenable = true

-------------------------------------------------------------------
-- 2. Plugins via vim.pack
-------------------------------------------------------------------
-- vim.pack.add takes a list of { src = "<git url>" } (or plain url strings).
-- Plugins are installed on :source of this file and loaded immediately
-- (no lazy-loading by default — keeps this config simple and predictable).

vim.pack.add({
  -- Colorscheme
  { src = "https://github.com/folke/tokyonight.nvim" },

  -- Treesitter: real syntax highlighting/parsing (this pulls the `main`
  -- branch, i.e. the new rewritten nvim-treesitter — see setup below)
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },

  -- LSP
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },

  -- Autocompletion (VS Code-style IntelliSense popup)
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/hrsh7th/cmp-buffer" },
  { src = "https://github.com/hrsh7th/cmp-path" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/dsznajder/vscode-es7-javascript-react-snippets" }, -- the actual "rnfec" etc. snippet pack VS Code users know
  { src = "https://github.com/saadparwaiz1/cmp_luasnip" },

  -- Formatting (Biome handles JS/TS/JSON formatting + linting via its LSP;
  -- conform.nvim still drives formatting for filetypes Biome doesn't cover)
  { src = "https://github.com/stevearc/conform.nvim" },

  -- Fuzzy finder (Ctrl+P equivalent)
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },

  -- File explorer (Explorer sidebar equivalent)
  { src = "https://github.com/nvim-tree/nvim-tree.lua" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },

  -- Git integration (gutter signs + blame, like GitLens basics)
  { src = "https://github.com/lewis6991/gitsigns.nvim" },

  -- Full git TUI (commit, push, pull, branch, log) — VS Code's
  -- Source Control panel equivalent, wraps the `lazygit` CLI
  { src = "https://github.com/kdheepak/lazygit.nvim" },

  -- Statusline
  { src = "https://github.com/nvim-lualine/lualine.nvim" },

  -- Tab bar showing open buffers (VS Code-style tabs across the top)
  { src = "https://github.com/akinsho/bufferline.nvim" },

  -- Autopairs + comments (small but very VS Code-ish QoL)
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/numToStr/Comment.nvim" },
  { src = "https://github.com/windwp/nvim-ts-autotag" }, -- auto-close/rename JSX/TSX tags

  -- Inline error/warning virtual text made prettier
  { src = "https://github.com/folke/trouble.nvim" },

  -- Which-key: shows keybinding hints (VS Code command palette hint style)
  { src = "https://github.com/folke/which-key.nvim" },
})

vim.cmd.colorscheme("tokyonight")

-------------------------------------------------------------------
-- 3. Treesitter — parsers for your stack
-------------------------------------------------------------------
-- As of the `main` branch rewrite, nvim-treesitter no longer has the old
-- `nvim-treesitter.configs` module or its highlight/indent toggles — it
-- only installs parsers now. Highlighting/indent/folding are wired up
-- manually below using Neovim's own treesitter (this is the officially
-- documented way to do it post-rewrite).
local ts_langs = {
  "typescript", "tsx", "javascript", "json",
  "html", "css", "scss", "graphql",
  "sql", "yaml", "markdown", "markdown_inline",
  "lua", "vim", "vimdoc", "bash", "dockerfile", "gitignore",
}

require("nvim-treesitter").install(ts_langs)

-- jsonc has no parser of its own; it reuses the "json" grammar
vim.treesitter.language.register("json", "jsonc")

vim.api.nvim_create_autocmd("FileType", {
  pattern = { unpack(ts_langs), "jsonc" },
  callback = function()
    -- Highlighting
    vim.treesitter.start()
    -- Indentation (marked experimental upstream, but works well for these)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    -- Folding
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"
  end,
})

-------------------------------------------------------------------
-- 4. Mason — auto-installs the language servers (VS Code extensions
--    equivalent: it downloads the actual tsserver, biome, etc. binaries)
-------------------------------------------------------------------
require("mason").setup()

local servers = {
  "ts_ls",         -- TypeScript / JavaScript / React / Next.js
  "biome",         -- Biome: linting + formatting (replaces ESLint/Prettier)
  "html",
  "cssls",
  "tailwindcss",   -- if you use Tailwind in React/Next projects
  "jsonls",
  "graphql",
  "emmet_ls",      -- HTML/JSX expansion, VS Code Emmet equivalent
  "lua_ls",        -- for editing this very config
  "bashls",
  "sqlls",         -- PostgreSQL / general SQL
  "yamlls",
}

require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_installation = true,
})

-------------------------------------------------------------------
-- 5. LSP setup — native vim.lsp.config / vim.lsp.enable API.
--    (nvim-lspconfig is now just a repo of default server configs
--    consumed by this API; the old `require('lspconfig')[x].setup()`
--    framework is deprecated and going away in nvim-lspconfig v3.)
-------------------------------------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Applied as a base to every server enabled below
vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("ts_ls", {
  settings = {
    typescript = { inlayHints = {
      includeInlayParameterNameHints = "all",
      includeInlayFunctionLikeReturnTypeHints = true,
    } },
    javascript = { inlayHints = {
      includeInlayParameterNameHints = "all",
      includeInlayFunctionLikeReturnTypeHints = true,
    } },
  },
})

vim.lsp.enable(servers)

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end
    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gr", vim.lsp.buf.references, "References")
    map("n", "K", vim.lsp.buf.hover, "Hover docs")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
    map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  signs = true,
  update_in_insert = false,
})

-------------------------------------------------------------------
-- 6. Autocompletion (nvim-cmp)
-------------------------------------------------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
})

-- Load the actual ES7 React/Redux/React-Native VS Code snippet pack
-- (the real source of "rnfec" and friends), instead of reimplementing
-- individual snippets by hand.
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { vim.fn.stdpath("data") .. "/site/pack/core/opt/vscode-es7-javascript-react-snippets" },
})

-------------------------------------------------------------------
-- 7. Formatting (Biome for JS/TS/JSON/JSX; conform falls back to other
--    tools for filetypes Biome doesn't format)
-------------------------------------------------------------------
require("conform").setup({
  formatters_by_ft = {
    javascript = { "biome" },
    javascriptreact = { "biome" },
    typescript = { "biome" },
    typescriptreact = { "biome" },
    json = { "biome" },
    jsonc = { "biome" },
    graphql = { "biome" },
    css = { "biome" },        -- Biome's CSS formatter; drop this line if you'd rather skip it
    html = { "prettier" },    -- Biome doesn't format HTML
    scss = { "prettier" },    -- Biome doesn't format SCSS
    markdown = { "prettier" },
    yaml = { "prettier" },
    sql = { "sql_formatter" },
    lua = { "stylua" },
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
})

-- NOTE: linting is handled entirely by the biome LSP set up above (it
-- reports lint diagnostics the same way ts_ls/eslint would), so there's
-- no separate nvim-lint step needed for JS/TS/JSON/JSX files.

-------------------------------------------------------------------
-- 8. Telescope (fuzzy file/text search)
-------------------------------------------------------------------
require("telescope").setup({})
local tb = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", tb.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", tb.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", tb.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fs", tb.lsp_document_symbols, { desc = "Document symbols" })

-------------------------------------------------------------------
-- 9. File explorer (nvim-tree)
-------------------------------------------------------------------
require("nvim-tree").setup({})
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-------------------------------------------------------------------
-- 10. Git signs + git keymaps
-------------------------------------------------------------------
-- lazygit.nvim needs the actual `lazygit` binary on your PATH:
--   brew install lazygit
local gitsigns = require("gitsigns")
gitsigns.setup({
  on_attach = function(bufnr)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- Hunk navigation
    map("n", "]h", gitsigns.next_hunk, "Next git hunk")
    map("n", "[h", gitsigns.prev_hunk, "Prev git hunk")

    -- Hunk actions
    map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
    map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
    map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk diff")
    map("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end, "Blame line")
    map("v", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage selected hunk")
    map("v", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset selected hunk")

    -- Whole-buffer actions
    map("n", "<leader>hS", gitsigns.stage_buffer, "Stage buffer")
    map("n", "<leader>hR", gitsigns.reset_buffer, "Reset buffer")

    -- Toggles
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle inline blame")
    map("n", "<leader>td", gitsigns.toggle_deleted, "Toggle deleted lines")
  end,
})

-- Full git TUI — commit, push, pull, branch, stash, log, all in one view
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })

-------------------------------------------------------------------
-- 11. Statusline + buffer tabs
-------------------------------------------------------------------
require("lualine").setup({ options = { theme = "tokyonight" } })
require("bufferline").setup({})

-------------------------------------------------------------------
-- 12. QoL: autopairs, comments, diagnostics list, which-key
-------------------------------------------------------------------
require("nvim-autopairs").setup({})
require("nvim-ts-autotag").setup({})
require("Comment").setup({})
require("trouble").setup({})
require("which-key").setup({})

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Toggle diagnostics list" })

-------------------------------------------------------------------
-- 13. Misc keymaps
-------------------------------------------------------------------
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
vim.keymap.set("i", "jk", "<Esc>", { desc = "Escape insert mode" })

-- Buffer switching (Tab/Shift-Tab cycle through open buffers)
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- Jump straight to a buffer by its tab position (bufferline numbers them)
vim.keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", { desc = "Go to buffer 1" })
vim.keymap.set("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", { desc = "Go to buffer 2" })
vim.keymap.set("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", { desc = "Go to buffer 3" })
vim.keymap.set("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", { desc = "Go to buffer 4" })

-- Window navigation (assumed this is what you meant by Ctrl+h/l — flag if
-- you actually wanted these to switch buffers instead, and I'll swap them)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })

-- Move line(s) up/down (VS Code's Alt+Up/Down)
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-------------------------------------------------------------------
-- 14. Helper command to bulk-install Mason tools + stylua
-------------------------------------------------------------------
vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd("MasonInstall " .. table.concat(servers, " ")
    .. " prettier stylua sql-formatter")
  -- prettier is kept only for html/scss/markdown/yaml, which biome doesn't format
end, {})
