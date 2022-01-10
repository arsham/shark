local command = require("arshlib.quick").command

table.insert(vim.opt.rtp, "~/.fzf")

require("fzfmania").config({})

command("Notes", "call fzf#vim#files('~/Dropbox/Notes', <bang>0)", { bang = true })
command("Dotfiles", "call fzf#vim#files('~/dotfiles/', <bang>0)", { bang = true })

vim.keymap.set("n", "<leader>fl", function()
  require("arshlib.util").user_input({
    prompt = "Term: ",
    on_submit = function(term)
      vim.schedule(function()
        local preview = vim.fn["fzf#vim#with_preview"]()
        vim.fn["fzf#vim#locate"](term, preview)
      end)
    end,
  })
end, { noremap = true, silent = true, desc = "run locate" })

-- vim: foldmethod=marker foldlevel=0
