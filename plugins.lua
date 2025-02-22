local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	use ("wbthomason/packer.nvim") -- Have packer manage itself	



	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end

	use {'kdheepak/monochrome.nvim', config = function()
   	 vim.cmd 'colorscheme monochrome' end}

	  packer.startup(function()
	  -- Auto-completar
	  use("hrsh7th/cmp-buffer")
	  use("hrsh7th/cmp-cmdline")
	  use("hrsh7th/cmp-nvim-lsp")
	  use("hrsh7th/cmp-path")
	  use("hrsh7th/nvim-cmp")
	  -- Motor de snippets
	  use("L3MON4D3/LuaSnip")
	  use("saadparwaiz1/cmp_luasnip")
	  -- Formatação
	  use("jose-elias-alvarez/null-ls.nvim")
	  -- Servidor de linguagens
	  use("neovim/nvim-lspconfig")
	  use("williamboman/nvim-lsp-installer")
	  -- Analisador de sintaxe
	  use("nvim-treesitter/nvim-treesitter")
	  -- Gerenciador de plugins
	  use("wbthomason/packer.nvim")
	  -- Utilitários
	  use("windwp/nvim-autopairs")
	  use("norcalli/nvim-colorizer.lua")
	  use("lewis6991/gitsigns.nvim")
	  -- Dependências
	  use("nvim-lua/plenary.nvim")
	  use("kyazdani42/nvim-web-devicons")
	  use("MunifTanjim/nui.nvim")
	  -- Navegador de arquivos
	  use("nvim-telescope/telescope.nvim")
	  -- Interface
	  use("akinsho/bufferline.nvim")
	  use({ "nvim-neo-tree/neo-tree.nvim", branch = "v2.x" })
	  use("nvim-lualine/lualine.nvim")
	  end)
	  -- tema
	  -- use{'kdheepak/monochrome.nvim', config = function()
    --	 vim.cmd 'colorscheme monochrome'end}
    use{'kvrohit/substrata.nvim'}

    use {'thesimonho/kanagawa-paper.nvim'}

    -- Lua

    use { 
      'olivercederborg/poimandres.nvim',
      config = function()
        require('poimandres').setup {
            bold_vert_split = false, -- use bold vertical separators
            dim_nc_background = false, -- dim 'non-current' window backgrounds
            disable_background = true, -- disable background
            disable_float_background = false, -- disable background for floats
            disable_italics = true, -- disable italics
        }
      end
    }

    use { "rose-pine/neovim", as = "rose-pine" }
    use {"oahlen/iceberg.nvim"}
    use {"neg-serg/neg.nvim"}
    use {'ccxnu/rosebones'}
    use {'lpuljic/nox-modus.nvim'}
    use {"yorumicolors/yorumi.nvim"}
    -- neo-tree
	  use {
 	 	"nvim-neo-tree/neo-tree.nvim",
 	 	  branch = "v3.x",
 	 	  requires = { 
 	 	    "nvim-lua/plenary.nvim",
 	 	    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
 	 	    "MunifTanjim/nui.nvim",
 	 	    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
 	 	  }
 	 }
end)



