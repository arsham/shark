local nvim = require("nvim")
local quick = require("arshlib.quick")

-- stylua: ignore start
quick.augroup({"PACKER_RELOAD", {--{{{
  { "BufWritePost", "lua/plugins.lua", function()
    nvim.ex.source("<afile>")
    nvim.ex.PackerCompile()
    nvim.ex.PackerInstall()
  end, docs = "auto compile and install new plugins",
  }},
})--}}}

quick.augroup({"LINE_RETURN", {--{{{
  { "BufRead", "*", function()
    quick.autocmd({ "FileType", run = function()
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
    end, buffer = true, once = true,
    })
  end,
  }},
})--}}}

quick.augroup({ "SPECIAL_SETTINGS", {
  { "VimResized", "*", docs = "resize split on window resize", run = ":wincmd =" },

  { "BufRead", "*", docs = "large file enhancements", run = function()--{{{
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

      quick.autocmd({
        "BufDelete",
        buffer = true,
        run = function()
          vim.opt.hlsearch = hlsearch
          vim.opt.lazyredraw = lazyredraw
          vim.opt.showmatch = showmatch
        end,
      })
    end
  end},--}}}

  { "BufWritePre", "COMMIT_EDITMSG,MERGE_MSG,gitcommit,*.tmp,*.log", function()
    vim.bo.undofile = false
  end },

  { "BufEnter,FocusGained,InsertLeave,WinEnter", "*", run = function()--{{{
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
  end, docs = "set relative number when focused" },--}}}

  { "BufLeave,FocusLost,InsertEnter,WinLeave", "*", run = function()--{{{
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end, docs = "unset relative number when unfocused" },--}}}

  { "TermOpen", "term:\\/\\/*", function()--{{{
    vim.wo.statusline = "%{b:term_title}"
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {noremap=true, buffer = true, desc = "entern normal mode" })
    nvim.ex.startinsert()
    vim.wo.number = false
    vim.wo.relativenumber = false
  end, docs = "start in insert mode and set the status line" },--}}}

  --- See neovim/neovim#15440
  { "TermClose", "*", function()--{{{
    if vim.v.event.status == 0 then
      local info = vim.api.nvim_get_chan_info(vim.opt.channel._value)
      if info and info.argv[1] == vim.env.SHELL then
        pcall(vim.api.nvim_buf_delete, 0, {})
      end
    end
  end, docs = "auto close shell terminals" },--}}}

  { "BufNewFile", "*", run = function()--{{{
    quick.autocmd({
      "BufWritePre",
      buffer = true,
      once = true,
      run = function()
        local path = vim.fn.expand("%:h")
        local p = require("plenary.path"):new(path)
        if not p:exists() then
          p:mkdir({ parents = true })
        end
      end,
      docs = "create missing parent directories automatically",
    })
  end,
  }},--}}}
})

if vim.fn.exists("$TMUX") == 1 then--{{{
  quick.augroup({ "TMUX_RENAME", {
    { "BufEnter", "*", function()
      if vim.bo.buftype == "" then
        local bufname = vim.fn.expand("%:t:S")
        vim.fn.system("tmux rename-window " .. bufname)
      end
    end,
    },
    { "VimLeave", "*", function()
      vim.fn.system("tmux set-window automatic-rename on")
    end,
    },
  }})
end
--}}}
quick.augroup({ "FILETYPE_COMMANDS", {--{{{
  { events = "Filetype", targets = "python,proto", run = function()
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
  end,
  },

  { "Filetype", "make,automake", docs = "makefile tabs", run = function()
    vim.bo.expandtab = false
  end,
  },

  { "BufNewFile,BufRead", ".*aliases", run = function()
    vim.bo.filetype = "sh"
  end,
  },
  { "BufNewFile,BufRead", "Makefile*", run = function()
    vim.bo.filetype = "make"
  end,
  },

  { "TextYankPost", "*", docs = "highlihgt yanking", run = function()
    vim.highlight.on_yank({ higroup = "Substitute", timeout = 150 })
  end,
  },

  { "FileType", "lspinfo", docs = "close lspinfo popup", run = function()
    vim.keymap.set("n", "q", nvim.ex.close, {noremap=true, buffer = true, silent = true, desc = "close lspinfo popup" })
  end,
  },

  { "Filetype", "sql,sqls", docs = "don't wrap me", run = function()
    vim.bo.formatoptions = vim.bo.formatoptions:gsub("t", "")
    vim.bo.formatoptions = vim.bo.formatoptions:gsub("c", "")
  end,
  },

  { "Filetype", "help,man", docs = "exit help with gq", run = function()
    vim.keymap.set("n", "gq", nvim.ex.close, {noremap=true, buffer = true, desc = "close help/man pages" })
  end,
  },
}})--}}}

local async_load_plugin = nil--{{{
async_load_plugin = vim.loop.new_async(vim.schedule_wrap(function()
  quick.augroup({ "TRIM_WHITE_SPACES", {
    { "BufWritePre,FileWritePre,FileAppendPre,FilterWritePre", "*",
      docs = "trim spaces", run = function()
        if not vim.bo.modifiable or vim.bo.binary or vim.bo.filetype == "diff" then
          return
        end
        local save = vim.fn.winsaveview()
        nvim.ex.keeppatterns([[%s/\s\+$//e]])
        nvim.ex.silent_([[%s#\($\n\s*\)\+\%$##]])
        vim.fn.winrestview(save)
      end,
    },
  }})
  async_load_plugin:close()
end))
async_load_plugin:send()--}}}
-- stylua: ignore end

-- fdm=marker fdl=0
