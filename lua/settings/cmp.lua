local cmp = require'cmp'

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local kind_icons = {
    Buffers       = '',
    Class         = '',
    Color         = "",
    Constant      = "",
    Constructor   = "",
    Enum          = '',
    EnumMember    = "",
    Event         = "",
    Field         = 'ﰠ',
    File          = "",
    Folder        = '',
    Function      = "",
    Interface     = "",
    Keyword       = "",
    Method        = '',
    Module        = "",
    Operator      = '',
    Path          = '',
    Property      = "襁",
    Reference     = '',
    Snippet       = "",
    Struct        = "",
    Text          = '',
    TypeParameter = "",
    Unit          = "塞",
    Value         = "",
    Variable      = '',
}

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },

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
            select = true
        }),
        ['<C-j>'] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select
        }),
        ['<C-k>'] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select
        }),


        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            end
        end, { "i", "s" }),
    },

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        -- { name = 'copilot' },
        { name = 'path' },
        { name = 'vsnip' },
        { name = 'calc' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'buffer', keyword_length = 3,
            option = {
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end
            }
        },
        { name = 'rg', keyword_length = 3, max_item_count = 20,
            option = {
                debounce = 500,
            }
        },
    }),

    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
                buffer        = "[Buffer]",
                nvim_lsp      = "[LSP]",
                luasnip       = "[LuaSnip]",
                vsnip         = "[VSnip]",
                nvim_lua      = "[Lua]",
                latex_symbols = "[LaTeX]",
                path          = "[Path]",
                rg            = "[RG]",
                omni          = "[Omni]",
                copilot       = "[Copilot]",
            })[entry.source.name]
            return vim_item
        end
    },
})

cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})
