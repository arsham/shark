-- Packer setup {{{3
-- stylua: ignore start
vim.opt.termguicolors = true
pcall(require, "impatient")
local packer_bootstrap = false
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
    "git", "clone", "--depth", "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

vim.cmd([[packadd packer.nvim]])
vim.cmd([[packadd! cfilter]])

-- Disables LSP plugins and other heavy plugins.
local function full_start()
  return not vim.env.NVIM_START_LIGHT
end
-- }}}

-- Plugins {{{2
require("packer").startup({
  function(use)
    -- Libraries {{{
    use({
      "wbthomason/packer.nvim",
      event = "VimEnter",
    })
    use("nvim-lua/plenary.nvim")
    use("norcalli/nvim.lua")
    use({
      "arsham/arshlib.nvim",
      requires = { "nvim.lua", "plenary.nvim", "nui.nvim" },
    })

    -- }}}

    -- Core/System utilities {{{
    use("nathom/filetype.nvim")
    use("lewis6991/impatient.nvim")

    use({
      "junegunn/fzf",
      event = "VimEnter",
    })

    use({
      "junegunn/fzf.vim",
      requires = "fzf",
      config   = function() require("settings.fzf") end,
      event    = "VimEnter",
    })

    use({
      "kevinhwang91/nvim-bqf",
      requires = { "fzf", "nvim-treesitter",
      },
      config = function() require("bqf").enable() end,
      ft   = { "qf" },
      cond = full_start,
    })

    use({
      "arsham/listish.nvim",
      requires = { "arshlib.nvim", "nvim.lua" },
      config = function() require("listish").config({}) end,
      keys = {
        "<leader>qq", "<leader>qn", "<leader>qo",
        "<leader>ww", "<leader>wn", "<leader>wo",
      },
      ft = { "qf" },
    })

    use({
      "kyazdani42/nvim-tree.lua",
      requires = { "nvim-web-devicons" },
      setup    = function() require("settings.nvim_tree").setup() end,
      config   = function() require("settings.nvim_tree").config() end,
      event    = { "BufRead" },
      cmd      = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile" },
      keys     = { "<leader>kk", "<leader>kf", "<leader><leader>" },
    })

    use({
      "tweekmonster/startuptime.vim",
      cmd = { "StartupTime" },
    })

    use({
      "gelguy/wilder.nvim",
      config = function() require("settings.wilder") end,
      run    = ":UpdateRemotePlugins",
      event  = "VimEnter",
    })

    use({
      "numToStr/Navigator.nvim",
      config = function() require("settings.navigator") end,
      event  = "UIEnter",
    })

    use({
      "mbbill/undotree",
      config = function() require("settings.undotree") end,
      branch = "search",
      cmd    = { "UndotreeShow", "UndotreeToggle" },
      keys   = { "<leader>u" },
    })
    -- }}}

    -- git {{{
    use({
      "tpope/vim-fugitive",
      config = function() require("settings.fugitive") end,
    })

    use({
      "tpope/vim-rhubarb",
      requires = "vim-fugitive",
      after    = "vim-fugitive",
    })

    use({
      "lewis6991/gitsigns.nvim",
      requires = "plenary.nvim",
      config   = function() require("settings.gitsigns") end,
      event    = { "BufNewFile", "BufRead" },
    })

    use({
      -- create ~/.gist-vim with this content: token xxxxx
      "mattn/vim-gist",
      requires = "mattn/webapi-vim",
      config   = function() vim.g.gist_per_page_limit = 100 end,
      cmd      = { "Gist" },
    })
    -- }}}

    -- Visuals {{{
    use({
      "arsham/arshamiser.nvim",
      requires = { "arshlib.nvim", "nvim.lua", "feline.nvim", "nvim-web-devicons", "lsp-status.nvim" },
      config = function() require("settings.arshamiser") end,
      event = { "VimEnter" },
    })

    use({
      "arsham/matchmaker.nvim",
      requires = { "arshlib.nvim", "fzf", "fzf.vim" },
      config = function() require("matchmaker").config({}) end,
      keys = { "<leader>me", "<leader>ma", },
    })

    use({
      "kyazdani42/nvim-web-devicons",
      event = "UIEnter",
    })

    use({
      "famiu/feline.nvim",
      after  = "nvim-web-devicons",
    })

    use({
      "dhruvasagar/vim-zoom",
      config = function()
        vim.keymap.set("n", "<C-W>z", "<Plug>(zoom-toggle)" )
      end,
      event = { "BufRead", "BufNewFile" },
      keys = { "<C-w>z" },
    })

    local colorizer_ft = { "css", "scss", "sass", "html", "lua", "markdown" }
    use({
      "norcalli/nvim-colorizer.lua",
      config = function() require("colorizer").setup(colorizer_ft) end,
      ft     = colorizer_ft,
      cond   = full_start,
    })

    use({
      "rcarriga/nvim-notify",
      config = function() require("settings.nvim_notify") end,
      event  = "VimEnter",
    })

    use({
      "MunifTanjim/nui.nvim",
      event = "UIEnter",
    })

    use({
      "stevearc/dressing.nvim",
      config = function() require("settings.dressing") end,
      event  = "UIEnter",
      cond   = full_start,
    })
    -- }}}

    -- Editing {{{

    use({
      "arsham/yanker.nvim",
      -- "~/Projects/arsham/yanker.nvim",
      config = function() require("yanker").config({}) end,
      requires = { "arshlib.nvim", "fzf", "fzf.vim" },
      event = { "BufRead", "BufNewFile" },
      keys = { "<leader>yh", },
    })

    use({
      "tpope/vim-repeat",
      event = { "BufRead", "BufNewFile", "InsertEnter" },
    })

    use({
      "vim-scripts/visualrepeat",
      event = { "BufRead", "BufNewFile", "InsertEnter" },
    })

    use({
      "ntpeters/vim-better-whitespace",
      config = function() require("settings.vim_better_whitespace") end,
      event  = { "BufRead", "BufNewFile", "InsertEnter" },
      cond   = full_start,
    })

    use({
      -- MixedCase/PascalCase:   gsm/gsp
      -- camelCase:              gsc
      -- snake_case:             gs_
      -- UPPER_CASE:             gsu/gsU
      -- Title Case:             gst
      -- Sentence case:          gss
      -- space case:             gs<space>
      -- dash-case/kebab-case:   gs-/gsk
      -- Title-Dash/Title-Kebab: gsK
      -- dot.case:               gs.
      "arthurxavierx/vim-caser",
      keys = { "gs" },
    })

    use({
      "junegunn/vim-easy-align",
      config = function() require("settings.easyalign") end,
      keys   = { "ga" },
    })

    use({
      "mg979/vim-visual-multi",
      branch = "master", config = function() require("settings.visual_multi") end,
      keys   = { "<C-n>", "<C-Down>", "<C-Up>" },
    })

    use({
      "tommcdo/vim-exchange",
      keys = { { "n", "cx" }, { "v", "X" } },
    })

    use({
      "windwp/nvim-autopairs",
      wants  = "nvim-cmp",
      config = function() require("settings.autopairs") end,
      event  = { "InsertEnter" },
    })

    use({
      "sQVe/sort.nvim",
      config = function()
        require("sort").setup({
          delimiters = { ",", "|", ";", ":", "s", "t" },
        })
      end,
      cmd = { "Sort" },
    })

    use({
      "booperlv/nvim-gomove",
      config = function() require("settings.gomove") end,
      event  = { "BufRead", "BufNewFile", "InsertEnter" },
    })

    use({
      "svban/YankAssassin.vim",
      event = { "BufRead", "BufNewFile" },
    })
    -- }}}

    -- Programming {{{

    -- LSP {{{
    use({
      "neovim/nvim-lspconfig",
      after = { "nvim-cmp", "lua-dev.nvim" },
      event = { "BufRead", "BufNewFile", "InsertEnter" },
      cond  = full_start,
    })

    use({
      "williamboman/nvim-lsp-installer",
      config = function()
        require("settings.lsp_installer")
        require("settings.lsp")
      end,
      after = {
        "nvim-lspconfig",
        "nvim-cmp",
        "cmp-nvim-lsp",
        "lsp-status.nvim",
        "cmp-nvim-lsp",
        "null-ls.nvim",
      },
      cmd  = "LspInstallInfo",
      cond = full_start,
    })

    use({
      "nvim-lua/lsp-status.nvim",
      after = { "nvim-lspconfig", "fzf.vim" },
      config = function() require("settings.lspstatus") end,
      event = { "BufRead", "BufNewFile", "InsertEnter" },
      cond = full_start,
    })

    use({
      "jose-elias-alvarez/null-ls.nvim",
      requires = { "plenary.nvim", "nvim-lspconfig" },
      event  = { "BufRead", "BufNewFile", "InsertEnter" },
      cond   = full_start,
    })

    use({
      "ojroques/nvim-lspfuzzy",
      requires = {
        "junegunn/fzf",
        "junegunn/fzf.vim",
        "nvim-lspconfig",
      },
      config = function()
        require("lspfuzzy").setup({
          fzf_preview = {
            "right:60%:+{2}-/2,nohidden",
          },
        })
      end,
      after = { "nvim-lspconfig", "fzf.vim" },
      cond  = full_start,
    })
    --}}}

    -- nvim-cmp {{{
    use({
      "hrsh7th/nvim-cmp",
      event = { "BufRead", "BufNewFile", "InsertEnter" },
      requires = {
        { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
        { "hrsh7th/cmp-buffer",   after = "nvim-cmp" },
        { "hrsh7th/cmp-path",     after = "nvim-cmp" },
        { "hrsh7th/cmp-cmdline",  after = "nvim-cmp" },
        { "hrsh7th/cmp-calc",     after = "nvim-cmp" },
        { "lukas-reineke/cmp-rg", after = "nvim-cmp" },
        { "hrsh7th/cmp-vsnip",    after = "nvim-cmp" },
        {
          "hrsh7th/vim-vsnip",
          after = "nvim-cmp",
          config = function()
            vim.g.vsnip_snippet_dir = vim.env.HOME .. "/.config/nvim/vsnip"
          end,
          requires = "rafamadriz/friendly-snippets",
        },
        { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
      },
      config = function() require("settings.cmp") end,
      cond   = full_start,
    })
    -- }}}

    -- Treesitter {{{
    use({
      "nvim-treesitter/nvim-treesitter",
      requires = {
        {
          "nvim-treesitter/nvim-treesitter-textobjects",
          after = "nvim-treesitter",
          -- This is actually the nvim-treesitter config, but it's
          -- here to make lazy loading happy.
          config = function() require("settings.treesitter") end,
        },
        {
          "nvim-treesitter/nvim-treesitter-refactor",
          after  = "nvim-treesitter",
          config = function() require("settings.treesitter_refactor") end,
        },
        {
          "David-Kunz/treesitter-unit",
          after  = "nvim-treesitter",
          config = function() require("settings.treesitter_unit") end,
        },
        {
          "nvim-treesitter/playground",
          after = "nvim-treesitter",
          run   = ":TSInstall query",
          cmd   = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
          cond  = full_start,
        },
      },
      run = ":TSUpdate",
      cmd = "TSUpdate",
      event = { "BufRead", "BufNewFile", "InsertEnter" },
    })

    use({
      "JoosepAlviste/nvim-ts-context-commentstring",
      requires = "nvim-treesitter",
      after    = "nvim-treesitter",
    })
    -- }}}

    use({
      "folke/lua-dev.nvim",
      event = { "BufRead", "BufNewFile", "InsertEnter" },
      cond  = full_start,
    })

    use({
      "numToStr/Comment.nvim",
      requires = "nvim-ts-context-commentstring",
      after    = "nvim-ts-context-commentstring",
      config   = function() require("settings.comment") end,
    })

    use({
      "github/copilot.vim",
      config = function() require("settings.copilot") end,
      event  = { "InsertEnter" },
      cond   = full_start,
    })

    use({
      "nanotee/sqls.nvim",
      config = function()
        vim.keymap.set("n", "<C-Space>", ":SqlsExecuteQuery<CR>",{noremap=true, buffer = true, silent = true })
        vim.keymap.set("v", "<C-Space>", ":SqlsExecuteQuery<CR>",{noremap=true, buffer = true, silent = true })
      end,
      ft   = { "sql" },
      cond = full_start,
    })

    use({
      "uarun/vim-protobuf",
      ft = { "proto" },
    })

    use({
      "towolf/vim-helm",
      ft = { "yaml" },
    })
    -- }}}

    --- Text objects {{{
    use({
      "blackCauldron7/surround.nvim",
      config = function() require("settings.surround") end,
      event  = { "BufRead", "BufNewFile", "InsertEnter" },
    })

    use({
      "glts/vim-textobj-comment",
      requires = "kana/vim-textobj-user",
      after    = "vim-textobj-user",
    })

    use({
      "kana/vim-textobj-user",
      event = { "BufRead", "BufNewFile" },
    })
    -- }}}

    -- Misc {{{
    use({
      "iamcco/markdown-preview.nvim",
      run    = function() vim.fn["mkdp#util#install"]() end,
      setup  = function() vim.g.mkdp_filetypes = { "markdown" } end,
      config = function() vim.g.mkdp_browser = "brave" end,
      ft     = { "markdown" },
      cond   = full_start,
    })

    use({
      "milisims/nvim-luaref",
      ft   = { "lua" },
      cond = full_start,
    })

    use({
      "tmux-plugins/vim-tmux",
      ft = "tmux",
    })

    use({
      -- creates diagrams from text. Requires diagon from snap.
      "willchao612/vim-diagon",
      cmd = "Diagon",
    })
    --- }}}
    if packer_bootstrap then --- {{{
      require("packer").sync()
    end
  end,
  config = {
    log = { level = "info" },
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "single" })
      end,
    },

    -- Move to lua dir so impatient.nvim can cache it.
    compile_path = vim.fn.stdpath("config") .. "/plugin/packer_compiled.lua",
  },
  -- }}}
})
-- stylua: ignore end

-- vim: fdm=marker fdl=2
