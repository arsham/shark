local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    vim.cmd [[packadd packer.nvim]]
end

vim.cmd [[packadd! cfilter]]

-- Auto compile when there are changes in plugins.lua
vim.cmd [[
augroup PACKER_RELOAD
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup END
]]

local lspFiletypes = {
    'go',
    'lua',
    'vim',
    'sql',
    'bash',
    'py',
    'html',
    'yaml',
    'json',
    'js',
}

local status_plugin = 'feline'

require('packer').startup({
    function(use)

        -- {{{ Libraries
        use 'wbthomason/packer.nvim'
        use 'tjdevries/astronauta.nvim'
        use 'nvim-lua/plenary.nvim'
        -- }}}

        -- {{{ Core/System utilities
        use {
            'junegunn/fzf.vim',
            requires = { 'junegunn/fzf' },
            config   = function() require('settings.fzf') end,
        }

        use {
            'kevinhwang91/nvim-bqf',
            requires = {
                'junegunn/fzf',
                {
                    'nvim-treesitter/nvim-treesitter',
                    branch = '0.5-compat',
                },
            },
            config = function() require('bqf').enable() end,
            event = { 'BufWinEnter quickfix' },
        }

        use {
            'kyazdani42/nvim-tree.lua',
            requires = { 'kyazdani42/nvim-web-devicons' },
            setup    = function() require('settings').nvim_tree.setup() end,
            config   = function() require('settings').nvim_tree.config() end,
            event    = { 'BufRead' },
            cmd      = { 'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFindFile' },
            keys     = { '<leader>kb', '<leader>kf' },
        }

        use {
            'tweekmonster/startuptime.vim',
            -- 'dstein64/vim-startuptime',
            cmd = { 'StartupTime' },
        }

        -- { 'norcalli/profiler.nvim', },

        use {
            'gelguy/wilder.nvim',
            config = function() require('settings.wilder') end,
            run    = ':UpdateRemotePlugins',
        }

        use {
            'numToStr/Navigator.nvim',
            config = function() require('settings').navigator() end,
        }
        -- }}}

        -- {{{ git
        use {
            'tpope/vim-fugitive',
            config = function() require('settings').fugitive() end,
            event  = { 'BufNewFile', 'BufRead' },
            cmd    = { 'G', 'Git' },
            keys   = { '<leader>gs' },
        }

        use {
            'lewis6991/gitsigns.nvim',
            requires = { 'nvim-lua/plenary.nvim' },
            config   = function() require('settings.gitsigns') end,
            event    = { 'BufNewFile', 'BufRead' },
        }

        use {
            -- create ~/.gist-vim with this content: token xxxxx
            'mattn/vim-gist',
            requires = { 'mattn/webapi-vim' },
            config   = function()
                vim.g.gist_per_page_limit = 100
            end,
            cmd      = { 'Gist' },
        }
        -- }}}

        -- {{{ Visuals
        use 'kyazdani42/nvim-web-devicons'

        use {
            'glepnir/galaxyline.nvim',
            branch = 'main',
            cond   = status_plugin == 'galaxyline',
            config = function() require('statusline.galaxyline') end,
        }

        use {
            'famiu/feline.nvim',
            cond   = status_plugin == 'feline',
            config = function() require('statusline.feline') end,
        }

        use {
            'dhruvasagar/vim-zoom',
            config = function()
                vim.keymap.nmap{ '<C-W>z', '<Plug>(zoom-toggle)' }
            end,
            event = { 'BufRead', 'BufNewFile' },
            keys  = { '<C-w>z' },
        }

        use {
            'norcalli/nvim-colorizer.lua',
            config = function()
                require'colorizer'.setup{ 'css', 'scss', 'sass', 'html', 'lua' }
            end,
            event = { 'BufRead', 'BufNewFile' },
        }

        use {
            'rcarriga/nvim-notify',
            config = function()
                local async_load_plugin = nil
                async_load_plugin = vim.loop.new_async(vim.schedule_wrap(function()
                    vim.notify = require("notify")
                    async_load_plugin:close()
                end))
                async_load_plugin:send()
            end,
        }

        use 'MunifTanjim/nui.nvim'

        use {
            'lukas-reineke/indent-blankline.nvim',
            config = function()
                require("indent_blankline").setup {
                    show_trailing_blankline_indent = false,
                    show_first_indent_level = false,
                }
            end,
            event = { 'BufRead', 'BufNewFile' },
        }

        use {
            'stevearc/dressing.nvim',
            config = function() require('settings').dressing() end,
        }
        -- }}}

        -- {{{ Editing
        use {
            'numToStr/Comment.nvim',
            config = function() require('Comment').setup() end,
            event  = { 'BufRead', 'BufNewFile', 'InsertEnter' },
        }

        use {
            'tpope/vim-repeat',
            event = { 'BufRead', 'BufNewFile', 'InsertEnter' },
        }

        use {
            'bronson/vim-trailing-whitespace',
            event = { 'BufRead', 'BufNewFile', 'InsertEnter' },
        }

        use {
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
            'arthurxavierx/vim-caser',
            event = { 'BufRead', 'BufNewFile', 'InsertEnter' },
        }

        use {
            'junegunn/vim-easy-align',
            config = function()
                vim.keymap.xmap{'ga', '<Plug>(EasyAlign)'}
                vim.keymap.nmap{'ga', '<Plug>(EasyAlign)'}
            end,
            keys = { 'ga' },
        }

        use {
            'mg979/vim-visual-multi',
            branch = 'master',
            config = function() require('settings').visual_multi() end,
            event  = { 'BufRead', 'BufNewFile', 'InsertEnter' },
        }

        use {
            'tommcdo/vim-exchange',
            keys = { {'n', 'cx'}, {'v', 'X'} },
        }

        use {
            'windwp/nvim-autopairs',
            wants  = "nvim-cmp",
            config = function() require('settings').autopairs() end,
            event  = { 'InsertEnter' },
        }

        use({
            'sQVe/sort.nvim',
            config = function()
                require("sort").setup({
                    delimiters = {
                        ',', '|', ';', ':',
                        's', -- Space
                        't'  -- Tab
                    },
                })
            end,
            cmd = { 'Sort' },
        })
        -- }}}

        -- {{{ Programming
        use {
            'neovim/nvim-lspconfig',
            after = "nvim-cmp",
        }

        use {
            'williamboman/nvim-lsp-installer',
            config = function()
                require('settings').lsp_installer()
                require('settings.lsp')
            end,
            after = 'nvim-lspconfig',
        }

        use {
            'hrsh7th/nvim-cmp',
            config = function() require('settings.cmp') end,
            event = { 'BufRead', 'BufNewFile', 'InsertEnter' },
            requires = {
                { 'hrsh7th/cmp-nvim-lsp'  , after = 'nvim-cmp' },
                { 'hrsh7th/cmp-nvim-lua'  , after = 'nvim-cmp' },
                { 'hrsh7th/cmp-buffer'    , after = 'nvim-cmp' },
                { 'hrsh7th/cmp-path'      , after = 'nvim-cmp' },
                { 'hrsh7th/cmp-cmdline'   , after = 'nvim-cmp' },
                { 'hrsh7th/cmp-calc'      , after = 'nvim-cmp' },
                { "lukas-reineke/cmp-rg"  , after = 'nvim-cmp' },
                -- { 'hrsh7th/cmp-copilot'   , after = 'nvim-cmp' },
                { 'hrsh7th/cmp-nvim-lsp-signature-help' , after = 'nvim-cmp' },
                { 'hrsh7th/cmp-vsnip'     , after = 'nvim-cmp' },
                { 'hrsh7th/vim-vsnip',
                    config = function ()
                        vim.g.vsnip_snippet_dir = vim.env.HOME .. "/.config/nvim/vsnip"
                    end,
                    after = 'nvim-cmp',
                },
            }
        }

        use {
            'dense-analysis/ale',
            config = function() require('settings.ale') end, opt = true,
            ft     = lspFiletypes,
        }

        use {
            'ojroques/nvim-lspfuzzy',
            requires = {
                { 'junegunn/fzf' },
                { 'junegunn/fzf.vim' },
            },
            config = function()
                require('lspfuzzy').setup{
                    fzf_preview = {
                        'right:60%:+{2}-/2,nohidden',
                    },
                }
            end,
            after = {"nvim-lspconfig", "fzf.vim"},
        }

        use {
            'nvim-treesitter/nvim-treesitter',
            branch = '0.5-compat',
            requires = {
                {
                    'nvim-treesitter/nvim-treesitter-refactor',
                    after = 'nvim-treesitter',
                    config = function() require('settings').treesitter_refactor() end,
                },
                {
                    'nvim-treesitter/nvim-treesitter-textobjects',
                    branch = '0.5-compat',
                    after = 'nvim-treesitter',
                },
            },
            config = function() require('settings.treesitter') end,
            run = ':TSUpdate',
            event = { 'BufRead', 'BufNewFile', 'InsertEnter' },
        }

        use {
            'David-Kunz/treesitter-unit',
            wants  = 'nvim-treesitter',
            config = function() require('settings').treesitter_unit() end,
            after  = 'nvim-treesitter',
        }

        use {
            'github/copilot.vim',
            config = function () require('settings').copilot() end,
            event  = { 'BufRead', 'BufNewFile', 'InsertEnter' },
        }

        use {
            'uarun/vim-protobuf',
            ft = { 'proto' },
        }

        use {
            'towolf/vim-helm',
            ft = { 'yaml' },
        }
        -- }}}

        -- {{{ Text objects
        use {
            'blackCauldron7/surround.nvim',
            config = function() require('settings').surround() end,
            event  = { 'BufRead', 'BufNewFile', 'InsertEnter' },
        }

        use {
            'glts/vim-textobj-comment',
            wants = 'vim-textobj-user',
            requires = {
                'kana/vim-textobj-user',
                opt = true,
                event = { 'BufRead', 'BufNewFile' },
            },
            opt = true,
            event = { 'BufRead', 'BufNewFile' },
        }
        -- }}}

        -- {{{ Misc
        use {
            "iamcco/markdown-preview.nvim",
            run = function()
                vim.fn["mkdp#util#install"]()
                -- couln't make this work.
                -- vim.cmd[[cd app && npm -g install --prefix ~/.node_modules]]
            end,
            setup  = function() vim.g.mkdp_filetypes = { "markdown" } end,
            config = function()
                vim.g.mkdp_browser = 'brave'
            end,
            ft = { "markdown" },
        }
        -- }}}

    end,
    config = {
        log = { level = 'info' },
        display = {
            open_fn = function()
                return require('packer.util').float({ border = 'single' })
            end
        }
    },
})

--- vim: foldmethod=marker
