local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    vim.cmd [[packadd packer.nvim]]
end

vim.cmd [[set debug=throw]]
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
}

require('packer').startup({
    function(use)

        --{{{ Libraries }}}
        use {
            {
                'wbthomason/packer.nvim',
            },
            {'tjdevries/astronauta.nvim'},
        }

        --{{{ Core/System utilities }}}
        use {
            {
                'junegunn/fzf.vim',
                requires = { 'junegunn/fzf' },
                config = function()
                    require('settings').fzf()
                end,
            },
            {
                'kevinhwang91/nvim-bqf',
                event = { 'BufWinEnter quickfix' },
                requires = {
                    'junegunn/fzf',
                    'nvim-treesitter/nvim-treesitter',
                    branch = '0.5-compat',
                },
                config = function() require('bqf').enable() end,
            },
            { 'kyazdani42/nvim-web-devicons' },
            {
                'kyazdani42/nvim-tree.lua',
                requires = { 'kyazdani42/nvim-web-devicons', },
                setup = function() require('settings').nvim_tree.setup() end,
                config = function() require('settings').nvim_tree.config() end,
                wants = 'nvim-web-devicons',
                cmd = { 'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFindFile' },
                keys = {'<leader>kb', '<leader>kf'},
            },
            {
                'tweekmonster/startuptime.vim',
                -- 'dstein64/vim-startuptime',
                cmd = {'StartupTime'},
            },
            -- { 'norcalli/profiler.nvim', },
            {
                'gelguy/wilder.nvim',
                config = function()
                    require('settings').wilder()
                end,
                run = ':UpdateRemotePlugins',
            },
        }

        --{{{ git }}}
        use {
            {
                'tpope/vim-fugitive',
                event = {'BufNewFile', 'BufRead'},
            },
            {
                'lewis6991/gitsigns.nvim',
                requires = {
                    'nvim-lua/plenary.nvim',
                },
                event = {'BufNewFile', 'BufRead'},
                config = function()
                    require('settings').gitsigns()
                end,
            }
        }

        --{{{ Visuals }}}
        use {
            {
                'glepnir/galaxyline.nvim',
                branch = 'main',
                requires = { 'kyazdani42/nvim-web-devicons', },
                wants = 'nvim-web-devicons',
                config = function() require'statusline.statusline' end,
            },
            {
                'dhruvasagar/vim-zoom',
            },
            {
                'kshenoy/vim-signature',       -- Display and navigate marks
                event = { 'BufRead', 'BufNewFile' },
            },
        }

        --{{{ Editing }}}
        use {
            {
                -- 'tpope/vim-commentary',
                -- https://github.com/terrortylor/nvim-comment
                'b3nj5m1n/kommentary',
                event = { 'BufRead', 'BufNewFile' },
                config = require('settings').kommentary,
            },
            {
                'tpope/vim-repeat',
                event = { 'BufRead', 'BufNewFile' },
            },
            {
                'bronson/vim-trailing-whitespace',
                event = { 'BufRead', 'BufNewFile' },
            },
            {
                'arthurxavierx/vim-caser',     -- case conversion
                event = { 'BufRead', 'BufNewFile' },
            },
            {
                'junegunn/vim-easy-align',
                event = { 'BufRead', 'BufNewFile' },
            },
            {
                'SirVer/ultisnips',
                event = { 'BufRead', 'BufNewFile' },
                setup = function()
                    vim.g.UltiSnipsExpandTrigger = "<c-s>"
                end,
            },
            {
                'mg979/vim-visual-multi',
                branch = 'master',
                setup = function()
                    vim.g.VM_theme = 'ocean'
                end,
                event = { 'BufRead', 'BufNewFile' },
            },
            {
                'tommcdo/vim-exchange',
                event = { 'BufRead', 'BufNewFile' },
            },
            -- { -- try this maybe?
            -- https://github.com/windwp/nvim-autopairs
            -- https://github.com/disrupted/dotfiles/blob/master/.config/nvim/lua/conf/pears.lua
            --     'steelsojka/pears.nvim',
            ---- event = { 'BufRead' },
            --     config = require('conf.pears').config,
            -- },
            {
                'windwp/nvim-autopairs',
                event = {'BufNewFile', 'BufRead'},
                config = require('settings').autopairs,
            },
            -- use 'mbbill/undotree'
        }

        --{{{ Languages }}}
        use {
            {
                'neovim/nvim-lspconfig',
                event = {'BufNewFile', 'BufRead'},
                config = function() require('lsp') end,
            },
            {
                'nvim-lua/completion-nvim',
                event = {'BufNewFile', 'BufRead'},
                setup = require('settings').completion,
            },
            {
                'dense-analysis/ale',
                config = function()
                    require('settings').ale.config()
                end,
                opt = true,
                ft = lspFiletypes,
                requires = {
                    'adelarsq/vim-emoji-icon-theme',
                    opt = true,
                    ft = lspFiletypes,
                },
            },
            {
                'steelsojka/completion-buffers',
                event = {'BufNewFile', 'BufRead'},
            },
            {
                'ojroques/nvim-lspfuzzy',
                requires = {
                    {'junegunn/fzf'},
                    {'junegunn/fzf.vim'},
                },
                ft = lspFiletypes,
                config = function() require('lspfuzzy').setup{} end,
            },
            {
                'nvim-treesitter/nvim-treesitter',
                branch = '0.5-compat',
                event = { 'BufRead', 'BufNewFile' },
                requires = {
                    {
                        'nvim-treesitter/nvim-treesitter-refactor',
                        after = 'nvim-treesitter',
                        config = require('settings').treesitter_refactor,
                    },
                    {
                        'nvim-treesitter/nvim-treesitter-textobjects',
                        branch = '0.5-compat',
                        after = 'nvim-treesitter',
                    },
                },
                run = ':TSUpdate',
                config = require('settings').treesitter,
            },
            {
                'uarun/vim-protobuf',
                ft = {'proto'},
            },
            {
                'towolf/vim-helm',
                ft = { 'yaml' },
            },
        }

        --{{{ Text objects }}}
        use {
            {
                --  'tpope/vim-surround',
                'blackCauldron7/surround.nvim',
                event = { 'BufRead', 'BufNewFile' },
                config = require('settings').surround,
            },
            {
                'glts/vim-textobj-comment',
                event = { 'BufRead', 'BufNewFile' },
                opt = true,
                requires = {
                    'kana/vim-textobj-user',
                    event = { 'BufRead', 'BufNewFile' },
                    opt = true,
                },
            },
            {
                'fvictorio/vim-textobj-backticks',
                event = { 'BufRead', 'BufNewFile' },
                opt = true,
                requires = {
                    'kana/vim-textobj-user',
                    event = { 'BufRead', 'BufNewFile' },
                    opt = true,
                },
            },
            {
                'austintaylor/vim-indentobject',
                event = { 'BufRead', 'BufNewFile' },
            },
        }

    end,
    config = {
        log = { level = 'debug' },
        display = {
            open_fn = function()
                return require('packer.util').float({ border = 'single' })
            end
        }
    },
})
