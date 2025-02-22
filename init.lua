require("plugins")

require("neo-tree").setup({
  close_if_last_window = false,
  enable_diagnostics = true,
  enable_git_status = true,
  popup_border_style = "rounded",
  sort_case_insensitive = false,
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
  window = { width = 30 },
})

require("lualine").setup()

require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt" },
})

-- Git signs
require("gitsigns").setup()

-- Bufferline
require("bufferline").setup()

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "css",
    "elixir",
    "fish",
    "graphql",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "php",
    "python",
    "regex",
    "ruby",
    "rust",
    "scss",
    "sql",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml",
  },
  highlight = { enable = true },
  indent = { enable = true },
  autotag = {
  enable = true,
  filetypes = {
    "html",
    "javascript",
    "javascriptreact",
    "svelte",
    "typescript",
    "typescriptreact",
    "vue",
    "xml",
  },
  },
})

------------------------------

local set = vim.opt

set.background = "dark"
set.clipboard = "unnamedplus"
set.completeopt = "noinsert,menuone,noselect"
set.cursorline = true
set.expandtab = true
set.foldexpr = "nvim_treesitter#foldexpr()"
set.foldmethod = "manual"
set.hidden = true
set.inccommand = "split"
set.mouse = "a"
set.number = true
set.relativenumber = true
set.shiftwidth = 2
set.smarttab = true
set.splitbelow = true
set.splitright = true
set.swapfile = false
set.tabstop = 2
set.termguicolors = true
set.title = true
set.ttimeoutlen = 0
set.updatetime = 250
set.wildmenu = true
set.wrap = true

---------------------------------
-- Formatação
---------------------------------
local diagnostics = require("null-ls").builtins.diagnostics
local formatting = require("null-ls").builtins.formatting
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- require("null-ls").setup({
--   sources = {
--     formatting.black,
--     formatting.rustfmt,
--     formatting.phpcsfixer,
--     formatting.prettier,
--     formatting.stylua,
--   },
--   on_attach = function(client, bufnr)
--     if client.name == "tsserver" or client.name == "rust_analyzer" or client.name == "pyright" then
--       client.resolved_capabilities.document_formatting = false
--     end
-- 
--     if client.supports_method("textDocument/formatting") then
--       vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
--       vim.api.nvim_create_autocmd("BufWritePre", {
--         group = augroup,
--         -- buffer = bufnr,
--         callback = function()
--           vim.lsp.buf.formatting_sync()
--         end,
--     })
--     end
--   end,
-- })

---------------------------------
-- Auto commands
---------------------------------
-- vim.cmd([[ autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync() ]])

---------------------------------
-- Auto-completar
---------------------------------
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})

-- Configuração para tipos específicos de arquivo
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" },
  }, {
    { name = "buffer" },
  }),
})

-- Auto-completar do modo de comando
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer" } },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

---------------------------------
-- Servidores de lingugem
---------------------------------
local lspconfig = require("lspconfig")
local caps = vim.lsp.protocol.make_client_capabilities()
local no_format = function(client, bufnr)
  client.resolved_capabilities.document_formatting = false
end

-- Capabilities
caps.textDocument.completion.completionItem.snippetSupport = true

-- Python
lspconfig.pylsp.setup {
on_attach = custom_attach,
settings = {
    pylsp = {
    plugins = {
        -- formatter options
        black = { enabled = true },
        autopep8 = { enabled = true },
        yapf = { enabled = false },
        -- linter options
        pylint = { enabled = true, executable = "pylint" },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        -- type checker
        pylsp_mypy = { enabled = true },
        -- auto-completion options
        jedi_completion = { fuzzy = true },
        -- import sorting
        pyls_isort = { enabled = true },
    },
    },
},
flags = {
    debounce_text_changes = 200,
},
capabilities = capabilities,
}

-- Rust
lspconfig.rust_analyzer.setup({
  capabilities = snip_caps,
  on_attach = no_format
})

-- Emmet
lspconfig.emmet_ls.setup({
	capabilities = snip_caps,
	filetypes = {
		"css",
		"html",
		"javascriptreact",
		"less",
		"sass",
		"scss",
		"typescriptreact",
	},
})

---------------------------------
-- Atalhos de teclado
---------------------------------
local map = vim.api.nvim_set_keymap
local kmap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader
vim.g.mapleader = " "

-- Vim
map("n", "<F5>", ":Neotree toggle<CR>", opts)
map("n", "<C-q>", ":q!<CR>", opts)
map("n", "<F4>", ":bd<CR>", opts)
map("n", "<F6>", ":sp<CR>:terminal<CR>", opts)
map("n", "<S-Tab>", "gT", opts)
map("n", "<Tab>", "gt", opts)
map("n", "<silent> <Tab>", ":tabnew<CR>", opts)
map("n", "<C-p>", ':lua require("telescope.builtin").find_files()<CR>', opts)
map('n', '<C-s>', ':w<CR>', opts)

-- Diagnóstico
kmap("n", "<space>e", vim.diagnostic.open_float, opts)
kmap("n", "[d", vim.diagnostic.goto_prev, opts)
kmap("n", "]d", vim.diagnostic.goto_next, opts)
kmap("n", "<space>q", vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  -- Habilitar auto-completar com <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")



  -- Mapeamentos.
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  kmap("n", "gD", vim.lsp.buf.declaration, bufopts)
  kmap("n", "gd", vim.lsp.buf.definition, bufopts)
  kmap("n", "K", vim.lsp.buf.hover, bufopts)
  kmap("n", "gi", vim.lsp.buf.implementation, bufopts)
  kmap("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  kmap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  kmap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  kmap("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  kmap("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
  kmap("n", "<space>rn", vim.lsp.buf.rename, bufopts)
  kmap("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
  kmap("n", "gr", vim.lsp.buf.references, bufopts)
  kmap("n", "<space>f", vim.lsp.buf.formatting, bufopts)
end



---------------------------------
-- Mensagem flutuante
---------------------------------
vim.diagnostic.config({
  float = { source = "always", border = border },
  virtual_text = false,
  signs = true,
})

---------------------------------
-- Auto commands
---------------------------------
vim.cmd([[ autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])


------------------------
-- keymap

-- themes
-- Load the colorscheme
-- vim.g.substrata_transparent = true-- Example config in lua
-- vim.g.substrata_italic_functions = true
-- vim.g.substrata_italic_variables = true
-- vim.cmd [[colorscheme substrata]]

-- vim.cmd [[colorscheme rosebones]]
vim.cmd("colorscheme kanagawa-paper")

require('kanagawa-paper').setup({
  undercurl = true,
  transparent = true,
  gutter = false,
  dimInactive = true, -- disabled when transparent
  terminalColors = true,
  commentStyle = { italic = true },
  functionStyle = { italic = false },
  keywordStyle = { italic = false, bold = false },
  statementStyle = { italic = false, bold = false },
  typeStyle = { italic = false },
  colors = { theme = {}, palette = {} }, -- override default palette and theme colors
  overrides = function(colors)  -- override highlight groups
    local theme = colors.theme 
    return {
      NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 }
    }
  end,
})

-- setup must be called before loading
vim.cmd("colorscheme kanagawa-paper")

