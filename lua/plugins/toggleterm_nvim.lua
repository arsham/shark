return {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "TT" },
  keys = {
    "<leader>tt",
    { "<leader>tT", '<Cmd>execute v:count . "ToggleTerm direction=vertical"<CR>', silent = true },

    {
      "<leader>tf",
      function()
        local term = require("toggleterm.terminal").Terminal
        local path = require("plenary.path")
        local tmp = vim.fn.tempname()
        local floater = term:new({
          cmd = ('env TERM=alacritty-direct vifm  --choose-files "%s"'):format(tmp),
          direction = "float",
          close_on_exit = true,
          on_close = function()
            local data = path:new(tmp):read()
            if data ~= "" then
              vim.schedule(function()
                vim.cmd("e " .. data)
              end)
            end
          end,
        })
        floater:toggle()
      end,
      desc = "Open vifm in a floating window and open the chosen file in floating",
    },
  },

  config = function()
    local quick = require("arshlib.quick")
    quick.command("TT", "ToggleTerm")
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,

      open_mapping = "<leader>tt",
      shade_terminals = false,
      on_open = function(term)
        vim.cmd("startinsert!")
        local function opt(desc)
          return { silent = true, desc = desc, buffer = term.bufnr }
        end
        vim.keymap.set("n", "q", "<cmd>close<cr>", opt("Close terminal"))
        vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<CR>", opt("Switch to the left"))
        vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<CR>", opt("Switch to the below"))
        vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<CR>", opt("Switch to the above"))
        vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<CR>", opt("Switch to the right"))
      end,

      insert_mappings = false,
      direction = "horizontal",
      float_opts = {
        border = "curved",
        winblend = 3,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
      winbar = {
        enabled = false,
      },
    })

    -- Making the terminal to always open horizontally with this mapping.
    local cmd = '<CMD>execute v:count . "ToggleTerm direction=horizontal"<CR>'
    vim.keymap.set({ "n", "t" }, "<leader>tt", cmd, { silent = true, desc = "Toggle Terminal" })
  end,
}
