local nvim = require('nvim')
local util = require('settings.fzf.util')
local command = require('util').command

command("GGrep",  util.git_grep, {bang=true, nargs="+"})
command("BLines", util.lines_grep)
command("Reload", util.reload_config)
command("ReloadWatch", function() util.reload_config(true) end)
command("Config", util.open_config)
command("Todo",   util.open_todo)
command("Notes",  "call fzf#vim#files('~/Dropbox/Notes', <bang>0)", {bang=true})
command("Dotfiles", "call fzf#vim#files('~/dotfiles/', <bang>0)", {bang=true})

---Delete marks interactivly with fzf.
command("MarksDelete", util.delete_marks)

command("Marks", function()
  local home = vim.fn["fzf#shellescape"](vim.fn.expand('%'))
  local preview = vim.fn["fzf#vim#with_preview"]({
    placeholder = '$([ -r $(echo {4} | sed "s#^~#$HOME#") ] && echo {4} || echo ' .. home .. '):{2}',
    options = '--preview-window +{2}-/2',
  })
  vim.fn["fzf#vim#marks"](preview, 0)
end, {bang=true, bar=true})

command("ArgAdd", util.args_add)

---Delete args interactivly with fzf.
command("ArgsDelete", function()
  local wrapped = vim.fn["fzf#wrap"]({
    source = vim.fn.argv(),
    options = '--multi --bind ctrl-a:select-all+accept',
  })
  wrapped['sink*'] = function(lines)
    nvim.ex.argd(lines)
  end
  vim.fn["fzf#run"](wrapped)
end)
command("ArgDelete", "ArgsDelete")

---Replacing the default ordering.
command("History", function()
  vim.fn["fzf#vim#history"](vim.fn["fzf#vim#with_preview"]({
    options = '--no-sort',
  }))
end, {bang=true, nargs="*"})

command("Checkout", util.checkout_branck, {bang=true, nargs=0})

---Switch git worktrees. It creates a new tab in the new location.
command("Worktree", function()
  local cmd = "git worktree list | cut -d' ' -f1"
  local wrapped = vim.fn["fzf#wrap"]({
    source = cmd,
    options = {'--no-multi'},
  })
  wrapped['sink*'] = function(dir)
    nvim.ex.tabnew()
    nvim.ex.tcd(dir[2])
  end
  vim.fn["fzf#run"](wrapped)
end)
command('WT', 'Worktree')
