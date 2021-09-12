-- This is the 'arsham' color scheme.

local palette = {
    name           = 'arsham',
    base0          = '#232627',
    base1          = '#211F22',
    -- base2       = '#26292C',
    base2          = '#2A2D30',
    base3          = '#2E323C',
    base4          = '#333842',
    base5          = '#4d5154',
    base6          = '#72696A',
    base7          = '#B1B1B1',
    border         = '#A1B5B1',
    brown          = "#6D3717",
    white          = '#FFF1F3',
    grey           = '#72696A',
    black          = '#000000',
    pink           = '#FF6188',
    green          = '#A9DC76',
    aqua           = '#78DCE8',
    yellow         = '#FFD866',
    orange         = '#FC9867',
    purple         = '#AB9DF2',
    darkred        = 'darkred',
    red            = '#FD6883',
    blue           = '#1981F0',
    darkblue       = '#213E5D',
    paleblue       = '#6EABEC',
    diff_add_fg    = '#B0C781',
    diff_add_bg    = '#3D5213',
    diff_remove_fg = '#4A0F23',
    diff_remove_bg = '#A3214C',
    diff_change_fg = '#7AA6DA',
    diff_change_bg = '#537196',
    diff_text_fg   = '#000000',
    diff_text_bg   = '#73D2DE',
    color_column   = '#2E2A2A',
    none           = 'NONE',
    -- TODO:
    -- accent
}

