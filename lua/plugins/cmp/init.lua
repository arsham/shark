local priorities
local kind_icons = require("config.icons").kinds
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

local function has_words_before() -- {{{
  if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end -- }}}

local function config()
  -- Imports {{{
  local cmp = require("cmp")
  local compare = require("cmp.config.compare")
  local ls = require("luasnip")
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

  local border = function(hl)
    return {
      { "╭", hl },
      { "─", hl },
      { "╮", hl },
      { "│", hl },
      { "╯", hl },
      { "─", hl },
      { "╰", hl },
      { "│", hl },
    }
  end

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
            { name = "path", priority = 40 },
            { name = "luasnip", priority = 10 },
            { name = "nvim_lsp_signature_help" },
            { name = "calc" },
            { name = "dap" },
            { name = "crates" },
            { name = "neorg", priority = 5, keyword_length = 1 },
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
              option = {
                get_bufnrs = function()
                  return vim.api.nvim_list_bufs()
                end,
              },
            },
            {
              name = "rg",
              keyword_length = 3,
              priority = 1,
              option = {
                additional_arguments = "--max-depth 6 --one-file-system --ignore-file ~/.config/nvim/scripts/rgignore",
              },
            },
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
              group_index = 5,
              option = {
                get_bufnrs = function()
                  return vim.api.nvim_list_bufs()
                end,
              },
            },
          }, {
            { name = "rg", keyword_length = 3, priority = 1, group_index = 5 },
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

      ["<C-x><C-g>"] = cmp.mapping.complete({ -- GIT {{{
        config = {
          sources = {
            { name = "git" },
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
        i = vim.schedule_wrap(tab_function),
        s = vim.schedule_wrap(tab_function),
      }), -- }}}

      ["<S-Tab>"] = cmp.mapping({ -- {{{
        i = vim.schedule_wrap(shift_tab_function),
        s = vim.schedule_wrap(shift_tab_function),
      }), -- }}}
    }), --}}}

    sources = cmp.config.sources({ --{{{
      {
        name = "nvim_lsp",
        priority = 80,
        group_index = 1,
      },
      { name = "nvim_lua", priority = 80, group_index = 1 },
      { name = "path", priority = 40, group_index = 5 },
      { name = "luasnip", priority = 10, group_index = 2 },
      { name = "calc", group_index = 3 },
      { name = "nvim_lsp_signature_help" },
      {
        name = "buffer",
        priority = 5,
        keyword_length = 3,
        group_index = 5,
        option = {
          get_bufnrs = function()
            return vim.api.nvim_list_bufs()
          end,
        },
      },
      {
        name = "rg",
        keyword_length = 3,
        priority = 5,
        group_index = 5,
        option = {
          additional_arguments = "--max-depth 6 --one-file-system --ignore-file ~/.config/nvim/scripts/rgignore",
        },
      },
      { name = "emoji", priority = 2 },
      { name = "nerdfont", priority = 1 },
      { name = "neorg", keyword_length = 1 },
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
          nvim_lua = "Lua",
          path = "Path",
          rg = "RG",
          omni = "Omni",
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
        border = border("CmpBorder"),
        winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
      }),
      documentation = {
        border = border("CmpDocBorder"),
      },
    }, -- }}}

    sorting = { --{{{
      priority_weight = 2,
      comparators = {
        compare.exact,
        compare.recently_used,
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
        function(...)
          return require("cmp_buffer"):compare_locality(...)
        end,
        compare.locality,
        compare.sort_text,
        compare.length,
        compare.order,
      },
    }, --}}}
  })

  cmp.setup.filetype("gitcommit", { -- {{{
    sources = cmp.config.sources({
      { name = "git", priority = 100 },
      { name = "luasnip", priority = 80 },
      { name = "rg", priority = 50 },
      { name = "path", priority = 10 },
      { name = "emoji" },
      { name = "nerdfont" },
    }),
  }) -- }}}
end

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "lukas-reineke/cmp-rg",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "nvim-treesitter/nvim-treesitter",
      {
        "petertriho/cmp-git",
        opts = {
          filetypes = { "*" },
        },
      },
      "hrsh7th/cmp-emoji",
      "chrisgrieser/cmp-nerdfont",
    },
    config = config,
    event = { "InsertEnter" },
    cond = require("config.util").should_start("hrsh7th/nvim-cmp"),
    enabled = require("config.util").is_enabled("hrsh7th/nvim-cmp"),
  },
  {
    "hrsh7th/nvim-cmp",
    name = "nvim-cmp.commandline",
    dependencies = {
      "hrsh7th/cmp-cmdline",
    },
    event = { "CmdlineEnter" },
    config = function()
      local cmp = require("cmp")
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "cmdline" },
        }, {
          { name = "path" },
        }),
      })
    end,
    cond = require("config.util").should_start("hrsh7th/nvim-cmp"),
    enabled = require("config.util").is_enabled("hrsh7th/nvim-cmp"),
  },
}

-- vim: fdm=marker fdl=0
