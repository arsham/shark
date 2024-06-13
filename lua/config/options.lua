vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Visual {{{
vim.opt.termguicolors = true
vim.opt.pumheight = 20
vim.opt.cmdheight = 1
vim.opt.title = true
vim.opt.titlestring:append("%t")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.lazyredraw = false
vim.opt.laststatus = 3
vim.opt.signcolumn = "auto:3"

vim.opt.scrolloff = 3 -- keep 3 lines visible while scrolling
vim.opt.sidescrolloff = 15
vim.opt.sidescroll = 1
-- }}}

-- Indentation {{{
vim.opt.autoindent = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.expandtab = true
-- }}}

vim.opt.mouse = ""
vim.g.ts_highlight_lua = true
vim.opt.exrc = true

-- Navigation {{{
vim.opt.hidden = true
vim.opt.whichwrap:append("h,l")
-- }}}

-- Editing {{{
vim.opt.formatoptions:append("n") -- smart auto-indent numbered lists.
vim.opt.linebreak = true -- Wrap lines at convenient points
-- }}}

-- Presentation {{{
vim.opt.textwidth = 79
vim.opt.colorcolumn = "80,120"
vim.opt.wrap = false
vim.opt.conceallevel = 2
vim.opt.list = true
vim.opt.listchars = {
  tab = "  ",
  trail = "·",
  extends = "◣",
  precedes = "◢",
  nbsp = "○",
}
-- }}}

vim.opt.synmaxcol = 256
vim.opt.history = 10000

vim.opt.shada = "!,'10000,<1000,s100,h,f1,:100000,@10000,/1000"
vim.opt.showcmd = true
vim.opt.showmode = true

-- Shortmess {{{
-- f -> Use "(3 of 5)" instead of "(file 3 of 5)"
-- i -> Use "[noeol]" instead of "[Incomplete last line]"
-- l -> Use "999L, 888C" instead of "999 lines, 888 characters"
-- m -> Use "[+]" instead of "[Modified]"
-- n -> Use "[New]" instead of "[New File]"
-- r -> Use "[RO]" instead of "[readonly]"
-- x -> Use "[dos]" instead of "[dos format]", "[unix]" instead of [unix format]" and "[mac]" instead of "[mac format]".
-- a -> All of the above abbreviations
-- o -> Overwrite message for writing a file with subsequent message for reading a file (useful for ":wn" or when 'autowrite' on)
-- O -> Message for reading a file overwrites any previous message.  Also for quickfix message (e.g., ":cn").
-- t -> Truncate file message at the start if it is too long to fit on the command-line, "<" will appear in the left most column.  Ignored in Ex mode.
-- T -> Truncate other messages in the middle if they are too long to fit on the command line.  "..." will appear in the middle.  Ignored in Ex mode.
-- A -> Don't give the "ATTENTION" message when an existing swap file is found.
-- I -> Don't give the intro message when starting Vim |:intro|.
-- c -> Avoid showing message extra message when using completion
vim.opt.shortmess:append("filmnrxoOtTAIcCs")
-- }}}

vim.opt.viewoptions:append("localoptions")
vim.opt.viewdir = vim.fs.normalize("~/.cache/nvim/views")

-- Better diff view {{{
-- This will make sure the inserted part is separated, rather than mangled in
-- the previous blob.
vim.opt.diffopt:append("indent-heuristic")
vim.opt.diffopt:append("algorithm:patience")
vim.opt.diffopt:append("context:3")
vim.opt.diffopt:append("foldcolumn:1")
vim.opt.diffopt:append("linematch:60")
vim.opt.suffixesadd = {
  ".go",
  ".py",
  ".lua",
}
-- }}}

