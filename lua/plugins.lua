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
}

require('packer').startup({
    function(use)

        --{{{ Libraries }}}
        use {
            {'wbthomason/packer.nvim'},
            {'tjdevries/astronauta.nvim'},
        }

        --{{{ Core/System utilities }}}
        use {
            {
                'junegunn/fzf.vim',
                requires = { 'junegunn/fzf' },
                config = function() require('settings.fzf') end,
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
                setup = function() require('settings').nvim_tree.setup() end,
                config = function() require('settings').nvim_tree.config() end,
                -- cmd = { 'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFindFile' },
                -- keys = {'<leader>kb', '<leader>kf'},
            },
            {
                'tweekmonster/startuptime.vim',
                -- 'dstein64/vim-startuptime',
                cmd = {'StartupTime'},
            },
            -- { 'norcalli/profiler.nvim', },
            {
                'gelguy/wilder.nvim',
                config = function() require('settings.wilder') end,
                run = ':UpdateRemotePlugins',
            },
        }

        --{{{ git }}}
        use {
            {
                'tpope/vim-fugitive',
                event = {'BufNewFile', 'BufRead'},
                cmd = {'G'},
            },
            {
                'lewis6991/gitsigns.nvim',
                requires = {
                    'nvim-lua/plenary.nvim',
                },
                event = {'BufNewFile', 'BufRead'},
                config = function() require('settings.gitsigns') end,
            }
        }

        --{{{ Visuals }}}
        use {
            {
                'glepnir/galaxyline.nvim',
                branch = 'main',
                config = function() require'statusline' end,
            },
            {
                'dhruvasagar/vim-zoom',
                event = { 'BufRead', 'BufNewFile' },
            },
            {
                'norcalli/nvim-colorizer.lua',
                event = { 'BufRead', 'BufNewFile' },
                config = function() require'colorizer'.setup() end,
            },
        }

        --{{{ Editing }}}
        use {
            {
                'b3nj5m1n/kommentary',
                event = { 'BufRead', 'BufNewFile' },
                config = function() require('settings').kommentary() end,
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
                setup = function() vim.g.UltiSnipsExpandTrigger = "<c-s>" end,
            },
            {
                'mg979/vim-visual-multi',
                branch = 'master',
                setup = function() vim.g.VM_theme = 'ocean' end,
                event = { 'BufRead', 'BufNewFile' },
            },
            {
                'tommcdo/vim-exchange',
                event = { 'BufRead', 'BufNewFile' },
            },
            {
                'windwp/nvim-autopairs',
                event = {'BufNewFile', 'BufRead'},
                config = function() require('settings').autopairs() end,
            },
        }

        use {
            {
                'rcarriga/nvim-notify',
                config = function()
                    local async_load_plugin = nil
                    async_load_plugin = vim.loop.new_async(vim.schedule_wrap(function()
                        vim.notify = require("notify")
                        async_load_plugin:close()
                    end))
                    async_load_plugin:send()
                end,
            },
            {'MunifTanjim/nui.nvim'},
        }

        --{{{ Programming }}}
        use {
            {
                'neovim/nvim-lspconfig',
                event = {'BufNewFile', 'BufRead'},
                config = function() require('settings.lsp') end,
                wants = "completion-nvim",
            },
            {
                'nvim-lua/completion-nvim',
                event = {'BufNewFile', 'BufRead'},
                setup = function() require('settings.completion') end,
            },
            {
                'dense-analysis/ale',
                config = function() require('settings.ale') end,
                opt = true,
                ft = lspFiletypes,
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
                config = function()
                    require('lspfuzzy').setup{
                        fzf_preview = {
                            'right:60%:+{2}-/2,nohidden',
                        },
                    }
                end,
            },
            {
                'nvim-treesitter/nvim-treesitter',
                branch = '0.5-compat',
                event = { 'BufRead', 'BufNewFile' },
                requires = {
                    {
                        'nvim-treesitter/nvim-treesitter-refactor',
                        after = 'nvim-treesitter',
                        config = function() require('settings').treesitter_refactor() end,
                        event = { 'BufRead', 'BufNewFile' },
                    },
                    {
                        'nvim-treesitter/nvim-treesitter-textobjects',
                        branch = '0.5-compat',
                        after = 'nvim-treesitter',
                        event = { 'BufRead', 'BufNewFile' },
                    },
                },
                run = ':TSUpdate',
                config = function() require('settings.treesitter') end,
            },
            {
                'David-Kunz/treesitter-unit',
                requires = {
                    'nvim-treesitter/nvim-treesitter',
                    branch = '0.5-compat',
                    event = { 'BufRead', 'BufNewFile' },
                },
                wants = 'nvim-treesitter',
                event = { 'BufRead', 'BufNewFile' },
                config = function() require('settings').treesitter_unit() end,
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
                'blackCauldron7/surround.nvim',
                event = { 'BufRead', 'BufNewFile' },
                config = function() require('settings').surround() end,
            },
            {
                'glts/vim-textobj-comment',
                event = { 'BufRead', 'BufNewFile' },
                opt = true,
                wants = 'vim-textobj-user',
                requires = {
                    'kana/vim-textobj-user',
                    event = { 'BufRead', 'BufNewFile' },
                    opt = true,
                },
            },
        }

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
