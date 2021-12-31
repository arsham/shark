local cmp = require'cmp'
local compare = require('cmp.config.compare')

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

---               ⌘  ⌂              ﲀ  練  ﴲ    ﰮ    
---       ﳤ          ƒ          了    ﬌      <    >  ⬤      襁
---                                                 
local kind_icons = {
    Buffers       = ' ',
    Class         = ' ',
    Color         = ' ',
    Constant      = ' ',
    Constructor   = ' ',
    Enum          = ' ',
    EnumMember    = ' ',
    Event         = ' ',
    Field         = 'ﰠ ',
    File          = ' ',
    Folder        = ' ',
    Function      = 'ƒ ',
    Interface     = ' ',
    Keyword       = ' ',
    Method        = ' ',
    Module        = ' ',
    Operator      = ' ',
    Property      = ' ',
    Reference     = ' ',
    Snippet       = ' ',
    Struct        = ' ',
    TypeParameter = ' ',
    Unit          = '塞 ',
    Value         = ' ',
    Variable      = ' ',
    Text          = ' ',
}

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },

    preselect = cmp.PreselectMode.None,

    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4),  { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(),  { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable,
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),

        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = false,
        }),
        ['<C-j>'] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select
        }),
        ['<C-k>'] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select
        }),

        --- only use < tab >/<s-tab> for switching between placeholders.
        ["<Tab>"] = cmp.mapping(function(fallback)
            if vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            else
                fallback()
            end
        end, { "i", "s" }),
    },

    sources = cmp.config.sources({
        { name = 'nvim_lsp' , priority       = 80 } ,
        { name = 'nvim_lua' , priority       = 80 } ,
        { name = 'path'     , priority       = 40 } ,
        { name = 'vsnip'    , priority       = 10 } ,
        { name = 'calc' }   ,
        { name = 'nvim_lsp_signature_help' },
        { name = 'buffer'   , keyword_length = 3, max_item_count = 10 ,
            option = {
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end
            }
        },
        { name = 'rg', keyword_length = 3, max_item_count = 10 },
    }),

    formatting = {
        fields = {'abbr' ,'kind', 'menu'},
        format = function(entry, vim_item)
            vim_item.menu = string.format('%-8s[%s]', vim_item.kind, ({
                buffer        = "Buffer",
                nvim_lsp      = "LSP",
                luasnip       = "LuaSnip",
                vsnip         = "VSnip",
                nvim_lua      = "Lua",
                latex_symbols = "LaTeX",
                path          = "Path",
                rg            = "RG",
                omni          = "Omni",
                copilot       = "Copilot",
            })[entry.source.name])

            vim_item.kind = kind_icons[vim_item.kind]
            vim_item.dup  = {
                buffer   = 1,
                path     = 1,
                nvim_lsp = 0,
                luasnip  = 1,
            }

            return vim_item
        end
    },

    documentation = {
        border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"}
    },

    sorting = {
        comparators = {
            function(...)
                return require('cmp_buffer'):compare_locality(...)
            end,
            compare.offset,
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
        },
    },
})

cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})
