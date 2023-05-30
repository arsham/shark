local lsp = require("arshlib.lsp")
local augroup = require("config.util").augroup
local constants = require("config.constants")

-- Highlight Yanks {{{
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("HIGHLIGHT_YANKS"),
  desc = "Highlihgt yanking",
  callback = function()
    vim.highlight.on_yank({ higroup = "Substitute", timeout = 300 })
  end,
}) --}}}

-- Line Return {{{
vim.api.nvim_create_autocmd("BufReadPre", {
  group = augroup("LINE_RETURN"),
  desc = "Auto line return",
  callback = function()
    vim.api.nvim_create_autocmd("FileType", {
      buffer = 0,
      once = true,
      callback = function()
        local types = {
          "nofile",
          "fugitive",
          "gitcommit",
          "gitrebase",
          "commit",
          "rebase",
        }
        if vim.fn.expand("%") == "" then
          return
        end

        for _, item in pairs(types) do
          if item == vim.bo.filetype then
            return
          end
        end
        local line = vim.fn.line

        if line([['"]]) > 0 and line([['"]]) <= line("$") then
          pcall(vim.cmd.normal, { [[g`"zv']], bang = true })
        end
      end,
    })
  end,
}) --}}}

-- No Undo Files {{{
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("NO_UNDO_FILES"),
  pattern = { "COMMIT_EDITMSG", "MERGE_MSG", "gitcommit", "*.tmp", "*.log" },
  callback = function()
    vim.bo.undofile = false
  end,
}) --}}}

-- Relative Number Toggling {{{
local relative_line_toggle_group = augroup("RELATIVE_NUMBER_TOGGLE")
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "WinEnter", "InsertLeave" }, {
  group = relative_line_toggle_group,
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
  desc = "Set relative number when focused",
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "WinLeave", "InsertEnter" }, {
  group = relative_line_toggle_group,
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
  desc = "Unset relative number when unfocused",
}) --}}}

-- Autoclose Shell Terminals {{{
-- See neovim/neovim#15440
vim.api.nvim_create_autocmd("TermClose", {
  group = augroup("AUTOCLOSE_SHELL_TERMINALS"),
  callback = function()
    if vim.v.event.status == 0 then
      local info = vim.api.nvim_get_chan_info(vim.opt.channel._value)
      if not info or not info.argv then
        return
      end
      if info.argv[1] == vim.env.SHELL then
        pcall(vim.api.nvim_buf_delete, 0, {})
      end
    end
  end,
  desc = "Auto close shell terminals",
}) --}}}

-- Create Missing Parent Directories {{{
vim.api.nvim_create_autocmd("BufNewFile", {
  group = augroup("CREATE_MISSING_PARENT_DIRECTORIES"),
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
      desc = "Create missing parent directories automatically",
    })
  end,
}) --}}}

-- Tmux Automatic Rename {{{
if vim.fn.exists("$TMUX") == 1 then
  local tmux_rename_group = augroup("TMUX_RENAME")
  vim.api.nvim_create_autocmd("BufEnter", {
    group = tmux_rename_group,
    callback = function()
      if vim.bo.buftype == "" then
        local bufname = vim.fn.expand("%:t:S")
        vim.schedule(function()
          pcall(vim.fn.system, "tmux rename-window " .. bufname)
        end)
      end
    end,
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = tmux_rename_group,
    callback = function()
      pcall(vim.fn.system, "tmux set-window automatic-rename on")
    end,
  })
end --}}}

-- Keep Makefile Tabs {{{
vim.api.nvim_create_autocmd("Filetype", {
  group = augroup("MAKEFILE_TABS"),
  pattern = "make,automake",
  desc = "Keep Makefile tabs",
  callback = function()
    vim.bo.expandtab = false
  end,
}) --}}}

-- Close Info Popups {{{
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("CLOSE_INFO_POPUPS"),
  pattern = {
    "help",
    "lsp-installer",
    "lspinfo",
    "null-ls-info",
    "qf",
    "startuptime",
    "tsplayground",
    "checkhealth",
  },
  callback = function(args)
    local bufnr = args.buf
    local opts = {
      buffer = bufnr or true,
      silent = true,
      desc = "close lspinfo popup and help,qf buffers",
    }
    vim.keymap.set("n", "q", function()
      local ok = pcall(vim.cmd.close)
      if not ok then
        -- This is the last window, let's wipe it out then.
        vim.cmd.bdelete(bufnr or 0)
      end
    end, opts)
  end,
  desc = "Close lspinfo popup and help,qf buffers with q",
}) --}}}

-- Make quickfix list take the whole horizontal space {{{
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("QUICKFIX_LIST_SIZE"),
  pattern = "qf",
  callback = function()
    local win_id = vim.fn.win_getid()
    local is_loc = vim.fn.getwininfo(win_id)[1].loclist == 1
    if not is_loc then
      vim.cmd.wincmd("J")
    end
  end,
  desc = "Make quickfix list take the whole horizontal space",
}) --}}}

-- Trim Whitespaces {{{
vim.api.nvim_create_autocmd({ "BufWritePre", "FileWritePre", "FileAppendPre", "FilterWritePre" }, {
  group = augroup("TRIM_WHITESPACES"),
  desc = "trim spaces",
  callback = function()
    if not vim.bo.modifiable or vim.bo.binary or vim.bo.filetype == "diff" then
      return
    end
    local ok, val = pcall(vim.api.nvim_buf_get_var, 0, constants.trim_whitespace_variable)
    if ok and val then
      return
    end
    local save = vim.fn.winsaveview()
    vim.api.nvim_command([[keeppatterns %s/\s\+$//e]])
    vim.api.nvim_command([[silent! %s#\($\n\s*\)\+\%$##]])
    vim.fn.winrestview(save)
  end,
})
-- }}}

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave", "BufWinEnter" }, {
  group = augroup("CHECKTIME"),
  callback = function()
    pcall(vim.cmd.checktime)
  end,
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
  group = augroup("PREVIEW_SET_WRAP"),
  desc = "Set wrap for preview windows",
  callback = function()
    if vim.opt.previewwindow:get() then
      vim.wo.wrap = true
    end
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = augroup("go_mod_wrap"),
  pattern = "go.mod",
  callback = function()
    vim.opt_local.formatoptions:remove({ "t" })
  end,
  once = true,
  desc = "don't wrap me",
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("go_mod_tidy"),
  pattern = "go.mod",
  callback = function(args)
    local filename = vim.fn.expand("%:p")
    lsp.go_mod_tidy(tonumber(args.buf), filename)
  end,
  desc = "run go mod tidy on save",
})

-- vim: fdm=marker fdl=0
