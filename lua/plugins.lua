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
        use 'wbthomason/packer.nvim'
        use 'tjdevries/astronauta.nvim'
        use 'nvim-lua/plenary.nvim'

        --{{{ Core/System utilities }}}
        use {
            'junegunn/fzf.vim',
            requires = { 'junegunn/fzf' },
            config = function() require('settings.fzf') end,
        }

        use {
            'kevinhwang91/nvim-bqf',
            requires = {
                'junegunn/fzf',
                'nvim-treesitter/nvim-treesitter',
                branch = '0.5-compat',
            },
            config = function() require('bqf').enable() end,
            event = { 'BufWinEnter quickfix' },
        }

        use 'kyazdani42/nvim-web-devicons'

        use {
            'kyazdani42/nvim-tree.lua',
            setup = function() require('settings').nvim_tree.setup() end,
            config = function() require('settings').nvim_tree.config() end,
            -- cmd = { 'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFindFile' },
            -- keys = {'<leader>kb', '<leader>kf'},
        }

        use {
            'tweekmonster/startuptime.vim',
            -- 'dstein64/vim-startuptime',
            cmd = {'StartupTime'},
        }

        -- { 'norcalli/profiler.nvim', },
        use {
            'gelguy/wilder.nvim',
            config = function() require('settings.wilder') end,
            run = ':UpdateRemotePlugins',
        }

        --{{{ git }}}
        use {
            'tpope/vim-fugitive',
            event = {'BufNewFile', 'BufRead'},
            cmd = {'G', 'Git'},
        }

        use {
            'lewis6991/gitsigns.nvim',
            requires = {
                'nvim-lua/plenary.nvim',
            },
            config = function() require('settings.gitsigns') end,
            event = {'BufNewFile', 'BufRead'},
        }

        --{{{ Visuals }}}
        use {
            'glepnir/galaxyline.nvim',
            branch = 'main',
            config = function() require'statusline' end,
        }

        use {
            'dhruvasagar/vim-zoom',
            event = { 'BufRead', 'BufNewFile' },
        }

        use {
            'norcalli/nvim-colorizer.lua',
            config = function() require'colorizer'.setup() end,
            event = { 'BufRead', 'BufNewFile' },
        }

        --{{{ Editing }}}
        use {
            'b3nj5m1n/kommentary',
            config = function() require('settings').kommentary() end,
            event = { 'BufRead', 'BufNewFile' },
        }

        use {
            'tpope/vim-repeat',
            event = { 'BufRead', 'BufNewFile' },
        }

        use {
            'bronson/vim-trailing-whitespace',
            event = { 'BufRead', 'BufNewFile' },
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
            'arthurxavierx/vim-caser',     -- case conversion
            event = { 'BufRead', 'BufNewFile' },
        }

        use {
            'junegunn/vim-easy-align',
            event = { 'BufRead', 'BufNewFile' },
        }

        use {
            'SirVer/ultisnips',
            setup = function() vim.g.UltiSnipsExpandTrigger = "<c-s>" end,
            event = { 'BufRead', 'BufNewFile' },
        }

        use {
            'mg979/vim-visual-multi',
            branch = 'master',
            -- config = function()
            --     -- vim.g.VM_leader = 'alt'
            --     vim.g.VM_maps = {}
            --     vim.g.VM_maps['Align'] = '<M-a>'
            -- end,
            setup = function()
                vim.g.VM_theme = 'ocean'
            end,
            event = { 'BufRead', 'BufNewFile' },
        }

        use {
            'tommcdo/vim-exchange',
            event = { 'BufRead', 'BufNewFile' },
        }

        use {
            'windwp/nvim-autopairs',
            config = function() require('settings').autopairs() end,
            event = {'BufNewFile', 'BufRead'},
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

        --{{{ Programming }}}
        use {
            'neovim/nvim-lspconfig',
            wants = "completion-nvim",
            config = function() require('settings.lsp') end,
            event = {'BufNewFile', 'BufRead'},
        }

        use {
            'nvim-lua/completion-nvim',
            setup = function() require('settings.completion') end,
            event = {'BufNewFile', 'BufRead'},
        }

        use {
            'dense-analysis/ale',
            config = function()
                require('settings.ale') end,
            opt = true,
            ft = lspFiletypes,
        }

        use {
            'steelsojka/completion-buffers',
            event = {'BufNewFile', 'BufRead'},
        }

        use {
            'ojroques/nvim-lspfuzzy',
            requires = {
                {'junegunn/fzf'},
                {'junegunn/fzf.vim'},
            },
            config = function()
                require('lspfuzzy').setup{
                    fzf_preview = {
                        'right:60%:+{2}-/2,nohidden',
                    },
                }
            end,
            ft = lspFiletypes,
        }

        use {
            'nvim-treesitter/nvim-treesitter',
            branch = '0.5-compat',
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
            config = function() require('settings.treesitter') end,
            run = ':TSUpdate',
            event = { 'BufRead', 'BufNewFile' },
        }

        use {
            'David-Kunz/treesitter-unit',
            requires = {
                'nvim-treesitter/nvim-treesitter',
                branch = '0.5-compat',
                event = { 'BufRead', 'BufNewFile' },
            },
            wants = 'nvim-treesitter',
            config = function() require('settings').treesitter_unit() end,
            event = { 'BufRead', 'BufNewFile' },
        }

        use {
            'uarun/vim-protobuf',
            ft = {'proto'},
        }

        use {
            'towolf/vim-helm',
            ft = { 'yaml' },
        }

        --{{{ Text objects }}}
        use {
            'blackCauldron7/surround.nvim',
            config = function() require('settings').surround() end,
            event = { 'BufRead', 'BufNewFile' },
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
