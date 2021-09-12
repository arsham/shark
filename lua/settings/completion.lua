-- possible value: 'UltiSnips', 'Neosnippet', 'vim-vsnip', 'snippets.nvim'
vim.g.completion_enable_snippet = 'UltiSnips'

vim.g.completion_enable_auto_hover      = 0
vim.g.completion_enable_auto_popup      = 1
vim.g.completion_enable_auto_signature  = 0
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy', 'all'}
vim.g.completion_trigger_keyword_length = 2 -- default = 1
vim.g.completion_matching_smart_case    = 1

-- with fuzzy set, it flickers. See #237
-- vim.g.completion_auto_change_source = 1

-- "cmd" : i_CTRL-X_CTRL-V
-- "defs": i_CTRL-X_CTRL-D
-- "dict": i_CTRL-X_CTRL-K
-- "incl": i_CTRL-X_CTRL-I
-- "spel": i_CTRL-X_s
vim.g.completion_chain_complete_list = {
    default = {
        default = {
            { complete_items = {'lsp', 'snippet'} },
            { mode           = 'omni'},
            { mode           = 'line'},
            { complete_items = {'path'}, trigger_character = {'/'} },
            { complete_items = {'buffers'} },
            { mode           = 'ctrlp'},
            { mode           = 'ctrln'},
        },

        comment = {
            { mode           = 'ctrlp'},
            { mode           = 'ctrln'},
            { complete_items = {'buffers'} },
            { mode           = 'omni'},
            { mode           = 'dict'},
            { mode           = 'spell'},
            { complete_items = {'path'}, trigger_character = {'/'} },
            { mode           = 'line'},
        },

        string = {
            { complete_items = {'buffers'} },
            { mode           = 'ctrlp'},
            { mode           = 'ctrln'},
            { mode           = 'dict'},
            { mode           = 'spell'},
            { complete_items = {'path'}, trigger_character = {'/'} },
        },
    },
}

--        ⌘ ⌂       ﲀ 練 ﴲ  ﰮ      ﳤ   
--   ƒ    了   ﬌     <>
vim.g.completion_customize_lsp_label = {
    Buffers       = ' [buff]',
    Class         = ' [class]',
    Color         = " [color]",
    Constant      = " [const]",
    Constructor   = " [constructor]",
    Enum          = ' [enum]',
    EnumMember    = " [enum member]",
    Event         = " [event]",
    Field         = 'ﰠ [field]',
    File          = " [file]",
    Folder        = ' [folder]',
    Function      = ' [func]',
    Interface     = ' [interface]',
    Keyword       = ' [key]',
    Method        = ' [method]',
    Module        = 'ﴯ [module]',
    Operator      = ' [operator]',
    Path          = ' [path]',
    Property      = "襁[property]",
    Reference     = ' [refrence]',
    Snippet       = ' [snippet]',
    Struct        = "פּ [struct]",
    Text          = ' [text]',
    TypeParameter = " [type param]",
    Unit          = "塞 [unit]",
    Value         = " [value]",
    Variable      = ' [variable]',
}
