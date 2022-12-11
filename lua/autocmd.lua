-- Packer Reload {{{
local packer_reload_group = vim.api.nvim_create_augroup("PACKER_RELOAD", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = packer_reload_group,
  pattern = "lua/plugins.lua",
  callback = function(args)
    vim.cmd.source(args.file)
    vim.cmd.PackerCompile()
  end,
  desc = "auto compile plugins module after save",
})

vim.api.nvim_create_autocmd("User", {
  group = packer_reload_group,
  pattern = "PackerCompileDone",
  callback = function()
    vim.cmd.PackerInstall()
  end,
  desc = "auto install new plugins after compilation",
}) --}}}

-- Line Return {{{
vim.api.nvim_create_autocmd("BufRead", {
  group = vim.api.nvim_create_augroup("LINE_RETURN", {}),
  desc = "auto line return",
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
          vim.cmd.normal({ [[g`"zv']], bang = true })
        end
      end,
    })
  end,
}) --}}}

local special_settings_group = vim.api.nvim_create_augroup("SPECIAL_SETTINGS", { clear = true })
-- Resize Split On Resize {{{
vim.api.nvim_create_autocmd("VimResized", {
  group = special_settings_group,
  command = "wincmd =",
  desc = "resize split on window resize",
}) --}}}

-- Large File Enhancements {{{
vim.api.nvim_create_autocmd("BufRead", {
  group = special_settings_group,
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

-- No Undo Files {{{
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
    vim.cmd.startinsert()
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
  desc = "start in insert mode and set the status line",
}) --}}}

-- Autoclose Shell Terminals {{{
-- See neovim/neovim#15440
vim.api.nvim_create_autocmd("TermClose", {
  group = special_settings_group,
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
  desc = "auto close shell terminals",
}) --}}}

-- Create Missing Parent Directories {{{
vim.api.nvim_create_autocmd("BufNewFile", {
  group = special_settings_group,
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
    callback = function()
      if vim.bo.buftype == "" then
        local bufname = vim.fn.expand("%:t:S")
        pcall(vim.fn.system, "tmux rename-window " .. bufname)
      end
    end,
  })

  vim.api.nvim_create_autocmd("VimLeave", {
    group = special_settings_group,
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

vim.filetype.add({
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
})

-- Highlight Yanks {{{
vim.api.nvim_create_autocmd("TextYankPost", {
  group = filetype_commands_group,
  desc = "highlihgt yanking",
  callback = function()
    vim.highlight.on_yank({ higroup = "Substitute", timeout = 300 })
  end,
}) --}}}

-- Close LSP Info Popup {{{
vim.api.nvim_create_autocmd("FileType", {
  group = filetype_commands_group,
  pattern = { "lspinfo", "lsp-installer", "null-ls-info", "help", "qf" },
  callback = function()
    local opts = { buffer = true, silent = true, desc = "close lspinfo popup and help,qf buffers" }
    vim.keymap.set("n", "q", function()
      vim.cmd.close()
    end, opts)
  end,
  desc = "close lspinfo popup and help,qf buffers with q",
}) --}}}

local trim_whitespace_group = vim.api.nvim_create_augroup("TRIM_WHITESPACE", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre", "FileWritePre", "FileAppendPre", "FilterWritePre" }, {
  group = trim_whitespace_group,
  desc = "trim spaces",
  callback = function()
    if not vim.bo.modifiable or vim.bo.binary or vim.bo.filetype == "diff" then
      return
    end
    local ok, val = pcall(vim.api.nvim_buf_get_var, 0, "DISABLE_TRIM_WHITESPACES")
    if ok and val then
      return
    end
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_command([[keeppatterns %s/\s\+$//e]])
    vim.api.nvim_command([[silent! %s#\($\n\s*\)\+\%$##]])
    vim.api.nvim_win_set_cursor(0, cursor)
  end,
})


vim.api.nvim_create_augroup("RELOAD_CONFIGS", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "RELOAD_CONFIGS",
  pattern = "*/shark/lua/*.lua",
  callback = function(args)
    vim.notify("Reloaded " .. args.file)
    vim.cmd.source("<afile>")
  end,
})

-- vim: fdm=marker fdl=0
