local nvim = require("nvim")
local fzf = require("settings.fzf.util")

-- stylua: ignore start
---Ctrl+/ for searching in current buffer.
vim.keymap.set("n", "<leader>:", ":Commands<CR>", { noremap = true, desc = "show commands" })
vim.keymap.set("n", "<C-_>", fzf.lines_grep,
  { noremap = true, silent = true, desc = "grep lines of current buffer" }
)
vim.keymap.set("n", "<M-/>", ":Lines<CR>",
  { noremap = true, silent = true, desc = "search in lines of all open buffers" }
)
vim.keymap.set("n", "<C-p>", ":Files<CR>", { noremap = true, silent = true, desc = "show files" })
vim.keymap.set("n", "<M-p>", ":Files ~/<CR>",
  { noremap = true, silent = true, desc = "show all files in home directory" }
)
vim.keymap.set("n", "<C-b>", ":Buffers<CR>",
  { noremap = true, silent = true, desc = "show buffers" }
)
vim.keymap.set("n", "<M-b>", fzf.delete_buffer,
  { noremap = true, silent = true, desc = "delete buffers" }
)
vim.keymap.set("n", "<leader>gf", ":GFiles<CR>",
  { noremap = true, silent = true, desc = "show files in git" }
)
vim.keymap.set("n", "<leader>fh", ":History<CR>",
  { noremap = true, silent = true, desc = "show history" }
)

vim.keymap.set("n", "<leader>fl", function()
  require("util").user_input({
    prompt = "Term: ",
    on_submit = function(term)
      vim.schedule(function()
        local preview = vim.fn["fzf#vim#with_preview"]()
        vim.fn["fzf#vim#locate"](term, preview)
      end)
    end,
  })
end, { noremap = true, silent = true, desc = "run locate" })

---Replace the default dictionary completion with fzf-based fuzzy completion.
vim.keymap.set("i", "<c-x><c-k>", [[fzf#vim#complete('cat /usr/share/dict/words-insane')]],
  { noremap = true, expr = true, desc = "dict completion" }
)
vim.keymap.set("i", "<c-x><c-f>", "<Plug>(fzf-complete-path)",
  { noremap = true, desc = "path completion" }
)
vim.keymap.set("i", "<c-x><c-l>", "<Plug>(fzf-complete-line)",
  { noremap = true, desc = "line completion" }
)

vim.keymap.set("n", "<leader>ff", function()
  fzf.ripgrep_search("")
end, { noremap = true, desc = "find in files" })
vim.keymap.set("n", "<leader>fa", function()
  fzf.ripgrep_search("", true)
end, { noremap = true, desc = "find in files (ignore .gitignore)" })
vim.keymap.set("n", "<leader>fi", function()
  fzf.ripgrep_search_incremental("", true)
end, { noremap = true, desc = "incremental search with rg" })

local desc = "search over current word"
vim.keymap.set("n", "<leader>rg", function()
  fzf.ripgrep_search(vim.fn.expand("<cword>"))
end, { noremap = true, desc = desc })
vim.keymap.set("n", "<leader>ra", function()
  fzf.ripgrep_search(vim.fn.expand("<cword>"), true)
end, { noremap = true, desc = desc .. " (ignore .gitignore)" })
vim.keymap.set("n", "<leader>ri", function()
  fzf.ripgrep_search(vim.fn.expand("<cword>"), true)
end, { noremap = true, desc = desc .. " (ignore .gitignore)" })

vim.keymap.set("n", "<leader>mm", ":Marks<CR>", { noremap = true, desc = "show marks" })

vim.keymap.set("n", "z=", function()
  local term = vim.fn.expand("<cword>")
  vim.fn["fzf#run"]({
    source = vim.fn.spellsuggest(term),
    sink = function(new_term)
      require("util").normal("n", '"_ciw' .. new_term .. "")
    end,
    down = 10,
  })
end, { noremap = true, desc = "show spell suggestions" })

vim.keymap.set("n", "<leader>@", nvim.ex.BTags, { noremap = true, silent = true, desc = "show tags" })
-- stylua: ignore end
