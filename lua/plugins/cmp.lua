local priorities
---Sets up the priorities variable once when cmp is loaded.
local function setup_priorities() -- {{{
  local kinds = require("cmp.types").lsp.CompletionItemKind
  priorities = {
    kinds.Field,
    kinds.Variable,
    kinds.Method,
    kinds.Property,
    kinds.Function,
    kinds.Constructor,
    kinds.Class,
    kinds.Interface,
    kinds.Module,
    kinds.Unit,
    kinds.Value,
    kinds.Enum,
    kinds.Keyword,
    kinds.Color,
    kinds.File,
    kinds.Reference,
    kinds.Folder,
    kinds.EnumMember,
    kinds.Constant,
    kinds.Struct,
    kinds.Event,
    kinds.Operator,
    kinds.TypeParameter,
    kinds.Snippet,
    kinds.Text,
  }
end -- }}}

--             ⌘  ⌂            ﲀ  練  ﴲ    ﰮ    
--       ﳤ              了    ﬌      <    >  ⬤    襁
--                             
--              ⌬    
-- stylua: ignore
local kind_icons = { -- {{{
  Array         = "",
  Boolean       = " ",
  Buffers       = " ",
  Class         = " ",
  Color         = " ",
  Constant      = " ",
  Constructor   = " ",
  Enum          = " ",
  EnumMember    = " ",
  Event         = " ",
  Field         = "ﰠ ",
  File          = " ",
  Folder        = " ",
  Function      = "ƒ ",
  Interface     = " ",
  Key           = " ",
  Keyword       = " ",
  Method        = " ",
  Module        = " ",
  Namespace     = " ",
  Null          = "ﳠ ",
  Number        = " ",
  Object        = " ",
  Operator      = " ",
  Package       = " ",
  Property      = " ",
  Reference     = " ",
  Snippet       = " ",
  String        = " ",
  Struct        = " ",
  Text          = " ",
  TypeParameter = " ",
  Unit          = "塞 ",
  Value         = " ",
  Variable      = " ",
} -- }}}

local function has_words_before() -- {{{
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end -- }}}