local mappings = {
    Normal = {
        guifg = palette.white,
        guibg = palette.base0,
    },
    NormalNC = {
        -- normal text in non-current windows
        guifg = palette.fg,
        guibg = palette.bg,
    },
    NormalSB = {
        -- normal text in non-current windows
        guifg = palette.fg_sidebar,
        guibg = palette.bg_sidebar,
    },
    NormalFloat = {
        -- normal text and background color for floating windows
        guifg = palette.none,
        guibg = palette.darkblue,
    },
    Pmenu = {
        -- Popup menu: normal item.
        guifg = palette.white,
        guibg = palette.base3,
    },
    PmenuSel = {
        -- Popup menu: selected item.
        guifg = palette.base4,
        guibg = palette.orange,
    },
    PmenuSelBold = {
        guifg = palette.base4,
        guibg = palette.orange,
    },
    PmenuThumb = {
        -- Popup menu: Thumb of the scrollbar.
        guifg = palette.purple,
        guibg = palette.green,
    },
    PmenuSbar = {
        -- Popup menu: scrollbar.
        guifg = palette.none,
        guibg = palette.base3,
    },
    Cursor = {
        guifg = palette.none,
        guibg = palette.none,
        style = 'reverse'
    },
    ColorColumn = {
        --  used for the columns set with 'colorcolumn'
        guifg = palette.none,
        guibg = palette.color_column,
    },
    CursorLine = {
        -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority
        -- if foreground (ctermfg OR guifg) is not set.
        guifg = palette.none,
        guibg = palette.base3,
    },
    ToolbarLine = {
        guifg = palette.fg,
        guibg = palette.bg_alt,
    },
    ToolbarButton = {
        guifg = palette.fg,
        guibg = palette.none,
        style = 'bold',
    },
    NormalMode = {
        -- Normal mode message in the cmdline
        guifg = palette.accent,
        guibg = palette.none,
        style = 'reverse',
    },
    InsertMode = {
        -- Insert mode message in the cmdline
        guifg = palette.green,
        guibg = palette.none,
        style = 'reverse',
    },
    ReplacelMode = {
        -- Replace mode message in the cmdline
        guifg = palette.red,
        guibg = palette.none,
        style = 'reverse',
    },
    VisualMode = {
        -- Visual mode message in the cmdline
        guifg = palette.purple,
        guibg = palette.none,
        style = 'reverse',
    },
    CommandMode = {
        -- Command mode message in the cmdline
        guifg = palette.gray,
        guibg = palette.none,
        style = 'reverse',
    },
    healthError = {
        guifg = palette.error,
    },
    healthSuccess = {
        guifg = palette.green,
    },
    healthWarning = {
        guifg = palette.yellow,
    },
    Warnings = {
        guifg = palette.yellow,
    },
    NonText = {
        -- '@' at the end of the window, characters from 'showbreak' and other
        -- characters that do not really exist in the text (e.g., ">" displayed
        -- when a double-wide character doesn't fit at the end of the line).
        -- See also |hl-EndOfBuffer|.
        guifg = palette.base5,
    },
    Visual = {
        -- Visual mode selection
        guibg = palette.base5,
    },
    VisualNOS = {
        -- Visual mode selection when vim is "Not Owning the Selection".
        guibg = palette.base3,
    },
    Search = {
        -- Last search pattern highlighting (see 'hlsearch').  Also used for
        -- similar items that need to stand out.
        guifg = palette.base2,
        guibg = palette.yellow,
    },
    IncSearch = {
        -- 'incsearch' highlighting; also used for the text replaced with
        -- ":s///c"
        guifg = palette.base2,
        guibg = palette.yellow,
    },
    CursorLineNr = {
        -- Like LineNr when 'cursorline' or 'relativenumber' is set for the
        -- cursor line.
        guifg = palette.orange,
        guibg = palette.base2,
    },
    MatchParen = {
        -- The character under the cursor or just before it, if it is a paired
        -- bracket, and its match. |pi_paren.txt|
        guifg = palette.pink,
        guibg = palette.none,
    },
    Question = {
        -- |hit-enter| prompt and yes/no questions
        guifg = palette.yellow,
    },
    ModeMsg = {
        -- 'showmode' message (e.g., "-- INSERT -- ")
        guifg = palette.white,
        guibg = palette.none,
        style = 'bold',
    },
    MsgArea = {
        -- Area for messages and cmdline
        guifg =palette.fg_dark,
    },
    MoreMsg = {
        -- |more-prompt|
        guifg = palette.white,
        guibg = palette.none,
        style = 'bold',
    },
    ErrorMsg = {
        -- error messages
        guifg = palette.red,
        guibg = palette.none,
        style = 'bold',
    },
    WarningMsg = {
        -- warning messages
        guifg = palette.yellow,
        guibg = palette.none,
        style = 'bold',
    },
    VertSplit = {
        guifg = palette.brown,
        guibg = palette.base0,
    },
    LineNr = {
        guifg = palette.base5,
        guibg = palette.base2
    },
    SignColumn = {
        guifg = palette.white,
        guibg = palette.base2,
    },
    SignColumnSB = {
        -- column where |signs| are displayed
        guibg = palette.bg_sidebar,
        guifg = palette.fg_gutter,
    },
    Substitute = {
        -- |:substitute| replacement text highlighting
        guibg =palette.red,
        guifg =palette.black,
    },
    StatusLine = {
        -- status line of current window
        guifg = palette.base7,
        guibg = palette.base2,
        style = palette.none,
    },
    StatusLineNC = {
        -- status lines of not-current windows Note: if this is equal to
        -- "StatusLine" Vim will use "^^^" in the status line of the current
        -- window.
        guifg = palette.grey,
        guibg = palette.base2,
        style = palette.none,
    },
    TabLine = {
        -- tab pages line, not active tab page label
        guibg = palette.bg_statusline,
        guifg = palette.fg_gutter,
    },
    StatusLineTerm = {
        -- status line of current terminal window
        guifg = palette.fg,
        guibg = palette.active,
    },
    StatusLineTermNC = {
        -- status lines of not-current terminal windows Note: if this is equal
        -- to "StatusLine" Vim will use "^^^" in the status line of the current
        -- window.
        guifg = palette.text,
        guibg = palette.bg,
    },
    Tabline = {
        style = palette.none,
    },
    TabLineFill = {
        -- tab pages line, where there are no labels
        style = palette.none,
    },
    TabLineSel = {
        -- tab pages line, active tab page label
        guibg = palette.base4,
    },
    SpellBad = {
        -- Word that is not recognized by the spellchecker. |spell| Combined
        -- with the highlighting used otherwise.
        guifg = palette.red,
        guibg = palette.none,
        style = 'undercurl',
    },
    SpellCap = {
        -- Word that should start with a capital. |spell| Combined with the
        -- highlighting used otherwise.
        guifg = palette.purple,
        guibg = palette.none,
        style = 'undercurl',
    },
    SpellRare = {
        -- Word that is recognized by the spellchecker as one that is hardly
        -- ever used.  |spell| Combined with the highlighting used otherwise.
        guifg = palette.aqua,
        guibg = palette.none,
        style = 'undercurl',
    },
    SpellLocal = {
        -- Word that is recognized by the spellchecker as one that is used in
        -- another region. |spell| Combined with the highlighting used
        -- otherwise.
        guifg = palette.pink,
        guibg = palette.none,
        style = 'undercurl',
    },
    SpecialKey = {
        -- Unprintable characters: text displayed differently from what it
        -- really is.  But not 'listchars' whitespace. |hl-Whitespace|
        guifg = palette.pink,
    },
    Title = {
        -- titles for output from ":set all", ":autocmd" etc.
        guifg = palette.yellow,
        style = 'bold',
    },
    Directory = {
        -- directory names (and other special names in listings)
        guifg = palette.aqua,
        guibg = palette.none,
    },
    DiffAdd = {
        -- diff mode: Added line
        guifg = palette.diff_add_fg,
        guibg = palette.diff_add_bg,
    },
    DiffDelete = {
        -- diff mode: Deleted line
        guifg = palette.diff_remove_fg,
        guibg = palette.diff_remove_bg,
    },
    DiffChange = {
        --  diff mode: Changed line
        guifg = palette.diff_change_fg,
        guibg = palette.diff_change_bg,
    },
    DiffText = {
        -- diff mode: Changed text within a changed line
        guifg = palette.diff_text_fg,
        guibg = palette.diff_text_bg,
    },
    diffAdded = {
        guifg = palette.green,
    },
    diffRemoved = {
        guifg = palette.pink,
    },
    diffChanged = {
        guifg = palette.blue,
    },
    diffOldFile = {
        guifg = palette.text,
    },
    diffNewFile = {
        guifg = palette.title,
    },
    diffFile = {
        guifg = palette.gray,
    },
    diffLine = {
        guifg = palette.cyan,
    },
    diffIndexLine = {
        guifg = palette.purple,
    },
    Folded = {
        -- line used for closed folds
        guifg = palette.grey,
        guibg = palette.base3,
    },
    FoldColumn = {
        -- 'foldcolumn'
        guifg = palette.white,
        guibg = palette.black,
    },
    Constant = {
        guifg = palette.aqua,
    },
    Number = {
        guifg = palette.purple,
    },
    Float = {
        guifg = palette.purple,
    },
    Boolean = {
        -- a boolean constant: TRUE, false
        guifg = palette.purple,
    },
    Character = {
        guifg = palette.yellow,
    },
    String = {
        guifg = palette.yellow,
    },
    Type = {
        -- int, long, char, etc.
        guifg = palette.aqua,
    },
    Structure = {
        -- struct, union, enum, etc.
        guifg = palette.aqua,
    },
    StorageClass = {
        -- static, register, volatile, etc.
        guifg = palette.aqua,
    },
    Typedef = {
        -- A typedef
        guifg = palette.aqua,
    },
    Identifier = {
        guifg = palette.white,
    },
    Function = {
        guifg = palette.green,
    },
    Statement = {
        -- any statement
        guifg = palette.pink,
    },
    Operator = {
        guifg = palette.pink,
    },
    Label = {
        -- case, default, etc.
        guifg = palette.pink,
    },
    Keyword = {
        guifg = palette.pink,
    },
    PreProc = {
        -- generic Preprocessor
        guifg = palette.green,
    },
    Include = {
        -- preprocessor #include
        guifg = palette.pink,
    },
    Define = {
        -- preprocessor #define
        guifg = palette.pink,
    },
    Macro = {
        -- same as Define
        guifg = palette.pink,
    },
    PreCondit = {
        -- preprocessor #if, #else, #endif, etc.
        guifg = palette.pink,
    },
    Special = {
        -- any special symbol
        guifg = palette.white,
    },
    SpecialChar = {
        -- special character in a constant
        guifg = palette.pink,
    },
    Delimiter = {
        guifg = palette.white,
    },
    SpecialComment = {
        -- special things inside a comment
        guifg = palette.grey,
    },
    Tag = {
        -- you can use CTRL-] on this
        guifg = palette.orange,
    },
    Todo = {
        -- anything that needs extra attention; mostly the keywords TODO FIXME
        -- and XXX
        guifg = palette.orange,
        -- guifg = palette.yellow,
        guibg = palette.none,
        style = 'bold,italic',
    },
    Comment = {
        guifg = palette.base6,
    },
    Underlined = {
        -- text that stands out, HTML links
        guifg = palette.none,
        style = 'underline',
    },
    Bold = {
        style = "bold",
    },
    Italic = {
        style = "italic",
    },
    Ignore = {
        -- left blank, hidden
        guifg = palette.none,
    },
    Error = {
        -- any erroneous construct
        guifg = palette.red,
    },
    Terminal = {
        guifg = palette.white,
        guibg = palette.base2,
    },
    EndOfBuffer = {
        guifg = palette.base2,
        guibg = palette.none,
    },
    Conceal = {
        -- placeholder characters substituted for concealed text (see
        -- 'conceallevel')
        guifg = palette.grey,
        guibg = palette.none,
    },
    vCursor = {
        -- the character under the cursor
        guifg = palette.none,
        guibg = palette.none,
        style = 'reverse',
    },
    iCursor = {
        guifg = palette.none,
        guibg = palette.none,
        style = 'reverse',
    },
    lCursor = {
        guifg = palette.none,
        guibg = palette.none,
        style = 'reverse',
    },
    CursorIM = {
        -- like Cursor, but used when in IME mode
        guifg = palette.none,
        guibg = palette.none,
        style = 'reverse',
    },
    CursorColumn = {
        -- Screen-column at the cursor, when 'cursorcolumn' is set.
        guifg = palette.none,
        guibg = palette.base3,
    },
    Whitespace = {
        -- "nbsp", "space", "tab" and "trail" in 'listchars'
        guifg = palette.base3,
    },
    WildMenu = {
        -- current match in 'wildmenu' completion
        guifg = palette.white,
        guibg = palette.orange,
    },
    QuickFixLine = {
        -- Current |quickfix| item in the quickfix window. Combined with
        -- |hl-CursorLine| when the cursor is there.
        guifg = palette.purple,
        style = 'bold',
    },
    qfLineNr = {
        -- Line numbers for quickfix lists
        guifg = palette.highlight,
        guibg = palette.title,
        style = 'reverse',
    },
    qfFileName = {
        guifg = palette.blue,
    },
    Debug = {
        -- debugging statements
        guifg = palette.orange,
    },
    debugBreakpoint = {
        guifg = palette.base2,
        guibg = palette.red,
    },
    Conditional = {
        guifg = palette.pink,
    },
    Repeat = {
        guifg = palette.pink,
    },
    Exception = {
        guifg = palette.pink,
    },
    htmlLink = {
        guifg = palette.link,
        style = 'underline',
    },
    htmlH1 = {
        guifg = palette.cyan,
        style = 'bold',
    },
    htmlH2 = {
        guifg = palette.red,
        style = 'bold',
    },
    mkdCodeDelimiter = {
        guibg = palette.terminal_black,
        guifg = palette.fg,
    },
    mkdCodeStart = {
        guifg = palette.teal,
        style = "bold",
    },
    mkdCodeEnd = {
        guifg = palette.teal,
        style = "bold",
    },
    markdownHeadingDelimiter = {
        guifg = palette.orange,
        style = "bold",
    },
    markdownCode = {
        guifg = palette.teal,
    },
    markdownCodeBlock = {
        guifg = palette.teal,
    },
    htmlH3 = {
        guifg = palette.green,
        style = 'bold',
    },
    htmlH4 = {
        guifg = palette.yellow,
        style = 'bold',
    },
    htmlH5 = {
        guifg = palette.purple,
        style = 'bold',
    },
    markdownH1 = {
        guifg = palette.cyan,
        style = 'bold',
    },
    markdownH2 = {
        guifg = palette.red,
        style = 'bold',
    },
    markdownLinkText = {
        guifg = palette.blue,
        style = "underline",
    },
    debugPC = {
        guibg = palette.bg_sidebar,
    }, -- used for highlighting the current line in terminal-debug
    markdownH3 = {
        guifg = palette.green,
        style = 'bold',
    },
    markdownH1Delimiter = {
        -- character that needs attention like , or .
        guifg = palette.cyan,
    },
    markdownH2Delimiter = {
        guifg = palette.red,
    },
    markdownH3Delimiter = {
        guifg = palette.green,
    },
    ExtraWhitespace = {
        guibg   = palette.darkred,
        ctermbg = palette.darkred,
    },
}

