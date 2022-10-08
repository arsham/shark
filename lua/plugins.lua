-- Packer setup {{{3
-- stylua: ignore start
local packer_bootstrap = false
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
    "git", "clone", "--depth", "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end
-- stylua: ignore end

vim.api.nvim_command("packadd packer.nvim")

-- Disables LSP plugins and other heavy plugins.
local function full_start()
  return not vim.env.NVIM_START_LIGHT
end
local function lsp_enabled()
  return not vim.env.NVIM_STOP_LSP
end
-- }}}

local packer = require("packer")

-- stylua: ignore start
packer.startup({
  function(use)
    -- Libraries {{{
    use({
      "wbthomason/packer.nvim",
      event = "VimEnter",
    })
    use("nvim-lua/plenary.nvim")
    use({
      "arsham/arshlib.nvim",
      requires = { "plenary.nvim", "nui.nvim" },
    })
    use_rocks({ "bk-tree" })
    -- }}}

    -- Core/System utilities {{{
    use("nathom/filetype.nvim")

    use({
      "junegunn/fzf",
      event = "User LoadTicker1",
    })

    use({
      "junegunn/fzf.vim",
      requires = "fzf",
      event    = "User LoadTicker1",
    })

    use({
      "arsham/fzfmania.nvim",
      requires = {
        "arshlib.nvim",
        "fzf.vim",
        "plenary.nvim",
        {
          "ibhagwan/fzf-lua",
          event    = "User LoadTicker1",
          requires = { "kyazdani42/nvim-web-devicons" },
        },
      },
      after    = { "listish.nvim", "fzf-lua" },
      config   = function() require("settings.fzfmania") end,
      event    = "User LoadTicker1",
    })

    use({
      "kevinhwang91/nvim-bqf",
      requires = { "fzf", "nvim-treesitter" },
      config   = function() require("settings.nvim-bqf") end,
      ft       = { "qf" },
      cond     = full_start,
    })

    use({
      "arsham/listish.nvim",
      requires = { "arshlib.nvim" },
      event    = "User LoadTicker3",
      config   = function()
        require("listish").config({})
        vim.api.nvim_command("packadd! cfilter")
      end,
    })

    use({
      "tweekmonster/startuptime.vim",
      cmd = { "StartupTime" },
    })

    use({
      "gelguy/wilder.nvim",
      config = function() require("settings.wilder") end,
      run    = ":UpdateRemotePlugins",
      event  = "CmdlineEnter",
    })
    -- }}}

    -- Navigation {{{
    use({
      "kyazdani42/nvim-tree.lua",
      requires = { "nvim-web-devicons" },
      config   = function() require("settings.nvim_tree") end,
      cmd      = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile" },
      keys     = { "<leader>kk", "<leader>kf", "<leader><leader>" },
      event    = { "User LoadTicker3" },
    })

    use({
      "numToStr/Navigator.nvim",
      config = function() require("settings.navigator") end,
      event  = { "User LoadTicker2" },
    })

    use({
      "mbbill/undotree",
      config = function() require("settings.undotree") end,
      branch = "search",
      cmd    = { "UndotreeShow", "UndotreeToggle" },
      keys   = { "<leader>u" },
    })

    use({
      "dhruvasagar/vim-zoom",
      config = function()
        vim.keymap.set("n", "<C-W>z", "<Plug>(zoom-toggle)")
      end,
      keys  = { "<C-w>z" },
    })
    -- }}}

    -- git {{{
    use({
      "tpope/vim-fugitive",
      config = function() require("settings.fugitive") end,
      requires = {
        "tpope/vim-git",
        "tpope/vim-rhubarb",
      },
    })

    use({
      "lewis6991/gitsigns.nvim",
      requires = "plenary.nvim",
      config   = function() require("settings.gitsigns") end,
      event    = { "User LoadTicker2" },
      cond     = full_start,
    })

    use({
      -- create ~/.gist-vim with this content: token xxxxx
      "mattn/vim-gist",
      requires = {
        { "mattn/webapi-vim", opt = true },
      },
      wants = "webapi-vim",
      config = function()
        vim.g.gist_per_page_limit = 100
      end,
      cmd = { "Gist" },
    })
    -- }}}

    -- Visuals {{{
    use({
      "arsham/arshamiser.nvim",
      requires = {
        "rebelot/heirline.nvim",
        "arshlib.nvim",
        "nvim-web-devicons",
        "sqls.nvim",
        "fidget.nvim",
        {
          "feline-nvim/feline.nvim",
          after = "nvim-web-devicons",
        },
      },
      config = function() require("settings.arshamiser") end,
      event = { "UIEnter" },
    })

    use({
      "arsham/matchmaker.nvim",
      requires = { "arshlib.nvim", "fzf", "fzf.vim" },
      after    = { "arshlib.nvim" },
      config   = function() require("matchmaker").config({}) end,
      keys     = { "<leader>me", "<leader>ma", "<leader>ml", "<leader>mp" },
      cond     = full_start,
    })

    use({
      "kyazdani42/nvim-web-devicons",
      event = "UIEnter",
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
      config = function() require("settings.nvim-notify") end,
      event  = "UIEnter",
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

    use({
      "SmiteshP/nvim-navic",
      requires = {
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
        "feline-nvim/feline.nvim",
      },
      config = function () require("settings.nvim-navic") end,
      event  = { "LspAttach" },
    })
    -- }}}

    -- Editing {{{
    use({
      "arsham/yanker.nvim",
      config   = function() require("yanker").config({}) end,
      requires = { "arshlib.nvim", "fzf", "fzf.vim" },
      after    = { "arshlib.nvim" },
      event    = {"User LoadTicker3"},
      cond     = full_start,
    })

    use({
      "tpope/vim-repeat",
      event = { "BufReadPost", "BufNewFile" },
    })

    use({
      "vim-scripts/visualrepeat",
      requires = { "inkarkat/vim-ingo-library" },
      event    = { "BufReadPost", "BufNewFile" },
      cond     = full_start,
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
      "mg979/vim-visual-multi",
      branch = "master",
      config = function() require("settings.visual_multi") end,
      keys   = { "<C-n>", "<C-Down>", "<C-Up>" },
      cond   = full_start,
    })

    use({
      "gbprod/substitute.nvim",
      config = function() require("settings.substitute-nvim") end,
      keys = { { "n", "cx" }, { "n", "cxx" }, { "v", "X" } },
    })

    use({
      "windwp/nvim-autopairs",
      wants  = { "nvim-cmp", "nvim-treesitter" },
      after  = { "nvim-cmp", "nvim-treesitter" },
      config = function() require("settings.autopairs") end,
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
      "svban/YankAssassin.vim",
      event    = {"User LoadTicker3"},
      cond  = full_start,
    })

    use({
      "andymass/vim-matchup",
      config = function() require("settings.vim-matchup") end,
      event  = { "BufReadPost", "BufNewFile" },
      cond   = full_start,
    })

    use({
      "monaqa/dial.nvim",
      config = function() require("settings.dial-nvim") end,
      keys = {
        { "n", "<C-a>" }, { "n", "<C-x>" },
        { "v", "<C-a>" }, { "v", "<C-x>" },
        { "v", "g<C-a>" }, { "v", "g<C-x>" },
      },
      cond = full_start,
    })
    -- }}}

    -- Programming {{{
    -- LSP {{{
    use({
      "williamboman/mason.nvim",
      {
        "williamboman/mason-lspconfig.nvim",
      },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
      },
      {
        "neovim/nvim-lspconfig",
        config = function()
          require("settings.mason-nvim")
          require("settings.lsp")
        end,
        wants = {
          "cmp-nvim-lsp",
          "fzf-lua",
          "lua-dev.nvim",
          "null-ls.nvim",
        },
        after = {
          "cmp-nvim-lsp",
          "fzf-lua",
          "lua-dev.nvim",
          "null-ls.nvim",
        },
        event = { "User LoadTicker1" },
        cond  = { full_start, lsp_enabled },
      },
      after = {
        "cmp-nvim-lsp",
        "null-ls.nvim",
        "nvim-lspconfig",
      },
      wants = {
        "cmp-nvim-lsp",
        "null-ls.nvim",
        "nvim-lspconfig",
      },
      cond  = { full_start, lsp_enabled },
    })

    use({
      "j-hui/fidget.nvim",
      config = function() require("settings.fidget-nvim") end,
      event  = { "LspAttach" },
    })

    use({
      "jose-elias-alvarez/null-ls.nvim",
      requires = { "plenary.nvim", "nvim-lspconfig" },
      event = { "User LoadTicker3" },
      cond     = { full_start, lsp_enabled },
    })

    use({
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function() require("settings.lsp_lines-nvim") end,
      event  = { "LspAttach" },
    })
    --}}}

    -- CMP {{{
    use({
      "hrsh7th/nvim-cmp",
      requires = {
        { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
        { "hrsh7th/cmp-buffer",   after = "nvim-cmp" },
        { "hrsh7th/cmp-path",     after = "nvim-cmp" },
        { "hrsh7th/cmp-cmdline",  after = "nvim-cmp" },
        { "hrsh7th/cmp-calc",     after = "nvim-cmp" },
        { "lukas-reineke/cmp-rg", after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
        {
          "L3MON4D3/LuaSnip",
          requires = { "rafamadriz/friendly-snippets" },
          config   = function() require("settings.luasnip") end,
          -- TODO: find a better event for this. Removing causes a lot of
          -- plugins to load automatically.
          event = { "User LoadTicker1" },
          cond     = { full_start, lsp_enabled },
        },
        { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
      },
      after  = { "LuaSnip", "nvim-treesitter" } ,
      wants  = { "LuaSnip", "nvim-treesitter" } ,
      config = function() require("settings.cmp") end,
      event = { "User LoadTicker1" },
      cond   = { full_start, lsp_enabled },
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
          run   = ":TSInstall query",
          cmd   = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
          cond  = full_start,
        },
        {
          "JoosepAlviste/nvim-ts-context-commentstring",
          after = "nvim-treesitter",
        },
      },
      run = ":TSUpdate",
      cmd = "TSUpdate",
      event = { "User LoadTicker2", "BufReadPost", "BufNewFile" },
    })
    -- }}}

    use({
      "sheerun/vim-polyglot",
      event = { "User LoadTicker2", "BufReadPost", "BufNewFile" },
      cond  = full_start,
    })

    use({
      "folke/lua-dev.nvim",
      ft = { "lua" },
      cond  = { full_start, lsp_enabled },
    })

    use({
      "bfredl/nvim-luadev",
      config = function() require("settings.nvim-luadev") end,
      cmd    = { "Luadev" },
      cond   = { full_start, lsp_enabled },
    })

    use({
      "milisims/nvim-luaref",
      ft   = { "lua" },
      cond = full_start,
    })

    use({
      "ray-x/go.nvim",
      config = function() require("settings.go-nvim") end,
      ft     = { "go" },
      cond   = { full_start, lsp_enabled },
    })

    use({
      "numToStr/Comment.nvim",
      requires = { "nvim-ts-context-commentstring", "nvim-treesitter" },
      after    = { "nvim-ts-context-commentstring", "nvim-treesitter" },
      config   = function() require("settings.comment") end,
    })

    use({
      "nanotee/sqls.nvim",
      config = function() require("settings.sqls") end,
      wants  = { "nvim-lspconfig" },
      ft     = { "sql" },
      cond   = { full_start, lsp_enabled },
    })

    use({
      "towolf/vim-helm",
      ft = { "yaml" },
    })

    -- DAP {{{
    use({
      "mfussenegger/nvim-dap",
      requires = {
        {
          "rcarriga/nvim-dap-ui",
          opt = true,
        },
        {
          "jbyuki/one-small-step-for-vimkind",
          opt = true,
        },
        {
          "theHamsta/nvim-dap-virtual-text",
          opt = true,
        },
        {
          "leoluz/nvim-dap-go",
          config = function() require('dap-go').setup() end,
          wants  = { "nvim-dap" },
          after  = { "nvim-dap" },
          opt = true,
        },
      },
      config = function() require("settings.nvim-dap") end,
      wants  = { "nvim-dap-ui", "nvim-dap-virtual-text" },
      after  = { "nvim-dap-ui", "nvim-dap-virtual-text" },
      cond   = { full_start, lsp_enabled },
      keys   = { "<leader>db", "<leader>dB", "<leader>dl" },
    }) --}}}
    -- }}}

    -- Text objects {{{
    use({
      "arsham/indent-tools.nvim",
      requires = { "arshlib.nvim" },
      config   = function() require("indent-tools").config({}) end,
      event    = { "User LoadTicker3" },
      cond     = full_start,
    })

    use({
      "arsham/archer.nvim",
      requires = { "arsham/arshlib.nvim", "tpope/vim-repeat" },
      config   = function() require("archer").config({}) end,
      event    = { "User LoadTicker2" },
    })

    use({
      "echasnovski/mini.nvim",
      config = function() require("settings.mini-nvim") end,
      event  = { "User LoadTicker2" },
      cond   = full_start,
    })

    use({
      "glts/vim-textobj-comment",
      requires = "vim-textobj-user",
      after    = "vim-textobj-user",
    })

    use({
      "kana/vim-textobj-user",
      event = { "User LoadTicker2" },
    })

    use({
      "ralismark/opsort.vim",
      setup = function ()
        vim.g.opsort_no_mappings = true
      end,
      config = function ()
        vim.keymap.set("x", "gso", "<plug>Opsort", {silent = true})
        vim.keymap.set("n", "gso", "<plug>Opsort", {silent = true})
        vim.keymap.set("n", "gsoo", "<plug>OpsortLines", {silent = true})
      end,
      event = { "User LoadTicker3" },
    })
    -- }}}

    -- Misc {{{
    use({
      "iamcco/markdown-preview.nvim",
      run    = function() vim.fn["mkdp#util#install"]() end,
      setup  = function() vim.g.mkdp_filetypes = { "markdown" } end,
      config = function() vim.g.mkdp_browser = "firefox" end,
      ft     = { "markdown" },
      cond   = full_start,
    })

    use({
      "tmux-plugins/vim-tmux",
      ft = "tmux",
    })

    use({
      -- creates diagrams from text. Requires diagon from snap.
      "willchao612/vim-diagon",
      cmd = "Diagon",
      cond = full_start,
    })

    use({
      "jbyuki/venn.nvim",
      config = function() require("settings.venn") end,
      keys   = { "<leader>v" },
      cond   = full_start,
    })

    use({
      "nvim-neorg/neorg",
      config = function() require("settings.neorg") end,
      wants  = { "nvim-treesitter", "nvim-lspconfig", "nvim-cmp" },
      cmd    = { "NeorgStart" },
      keys   = { "<leader>oo" },
      event  = { "User LoadTicker3" },
    })
    -- }}}

    if packer_bootstrap then -- {{{
      packer.sync()
    end
  end,
  config = {
    log = { level = "info" },
    auto_clean = true,
    auto_reload_compiled = true,
    autoremove = false,
    ensure_dependencies = true,
    compile_on_sync = true,
    display = {
      non_interactive = false,
      header_lines = 2,
      title = " packer.nvim",
      working_sym = " ",
      error_sym = "",
      done_sym = "",
      removed_sym = "",
      moved_sym = " ",
      show_all_info = true,
      prompt_border = "rounded",
      open_cmd = "tabedit",
      keybindings = {
        prompt_revert = "R",
        diff = "D",
        retry = "r",
        quit = "q",
        toggle_info = "<CR>",
      },
      open_fn = function()
        return require("packer.util").float({ border = "rounded" })
      end,
    },

    compile_path = vim.fn.stdpath("config") .. "/plugin/packer_compiled.lua",
  },
  -- }}}
})
-- stylua: ignore end

-- vim: fdm=marker fdl=2