local function config()
  -- Imports {{{
  local cmp = require("cmp")
  local compare = require("cmp.config.compare")
  local ls = require("luasnip")
  local kinds = require("cmp.types").lsp.CompletionItemKind
  local ts_utils = require("nvim-treesitter.ts_utils")
  setup_priorities()
  -- }}}

  local function tab_function(fallback) -- {{{
    if ls.expand_or_locally_jumpable() then
      ls.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end -- }}}

  local function shift_tab_function(fallback) -- {{{
    if ls.jumpable(-1) then
      ls.jump(-1)
    else
      fallback()
    end
  end -- }}}

  cmp.setup({
    performance = { -- {{{
      debounce = 50,
      throttle = 10,
    }, -- }}}

    snippet = { -- {{{
      expand = function(args)
        ls.lsp_expand(args.body)
      end,
    }, -- }}}

    preselect = cmp.PreselectMode.None,

    mapping = cmp.mapping.preset.insert({ --{{{
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),

      ["<C-Space>"] = cmp.mapping.complete({ -- Main one {{{
        config = {
          sources = {
            { name = "nvim_lsp", priority = 80 },
            { name = "nvim_lua", priority = 80 },
            { name = "path", priority = 40, max_item_count = 4 },
            { name = "luasnip", priority = 10 },
            { name = "nvim_lsp_signature_help" },
            { name = "calc" },
            { name = "dap" },
            { name = "crates" },
          },
        },
      }), -- }}}

      ["<C-s>"] = cmp.mapping.complete({ -- {{{
        config = {
          sources = {
            { name = "neorg", keyword_length = 1 },
            {
              name = "buffer",
              priority = 5,
              keyword_length = 3,
              max_item_count = 10,
              option = {
                get_bufnrs = function()
                  return vim.api.nvim_list_bufs()
                end,
              },
            },
            { name = "rg", keyword_length = 3, max_item_count = 10, priority = 1 },
          },
        },
      }), -- }}}

      ["<C-x><C-o>"] = cmp.mapping.complete({ -- {{{
        config = {
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
          }, {
            {
              name = "buffer",
              priority = 5,
              keyword_length = 3,
              max_item_count = 5,
              group_index = 5,
              option = {
                get_bufnrs = function()
                  return vim.api.nvim_list_bufs()
                end,
              },
            },
          }, {
            { name = "rg", keyword_length = 3, max_item_count = 10, priority = 1, group_index = 5 },
          }),
        },
      }), -- }}}

      ["<C-x><C-r>"] = cmp.mapping.complete({ -- {{{
        config = {
          sources = {
            { name = "rg" },
          },
        },
      }), -- }}}

      ["<C-x><C-s>"] = cmp.mapping.complete({ -- Snippets {{{
        config = {
          sources = {
            { name = "luasnip" },
          },
        },
      }), -- }}}

      ["<C-y>"] = cmp.config.disable, -- {{{
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }), -- }}}

      ["<CR>"] = cmp.mapping.confirm({ -- {{{
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      }), -- }}}

      ["<C-j>"] = cmp.mapping.select_next_item({ -- {{{
        behavior = cmp.SelectBehavior.Select,
      }),
      ["<C-k>"] = cmp.mapping.select_prev_item({
        behavior = cmp.SelectBehavior.Select,
      }), -- }}}

      -- only use < tab >/<s-tab> for switching between placeholders.
      ["<Tab>"] = cmp.mapping({ -- {{{
        i = tab_function,
        s = tab_function,
      }), -- }}}

      ["<S-Tab>"] = cmp.mapping({ -- {{{
        i = shift_tab_function,
        s = shift_tab_function,
      }), -- }}}
    }), --}}}

    sources = cmp.config.sources({ --{{{
      {
        name = "nvim_lsp",
        priority = 80,
        group_index = 1,
        entry_filter = function(entry, context) -- {{{
          local kind = entry:get_kind()
          local line = context.cursor_line
          local col = context.cursor.col
          local chars_before = line:sub(col - 4, col - 1)

          if chars_before:find("%.") or chars_before:find("%:") then
            -- If any previous 4 characters contains a "." or ":"
            return kind == kinds.Method or kind == kinds.Function or kinds.Field
          elseif line:match("^%s*%w*$") then
            -- text in the new line
            return kind == kinds.Function or kind == kinds.Variable
          end

          return true
        end, -- }}}
      },
      { name = "nvim_lua", priority = 80, group_index = 1 },
      { name = "path", priority = 40, max_item_count = 4, group_index = 5 },
      { name = "luasnip", priority = 10, group_index = 2 },
      { name = "calc", group_index = 3 },
      { name = "nvim_lsp_signature_help" },
      { name = "dap" },
      { name = "neorg", keyword_length = 1 },
      {
        name = "buffer",
        priority = 5,
        keyword_length = 3,
        max_item_count = 5,
        group_index = 5,
        option = {
          get_bufnrs = function()
            return vim.api.nvim_list_bufs()
          end,
        },
      },
      { name = "rg", keyword_length = 3, max_item_count = 10, priority = 1, group_index = 5 },
    }), --}}}

    formatting = { --{{{
      fields = { "abbr", "kind", "menu" },
      format = function(entry, vim_item)
        local client_name = ""
        if entry.source.name == "nvim_lsp" then
          client_name = "/" .. entry.source.source.client.name
        end

        vim_item.menu = string.format("[%s%s]", ({
          buffer = "Buffer",
          nvim_lsp = "LSP",
          luasnip = "LuaSnip",
          vsnip = "VSnip",
          nvim_lua = "Lua",
          latex_symbols = "LaTeX",
          path = "Path",
          rg = "RG",
          omni = "Omni",
          copilot = "[ﯙ]",
          dap = "DAP",
          neorg = "ORG",
        })[entry.source.name] or entry.source.name, client_name)

        vim_item.kind = string.format("%s %-9s", kind_icons[vim_item.kind], vim_item.kind)
        vim_item.dup = {
          buffer = 1,
          path = 1,
          nvim_lsp = 0,
          luasnip = 1,
        }
        return vim_item
      end,
    }, --}}}

    view = {
      max_height = 20,
    },

    window = { -- {{{
      completion = cmp.config.window.bordered({
        winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
      }),
    }, -- }}}

    sorting = { --{{{
      priority_weight = 2,
      comparators = {
        compare.exact,
        compare.offset,

        function(entry1, entry2)
          local kind1, kind2 = entry1:get_kind(), entry2:get_kind()
          if kind1 ~= kind2 then
            for _, kind in ipairs(priorities) do
              if kind1 == kind then
                return true
              end
              if kind2 == kind then
                return false
              end
            end
          end
        end,

        compare.score,
        compare.recently_used,
        compare.locality,
        function(...)
          return require("cmp_buffer"):compare_locality(...)
        end,
        compare.sort_text,
        compare.length,
        compare.order,
      },
    }, --}}}
  })
end

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-calc",
    "lukas-reineke/cmp-rg",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "nvim-treesitter/nvim-treesitter",
  },
  config = config,
  event = { "InsertEnter" },
  cond = require("util").full_start_with_lsp,
}

-- vim: fdm=marker fdl=0