local plugin_syntax = {
    TSString = {
        guifg = palette.yellow,
    },
    TSStringRegex = {
        -- For regexes.
        guifg = palette.purple,
    },
    TSStringEscape = {
        -- For escape characters within a string.
        guifg = palette.purple,
    },
    TSInclude = {
        -- For includes: `#include` in C, `use` or `extern crate` in Rust, or
        -- `require` in Lua.
        guifg = palette.pink,
    },
    TSVariable = {
        guifg = palette.white,
    },
    TSVariableBuiltin = {
        guifg = palette.orange,
    },
    TSAnnotation = {
        -- For C++/Dart attributes, annotations that can be attached to the
        -- code to denote some kind of meta information.
        guifg = palette.green,
    },
    TSAttribute = {
        guifg = palette.yellow ,
    },
    TSBoolean = {
        -- For booleans.
        guifg = palette.orange,
    },
    TSComment = {
        guifg = palette.base6,
    },
    TSConstant = {
        guifg = palette.aqua,
    },
    TSConstBuiltin = {
        -- For constant that are built in the language: `nil` in Lua.
        guifg = palette.orange,
    },
    TSConstMacro = {
        -- For constants that are defined by macros: `NULL` in C.
        guifg = palette.purple,
    },
    TSError = {
        -- For syntax/parser errors.
        guifg = palette.error,
    },
    TSConditional = {
        guifg = palette.pink,
    },
    TSCharacter = {
        -- For characters.
        -- any character constant: 'c', '\n'
        guifg = palette.yellow,
    },
    TSConstructor = {
        -- For constructor calls and definitions: `= { }` in Lua, and Java
        -- constructors.
        guifg = palette.purple,
    },
    TSFunction = {
        guifg = palette.green,
    },
    TSFuncBuiltin = {
        guifg = palette.aqua,
    },
    TSFuncMacro = {
        -- For macro defined fuctions (calls and definitions): each
        -- `macro_rules` in Rust.
        guifg = palette.green,
    },
    TSKeyword = {
        guifg = palette.pink,
    },
    TSKeywordFunction = {
        guifg = palette.pink,
    },
    TSKeywordOperator = {
        -- sizeof", "+", "*", etc.
        guifg = palette.pink,
    },
    TSKeywordReturn = {
        guifg = palette.pink,
    },
    TSMethod = {
        guifg = palette.green,
    },
    TSNamespace = {
        -- For identifiers referring to modules and namespaces.
        guifg = palette.purple,
    },
    TSNumber = {
        guifg = palette.purple,
    },
    TSOperator = {
        -- For any operator: `+`, but also `->` and `*` in C.
        guifg = palette.pink,
    },
    TSParameter = {
        -- For parameters of a function.
        guifg = palette.white,
    },
    TSParameterReference = {
        -- For references to parameters of a function.
        guifg = palette.white,
    },
    TSProperty = {
        -- Same as `TSField`,accesing for struct members in C.
        guifg = palette.green
    },
    TSPunctDelimiter = {
        -- For delimiters ie: `.`
        guifg = palette.white,
    },
    TSPunctBracket = {
        -- For brackets and parens.
        guifg = palette.white,
    },
    TSPunctSpecial = {
        -- For special punctutation that does not fall in the catagories
        -- before.
        guifg = palette.pink,
    },
    TSRepeat = {
        guifg = palette.pink,
    },
    TSSymbol = {
        -- For identifiers referring to symbols or atoms.
        guifg = palette.yellow,
    },
    TSTag = {
        -- Tags like html tag names.
        guifg = palette.pink,
    },
    TSTagDelimiter = {
        -- Tag delimiter like `<` `>` `/`
        guifg = palette.white,
    },
    TSText = {
        -- For strings considered text in a markup language.
        guifg = palette.text,
    },
    TSTextReference = {
        guifg = palette.yellow,
    },
    TSEmphasis = {
        -- For text to be represented with emphasis.
        guifg = palette.paleblue,
    },
    TSUnderline = {
        -- For text to be represented with an underline.
        guifg = palette.fg,
        guibg = palette.none,
        style = 'underline',
    },
    TSTitle = {
        -- Text that is part of a title.
        guifg = palette.title,
        guibg = palette.none,
        style = 'bold',
    },
    TSLiteral = {
        -- Literal text.
        guifg = palette.fg,
    },
    TSURI = {
        -- Any URI like a link or email.
        guifg = palette.link,
    },
    TSTagAttribute = {
        guifg = palette.green,
    },
    TSLabel = {
        -- For labels: `label:` in C and `:label:` in Lua.
        guifg = palette.pink,
    },
    TSType = {
        -- For types.
        guifg = palette.aqua,
    },
    TSTypeBuiltin = {
        -- For builtin types.
        guifg = palette.purple,
    },
    TSException = {
        -- For exception related keywords.  try, catch, throw
        guifg = palette.pink
    },
    TSField = {
        -- For fields.
        guifg = palette.white
    },
    TSFloat = {
        guifg = palette.purple
    },
    TSNote = {
        guifg = palette.bg,
        guibg = palette.info,
    },
    TSWarning = {
        guifg = palette.bg,
        guibg = palette.warning,
    },
    TSDanger = {
        guifg = palette.bg,
        guibg = palette.error,
    },

    LspDiagnosticsDefaultError = {
        -- used for "Error" diagnostic virtual text
        guifg = palette.error,
    },
    LspDiagnosticsError = {
        guifg = palette.error,
    },
    LspDiagnosticsWarning = {
        guifg = palette.yellow,
    },
    LspDiagnosticsInformation = {
        guifg = palette.paleblue,
    },
    LspDiagnosticsHint = {
        guifg = palette.purple,
    },
    LspDiagnosticsSignError = {
        -- used for "Error" diagnostic signs in sign column
        guifg = palette.red,
        guibg = palette.base2,
    },
    LspDiagnosticsFloatingError = {
        -- used for "Error" diagnostic messages in the diagnostics float
        guifg = palette.error,
    },
    LspDiagnosticsSignWarning = {
        -- used for "Warning" diagnostic signs in sign column
        guifg = palette.yellow,
        guibg = palette.base2,
    },
    LspDiagnosticsFloatingWarning = {
        -- used for "Warning" diagnostic messages in the diagnostics float
        guifg = palette.yellow,
    },
    LspDiagnosticsSignInformation = {
        -- used for "Information" diagnostic signs in sign column
        guibg = palette.base2,
        guifg = palette.white,
    },
    LspDiagnosticsFloatingInformation = {
        -- used for "Information" diagnostic messages in the diagnostics float
        guifg = palette.paleblue,
    },
    LspDiagnosticsSignHint = {
        -- used for "Hint" diagnostic signs in sign column
        guifg = palette.aqua,
        guibg = palette.base2,
    },
    LspDiagnosticsFloatingHint = {
        -- used for "Hint" diagnostic messages in the diagnostics float
        guifg = palette.purple,
    },
    LspDiagnosticsVirtualTextError = {
        -- Virtual text "Error"
        guifg = palette.red,
    },
    LspDiagnosticsVirtualTextWarning = {
        -- Virtual text "Warning"
        guifg = palette.yellow,
    },
    LspDiagnosticsVirtualTextInformation = {
        -- Virtual text "Information"
        guifg = palette.white,
    },
    LspDiagnosticsVirtualTextHint = {
        -- Virtual text "Hint"
        guifg = palette.aqua,
    },
    LspDiagnosticsUnderlineError = {
        -- used to underline "Error" diagnostics.
        -- style = 'undercurl',
        guisp = palette.red,
    },
    LspDiagnosticsDefaultWarning = {
        -- used for "Warning" diagnostic signs in sign column
        guifg = palette.yellow,
    },
    LspDiagnosticsUnderlineWarning = {
        -- used to underline "Warning" diagnostics.
        -- style = 'undercurl',
        guisp = palette.yellow,
    },
    LspDiagnosticsDefaultInformation = {
        -- used for "Information" diagnostic virtual text
        guifg = palette.paleblue,
    },
    LspDiagnosticsUnderlineInformation = {
        -- used to underline "Information" diagnostics.
        -- style = 'undercurl',
        guisp = palette.white,
    },
    LspDiagnosticsDefaultHint = {
        -- used for "Hint" diagnostic virtual text
        guifg = palette.purple,
    },
    LspDiagnosticsUnderlineHint = {
        -- used to underline "Hint" diagnostics.
        -- style = 'undercurl',
        guisp = palette.aqua,
    },
    LspSignatureActiveParameter = {
        guifg =palette.orange,
    },
    LspCodeLens = {
        guifg = palette.comment,
    },
    LspFloatWinNormal = {
        guibg = palette.paleblue,
    },
    LspFloatWinBorder = {
        guifg = palette.border_highlight,
    },
    LspSagaBorderTitle = {
        guifg = palette.cyan,
    },
    LspSagaHoverBorder = {
        guifg = palette.blue,
    },
    LspSagaRenameBorder = {
        guifg = palette.green,
    },
    LspSagaDefPreviewBorder = {
        guifg = palette.green,
    },
    LspSagaCodeActionBorder = {
        guifg = palette.blue,
    },
    LspSagaFinderSelection = {
        guifg = palette.bg_visual,
    },
    LspSagaCodeActionTitle = {
        guifg = palette.blue1,
    },
    LspSagaCodeActionContent = {
        guifg = palette.purple,
    },
    LspSagaSignatureHelpBorder = {
        guifg = palette.red,
    },
    LspLinesDiagBorder =	{
        guifg = palette.contrast,
    },
    LspReferenceText = {
        -- used for highlighting "text" references
        guifg = palette.accent,
        guibg = palette.highlight,
    },
    LspReferenceRead = {
        -- used for highlighting "read" references
        guifg = palette.accent,
        guibg = palette.highlight,
    },
    LspReferenceWrite = {
        -- used for highlighting "write" references
        guifg = palette.accent,
        guibg = palette.highlight,
    },
    LspTroubleText = {
        guifg = palette.text,
    },
    LspTroubleCount = {
        guifg = palette.purple,
        guibg = palette.active,
    },
    LspTroubleNormal = {
        guifg = palette.fg,
        guibg = palette.sidebar,
    },

    ALEErrorSign = {
        guifg = palette.error,
        guibg = palette.base2,
    },
    ALEWarningSign = {
        guifg = palette.warning,
        guibg = palette.base2,
    },
    DiagnosticError = {
        guifg = palette.error,
    },
    DiagnosticWarning = {
        guifg = palette.yellow,
    },
    DiagnosticInformation = {
        guifg = palette.paleblue,
    },
    DiagnosticHint = {
        guifg = palette.purple,
    },
    illuminatedWord = {
        guibg = palette.fg_gutter,
    },
    illuminatedCurWord = {
        guibg = palette.fg_gutter,
    },
    CursorWord0 = {
        guibg = palette.white,
        guifg = palette.black,
    },
    CursorWord1 = {
        guibg = palette.white,
        guifg = palette.black,
    },

    NvimTreeFolderName = {
        guifg = palette.white,
    },
    NvimTreeFolderIcon= {
        guifg = palette.accent,
    },
    NvimTreeEmptyFolderName= {
        guifg = palette.disabled,
    },
    NvimTreeOpenedFolderName= {
        guifg = palette.accent,
        style = 'italic',
    },
    NvimTreeIndentMarker = {
        guifg = palette.disabled,
    },
    NvimTreeGitDirty = {
        guifg = palette.blue,
    },
    NvimTreeGitNew = {
        guifg = palette.green,
    },
    NvimTreeGitStaged = {
        guifg = palette.comments,
    },
    NvimTreeGitDeleted = {
        guifg = palette.red,
    },
    NvimTreeOpenedFile = {
        guifg = palette.accent,
    },
    NvimTreeImageFile = {
        guifg = palette.yellow,
    },
    NvimTreeMarkdownFile = {
        guifg = palette.pink,
    },
    NvimTreeExecFile = {
        guifg = palette.green,
    },
    NvimTreeRootFolder = {
        guifg = palette.pink,
    },
    NvimTreeSpecialFile = {
        guifg = palette.white,
        guibg = palette.none,
        style = 'NONE',
    },
    NvimTreeNormal = {
        guifg = palette.fg_sidebar,
        guibg = palette.bg_sidebar,
    },

    GitSignsAdd = {
        guifg = palette.green,
        guibg = palette.base2,
    },
    GitSignsAddNr = {
        guifg = palette.green,
        guibg = palette.base2,
    },
    GitSignsAddLn = {
        guifg = palette.green,
        guibg = palette.base2,
    },
    GitSignsChange = {
        guifg = palette.blue,
        guibg = palette.base2,
    },
    GitSignsChangeNr = {
        guifg = palette.blue,
        guibg = palette.base2,
    },
    GitSignsChangeLn = {
        guifg = palette.blue,
        guibg = palette.base2,
    },
    GitSignsDelete = {
        guifg = palette.red,
        guibg = palette.base2,
    },
    GitSignsDeleteNr = {
        guifg = palette.red,
        guibg = palette.base2,
    },
    GitSignsDeleteLn = {
        guifg = palette.red,
        guibg = palette.base2,
    },
}

local setup = function()
    require('util').profiler('setting up the theme', function()
        vim.cmd('hi clear')
        if vim.fn.exists('syntax_on') then
            vim.cmd('syntax reset')
        end

        local highlight = require('util').highlight
        vim.g.colors_name = palette.name
        for group, colors in pairs(mappings) do
            highlight(group, colors)
        end
        local async_load_plugin = nil
        async_load_plugin = vim.loop.new_async(vim.schedule_wrap( function()
            for group, colors in pairs(plugin_syntax) do
                highlight(group, colors)
            end
            async_load_plugin:close()
        end))
        async_load_plugin:send()
        vim.cmd[[ match ExtraWhitespace /\\s\\+$/ ]]
    end)
end

return {
    setup = setup
}
