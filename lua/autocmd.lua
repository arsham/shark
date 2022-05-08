local nvim = require("nvim")

-- Packer Reload {{{
local packer_reload_group = vim.api.nvim_create_augroup("PACKER_RELOAD", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = packer_reload_group,
  pattern = "lua/plugins.lua",
  callback = function()
    nvim.ex.source("<afile>")
    nvim.ex.PackerCompile()
    nvim.ex.PackerInstall()
  end,
  desc = "auto compile and install new plugins",
}) --}}}

-- Line Return {{{
local line_return_group = vim.api.nvim_create_augroup("LINE_RETURN", { clear = true })
vim.api.nvim_create_autocmd("BufRead", {
  group = line_return_group,
  pattern = "*",
  callback = function()
    vim.api.nvim_create_autocmd("FileType", {
      buffer = 0,
      once = true,
      callback = function()
        local types = _t({
          "nofile",
          "fugitive",
          "gitcommit",
          "gitrebase",
          "commit",
          "rebase",
        })
        if vim.fn.expand("%") == "" or types:contains(vim.bo.filetype) then
          return
        end
        local line = vim.fn.line

        if line("'\"") > 0 and line("'\"") <= line("$") then
          nvim.ex.normal_([[g`"zv']])
        end
      end,
    })
  end,
}) --}}}

local special_settings_group = vim.api.nvim_create_augroup("SPECIAL_SETTINGS", { clear = true })
-- Resize Split On Resize {{{
vim.api.nvim_create_autocmd("VimResized", {
  group = special_settings_group,
  pattern = "*",
  command = "wincmd =",
  desc = "resize split on window resize",
}) --}}}

-- Large File Enhancements {{{
vim.api.nvim_create_autocmd("BufRead", {
  group = special_settings_group,
  pattern = "*",
  desc = "large file enhancements.",
  callback = function()
    if vim.fn.expand("%:t") == "lsp.log" or vim.bo.filetype == "help" then
      return
    end

    local size = vim.fn.getfsize(vim.fn.expand("%"))
    if size > 1024 * 1024 * 5 then
      local hlsearch = vim.opt.hlsearch
      local lazyredraw = vim.opt.lazyredraw
      local showmatch = vim.opt.showmatch

      vim.bo.undofile = false
      vim.wo.colorcolumn = ""
      vim.wo.relativenumber = false
      vim.wo.foldmethod = "manual"
      vim.wo.spell = false
      vim.opt.hlsearch = false
      vim.opt.lazyredraw = true
      vim.opt.showmatch = false

      vim.api.nvim_create_autocmd("BufDelete", {
        buffer = 0,
        callback = function()
          vim.opt.hlsearch = hlsearch
          vim.opt.lazyredraw = lazyredraw
          vim.opt.showmatch = showmatch
        end,
        desc = "set the global settings back to what they were before",
      })
    end
  end,
}) --}}}

-- No Undo Fies {{{
vim.api.nvim_create_autocmd("BufWritePre", {
  group = special_settings_group,
  pattern = { "COMMIT_EDITMSG", "MERGE_MSG", "gitcommit", "*.tmp", "*.log" },
  callback = function()
    vim.bo.undofile = false
  end,
}) --}}}

-- Relative Number Toggling {{{
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "WinEnter", "InsertLeave" }, {
  group = special_settings_group,
  pattern = "*",
  callback = function()
    if vim.g.disable_relative_numbers then
      return
    end
    if vim.fn.expand("%:t") == "lsp.log" or vim.bo.filetype == "help" then
      return
    end

    local lines = vim.api.nvim_buf_line_count(0)
    if lines < 20000 then
      if vim.wo.number and vim.fn.mode() ~= "i" then
        vim.wo.relativenumber = true
      end
    end
  end,
  desc = "set relative number when focused",
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "WinLeave", "InsertEnter" }, {
  group = special_settings_group,
  pattern = "*",
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
  desc = "unset relative number when unfocused",
}) --}}}

-- Terminal Start Insert Mode {{{
vim.api.nvim_create_autocmd("TermOpen", {
  group = special_settings_group,
  pattern = "term:\\/\\/*",
  callback = function()
    vim.wo.statusline = "%{b:term_title}"
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = true, desc = "enter normal mode" })
    nvim.ex.startinsert()
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
  desc = "start in insert mode and set the status line",
}) --}}}

-- Autoclose Shell Terminals {{{
-- See neovim/neovim#15440
vim.api.nvim_create_autocmd("TermClose", {
  group = special_settings_group,
  pattern = "*",
  callback = function()
    if vim.v.event.status == 0 then
      local info = vim.api.nvim_get_chan_info(vim.opt.channel._value)
      if info and info.argv[1] == vim.env.SHELL then
        pcall(vim.api.nvim_buf_delete, 0, {})
      end
    end
  end,
  desc = "auto close shell terminals",
}) --}}}

-- Create Missing Parent Directories {{{
vim.api.nvim_create_autocmd("BufNewFile", {
  group = special_settings_group,
  pattern = "*",
  callback = function()
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = 0,
      once = true,
      callback = function()
        local path = vim.fn.expand("%:h")
        local p = require("plenary.path"):new(path)
        if not p:exists() then
          p:mkdir({ parents = true })
        end
      end,
      desc = "create missing parent directories automatically",
    })
  end,
}) --}}}

-- Tmux Automatic Rename {{{
if vim.fn.exists("$TMUX") == 1 then
  local tmux_rename_group = vim.api.nvim_create_augroup("TMUX_RENAME", { clear = true })
  vim.api.nvim_create_autocmd("BufEnter", {
    group = tmux_rename_group,
    pattern = "*",
    callback = function()
      if vim.bo.buftype == "" then
        local bufname = vim.fn.expand("%:t:S")
        pcall(vim.fn.system, "tmux rename-window " .. bufname)
      end
    end,
  })

  vim.api.nvim_create_autocmd("VimLeave", {
    group = special_settings_group,
    pattern = "*",
    callback = function()
      pcall(vim.fn.system, "tmux set-window automatic-rename on")
    end,
  })
end --}}}

local filetype_commands_group = vim.api.nvim_create_augroup("FILETYPE_COMMANDS", { clear = true })
-- Makefile Tabs {{{
vim.api.nvim_create_autocmd("Filetype", {
  group = filetype_commands_group,
  pattern = "make,automake",
  desc = "makefile tabs",
  callback = function()
    vim.bo.expandtab = false
  end,
}) --}}}

-- Aliase Filetype {{{
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = filetype_commands_group,
  pattern = ".*aliases",
  callback = function()
    vim.bo.filetype = "sh"
  end,
}) --}}}

-- Makefile filetype {{{
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = filetype_commands_group,
  pattern = "Makefile*",
  callback = function()
    vim.bo.filetype = "make"
  end,
}) --}}}

-- Highlight Yanks {{{
vim.api.nvim_create_autocmd("TextYankPost", {
  group = filetype_commands_group,
  pattern = "*",
  desc = "highlihgt yanking",
  callback = function()
    vim.highlight.on_yank({ higroup = "Substitute", timeout = 150 })
  end,
}) --}}}

-- Close LSP Info Popup {{{
vim.api.nvim_create_autocmd("FileType", {
  group = filetype_commands_group,
  pattern = { "lspinfo", "lsp-installer", "null-ls-info" },
  callback = function()
    local opts = { buffer = true, silent = true, desc = "close lspinfo popup" }
    vim.keymap.set("n", "q", nvim.ex.close, opts)
  end,
  desc = "close lspinfo popup",
}) --}}}

-- Don't Wrap Me {{{
vim.api.nvim_create_autocmd("Filetype", {
  group = filetype_commands_group,
  pattern = { "sql", "sqls" },
  desc = "don't wrap me",
  callback = function()
    vim.opt_local.formatoptions:remove({ "t", "c" })
  end,
}) --}}}

-- Exit Help/man/qf With q {{{
vim.api.nvim_create_autocmd("Filetype", {
  group = filetype_commands_group,
  pattern = { "help", "man", "qf" },
  desc = "exit help with q",
  callback = function()
    local opts = { buffer = true, desc = "close help/man,qf buffers" }
    vim.keymap.set("n", "q", nvim.ex.close, opts)
  end,
}) --}}}

local async_load_plugin = nil --{{{
async_load_plugin = vim.loop.new_async(vim.schedule_wrap(function()
  local trim_whitespace_group = vim.api.nvim_create_augroup("TRIM_WHITESPACE", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePre", "FileWritePre", "FileAppendPre", "FilterWritePre" }, {
    group = trim_whitespace_group,
    pattern = "*",
    desc = "trim spaces",
    callback = function()
      if not vim.bo.modifiable or vim.bo.binary or vim.bo.filetype == "diff" then
        return
      end
      local save = vim.fn.winsaveview()
      nvim.ex.keeppatterns([[%s/\s\+$//e]])
      nvim.ex.silent_([[%s#\($\n\s*\)\+\%$##]])
      vim.fn.winrestview(save)
    end,
  })
  async_load_plugin:close()
end))
async_load_plugin:send() --}}}

-- vim: fdm=marker fdl=0
