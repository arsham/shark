return {
  lsp = { -- {{{
    diagnostic = {
      signs = {
        Error = "🔥",
        Warn = "💩",
        Info = "💬",
        Hint = "💡",
      },
      upper_signs = {
        -- We don't want to calculate these on the fly.
        ERROR = "🔥",
        WARN = "💩",
        INFO = "💬",
        HINT = "💡",
      },
    },
  }, -- }}}

  --             ⌘  ⌂            ﲀ  練  ﴲ    ﰮ    
  --       ﳤ              了    ﬌      <    >  ⬤    襁
  --                             
  --              ⌬    
  -- stylua: ignore
  kinds = { -- {{{
    Array         = "",
    Boolean       = " ",
    Buffers       = " ",
    Class         = " ",
    Color         = " ",
    Constant      = " ",
    Constructor   = " ",
    Copilot       = "⌬ ",
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
  }, -- }}}

  -- stylua: ignore
  navic = { --{{{
    Array         = " ",
    Boolean       = "◩ ",
    Calendar      = " ",
    Class         = " ",
    Constant      = " ",
    Constructor   = " ",
    Container     = " ",
    Enum          = "練",
    EnumMember    = " ",
    Event         = " ",
    Field         = " ",
    File          = " ",
    Func          = " ",
    Function      = " ",
    Interface     = "練",
    Key           = " ",
    Method        = " ",
    Module        = " ",
    Namespace     = " ",
    Null          = "ﳠ ",
    Number        = " ",
    Object        = " ",
    Operator      = " ",
    Package       = " ",
    Property      = " ",
    String        = " ",
    Struct        = " ",
    Table         = " ",
    Tag           = " ",
    TypeParameter = " ",
    Variable      = " ",
    Watch         = " ",
  }, --}}}
}

-- vim: fdm=marker fdl=0
