local nvim = require("nvim")
local quick = require("arshlib.quick")
local util_lsp = require("util.lsp")
table.insert(vim.opt.rtp, "~/.fzf")

local M = {}

---Shows a fzf search for going to definition.{{{
-- If LSP is not attached, it uses the BTags functionality.
---@param lines string[]
local function goto_def(lines)
  local file = lines[1]
  vim.api.nvim_command(("e %s"):format(file))
  if util_lsp.is_lsp_attached() and util_lsp.has_lsp_capability("document_symbol") then
    local ok = pcall(vim.lsp.buf.document_symbol)
    if ok then
      return
    end
  end
  nvim.ex.BTags()
end
--}}}
---Shows a fzf search for going to a line number.
---@param lines string[]
local function goto_line(lines)
  local file = lines[1]
  vim.api.nvim_command(("e %s"):format(file))
  quick.normal("n", ":")
end

---Shows a fzf search for line content.
---@param lines string[]
local function search_file(lines)
  local file = lines[1]
  vim.api.nvim_command(("e +BLines %s"):format(file))
end

---Set selected lines in the quickfix/local list with fzf search {{{
---@param items string[]|table[]
local function insert_into_list(items, is_local)
  local values = {}
  for _, item in pairs(items) do
    if type(item) == "string" then
      item = {
        filename = item,
        lnum = 1,
        col = 1,
        text = "Added with fzf selection",
      }
    end
    local bufnr = vim.fn.bufnr(item.filename)
    if bufnr > 0 then
      local line = vim.api.nvim_buf_get_lines(bufnr, item.lnum - 1, item.lnum, false)[1]
      if line ~= "" then
        item.text = line
      end
    end
    table.insert(values, item)
  end
  require("listish").insert_list(values, is_local)
end

---Set selected lines in the quickfix list with fzf search.
---@param items string[]|table[]
local function set_qf_list(items)
  insert_into_list(items, false)
  nvim.ex.copen()
end

---Set selected lines in the local list with fzf search.
---@param items string[]|table[]
local function set_loclist(items)
  insert_into_list(items, true)
  nvim.ex.lopen()
end
--}}}
M.fzfActions = { --{{{
  ["ctrl-t"] = "tab split",
  ["ctrl-x"] = "split",
  ["ctrl-v"] = "vsplit",
  ["alt-q"] = set_qf_list,
  ["alt-w"] = set_loclist,
  ["alt-@"] = goto_def,
  ["alt-:"] = goto_line,
  ["alt-/"] = search_file,
}
vim.g.fzf_action = M.fzfActions
--}}}
vim.g.fzf_commands_expect = "enter"
vim.g.fzf_layout = {
  window = {
    width = 1,
    height = 0.5,
    yoffset = 1,
    highlight = "Comment",
    border = "none",
  },
}

vim.g.fzf_buffers_jump = 1 -- [Buffers] Jump to the existing window if possible
vim.g.fzf_preview_window = { "right:50%:+{2}-/2,nohidden", "?" }
vim.g.fzf_commits_log_options = table.concat({
  [[ --graph --color=always                                    ]],
  [[ --format="%C(yellow)%h%C(red)%d%C(reset)                  ]],
  [[ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)" ]],
}, " ")

-- stylua: ignore start
quick.augroup({"FZF_FIX", {--{{{
  {"FileType", "fzf", run = function()
      vim.keymap.set("t", "<esc>", "<C-c>",{noremap=true, buffer = true, desc = "escape fzf with escape" })
    end,
  },
}})
-- stylua: ignore end
--}}}

vim.g.fzf_history_dir = vim.env.HOME .. "/.local/share/fzf-history"

return M

-- vim fdm=marker fdl=0