-- Wildmenu {{{
-- enable ctrl-n and ctrl-p to scroll through matches
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignorecase = true

-- stuff to ignore when tab completing
vim.opt.wildignore = {
  "*~",
  "*.o",
  "*.obj",
  "*.so",
  "*vim/backups*",
  "*.git/**",
  "**/.git/**",
  "*sass-cache*",
  "*DS_Store*",
  "vendor/rails/**",
  "vendor/cache/**",
  "*.gem",
  "*.pyc",
  "log/**",
  "*.png",
  "*.jpg",
  "*.gif",
  "*.zip",
  "*.bg2",
  "*.gz",
  "*.db",
  "**/node_modules/**",
  "**/bin/**",
  "**/thesaurus/**",
}
-- }}}

vim.opt.omnifunc = "syntaxcomplete#Complete"
vim.opt.updatetime = 50

-- adds <> to % matchpairs
vim.opt.matchpairs:append("<:>")
vim.opt.complete = ".,w,b,u,t,i"
vim.opt.nrformats = "bin,hex,alpha" -- can increment alphabetically too!

-- Folding {{{
vim.opt.foldnestmax = 3
vim.opt.foldlevelstart = 3
vim.g.markdown_folding = 1
-- }}}

-- Language support {{{
vim.opt.spelllang = "en_gb"
vim.opt.spell = false
vim.opt.thesaurus = vim.fs.normalize("~/.local/share/thesaurus/moby.txt")
-- install words-insane package
vim.opt.dictionary = {
  "/usr/share/dict/words-insane",
}

local spellfile = vim.fs.normalize("~/.config/nvim/spell")
vim.opt.spellfile = spellfile .. "/en.utf-8.add"
-- }}}

-- Search {{{
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "nosplit" -- live substitution preview in another buffer
-- Searches current directory recursively.
vim.opt.path = ".,**,~/.config/nvim/**"
vim.opt.showmatch = true

local ok, is_exe = pcall(vim.fn.executable, "rg")
if ok and is_exe == 1 then
  vim.opt.grepprg = "rg --vimgrep --smart-case --follow --hidden"
  vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end
-- }}}

-- let the visual block mode go over empty characters.
vim.opt.virtualedit = "block"
vim.opt.modeline = true

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.fillchars = {
  horizup = "┻",
  horiz = "━",
  horizdown = "┳",
  vert = "┃",
  vertright = "┣",
  vertleft = "┫",
  verthoriz = "╋",
  diff = "╱",
}

vim.opt.sessionoptions:append("tabpages,globals")

-- Undo / Backup {{{
vim.opt.undofile = true
vim.opt.undolevels = 10000
local undodir = "~/.cache/nvim/undodir"
local backdir = "~/.cache/nvim/backdir"

vim.opt.undodir = vim.fs.normalize(undodir)
vim.opt.backupdir = vim.fs.normalize(backdir)
vim.opt.directory = vim.fs.normalize(backdir)
-- }}}

-- Netrw plugin {{{
vim.g.netrw_winsize = 20
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_browsex_viewer = "xdg-open"
-- }}}

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noinsert,noselect"

vim.g.markdown_fenced_languages = { -- {{{
  "vim",
  "lua",
  "cpp",
  "sql",
  "python",
  "zsh=sh",
  "bash=sh",
  "console=sh",
  "javascript",
  "typescript",
  "js=javascript",
  "ts=typescript",
  "yaml",
  "json",
  "go",
} -- }}}

vim.api.nvim_command("set rtp-=/usr/share/vim/vimfiles")

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

vim.g.python3_host_prog = "/usr/bin/python3"

vim.filetype.add({ -- {{{
  pattern = {
    [".*aliases"] = "zsh",
    [".gitignore"] = "conf",
    ["**/systemd/**/*.service"] = "systemd",
    [".*[mM]akefile*"] = "make",
    ["README.(a+)$"] = function(_, _, ext)
      if ext == "md" then
        return "markdown"
      elseif ext == "rst" then
        return "rst"
      end
    end,
  },
}) -- }}}

-- vim: fdm=marker fdl=0
