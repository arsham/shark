local actions = require("fzf-lua.actions")
local util = require("fzfmania.util")
local quick = require("arshlib.quick")
local fzf = require("fzf-lua")

vim.keymap.set("n", "<leader>t", fzf.builtin)

local function prepare_list_items(items)
  local _items = {}
  for _, item in ipairs(items) do
    if not string.find(item, ":") then
      table.insert(_items, item)
    elseif string.find(item, "") then
      local name, line, content = item:match(" ([^:]+):([^:]+):(.+)")
      table.insert(_items, {
        filename = vim.fn.fnameescape(name),
        lnum = tonumber(line),
        col = 1,
        text = content,
      })
    else
      local name, line, col, content
      local _, count = string.gsub(item, ":", 0)
      -- TODO: use matching to .+:%d:%d:.+
      if count == 3 then
        name, line, col, content = item:match("^([^:]+):([^:]+):([^:]+):(.*)")
      else
        name, line, content = item:match("^([^:]+):([^:]+):(.*)")
      end
      if content == nil then
        content, col = col, content
      end
      table.insert(_items, {
        filename = vim.fn.fnameescape(name),
        lnum = tonumber(line),
        col = col or 1,
        text = content,
      })
    end
  end
  return _items
end

local function insert_qflist()
  return function(items)
    util.insert_into_list(prepare_list_items(items), false)
    vim.api.nvim_command("copen")
  end
end

local function insert_locallist()
  return function(items)
    util.insert_into_list(prepare_list_items(items), true)
    vim.api.nvim_command("lopen")
  end
end

require("fzf-lua").setup({
  winopts = {
    height = 0.5,
    width = 1,
    row = 1,
    border = false,
    hl = { --{{{
      normal = "Normal",
      border = "FloatBorder",
      cursor = "Cursor",
      cursorline = "CursorLine",
      search = "Search",
      scrollbar_f = "PmenuThumb",
      scrollbar_e = "PmenuSbar",
    }, --}}}

    preview = { --{{{
      -- default = "bat",
      -- default = "bat_native",
      wrap = "nowrap",
      hidden = "nohidden",
      vertical = "down:45%",
      horizontal = "right:70%",
      layout = "flex",
      flip_columns = 120,
      title = true,
      scrollbar = "float",
      scrolloff = "-2",
      scrollchars = { "█", "" },
      delay = 30,

      winopts = { -- Builtin previewer window options {{{
        number = true,
        relativenumber = false,
        cursorline = true,
        cursorlineopt = "both",
        cursorcolumn = false,
        signcolumn = "no",
        list = false,
        foldenable = false,
        foldmethod = "manual",
      }, --}}}
    }, --}}}

    on_create = function() --{{{
      -- called once upon creation of the fzf main window
      -- can be used to add custom fzf-lua mappings, e.g:
      --   vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", "<Down>",
      --     { silent = true, noremap = true })
    end, --}}}
  },

  keymap = {
    builtin = { --{{{
      -- `:tmap` mappings
      ["<F1>"] = "toggle-help",
      ["<F2>"] = "toggle-fullscreen",
      ["<F3>"] = "toggle-preview-wrap",
      ["<C-_>"] = "toggle-preview",
      ["<F5>"] = "toggle-preview-ccw",
      ["<F6>"] = "toggle-preview-cw",
      ["<M-j>"] = "preview-page-down",
      ["<M-k>"] = "preview-page-up",
      ["<M-left>"] = "preview-page-reset",
    }, --}}}

    fzf = { --{{{
      -- fzf '--bind=' options
      ["ctrl-z"] = "abort",
      ["ctrl-d"] = "half-page-down",
      ["ctrl-u"] = "half-page-up",
      ["ctrl-a"] = "beginning-of-line",
      ["ctrl-e"] = "end-of-line",
      ["alt-a"] = "toggle-all",
      ["ctrl-/"] = "ignore",
    }, --}}}
  },

  actions = {
    files = { --{{{
      ["default"] = actions.file_edit_or_qf,
      ["ctrl-s"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
      ["alt-q"] = insert_qflist(),
      ["alt-w"] = insert_locallist(),
      ["alt-@"] = util.goto_def,
      ["alt-:"] = function(lines)
        local file = lines[1]
        vim.api.nvim_command(("e %s"):format(file))
        quick.normal("n", ":")
      end,
      ["alt-/"] = function(lines)
        local file = lines[1]
        vim.api.nvim_command(("e +BLines %s"):format(file))
      end,
    }, --}}}
    buffers = { --{{{
      ["default"] = actions.buf_edit,
      ["ctrl-s"] = actions.buf_split,
      ["ctrl-v"] = actions.buf_vsplit,
      ["ctrl-t"] = actions.buf_tabedit,
      ["alt-q"] = insert_qflist(),
      ["alt-w"] = insert_locallist(),
      ["alt-@"] = util.goto_def,
      ["alt-:"] = function(lines)
        local file = lines[1]
        vim.api.nvim_command(("e %s"):format(file))
        quick.normal("n", ":")
      end,
    }, --}}}
  },

  fzf_opts = { --{{{
    -- options are sent as `<left>=<right>`
    -- set to `false` to remove a flag
    -- set to '' for a non-value flag
    -- for raw args use `fzf_args` instead
    ["--ansi"] = "",
    ["--prompt"] = "> ",
    ["--info"] = "inline",
    ["--height"] = "100%",
    ["--layout"] = "default",
    ["--no-multi"] = false,
  }, --}}}

  previewers = {
    cat = { --{{{
      cmd = "cat",
      args = "--number",
    }, --}}}
    bat = { --{{{
      cmd = "bat",
      args = "--style=numbers,changes --color always",
      theme = "Coldark-Dark", -- bat preview theme (bat --list-themes)
      config = nil, -- nil uses $BAT_CONFIG_PATH
    }, --}}}
    head = { --{{{
      cmd = "head",
      args = nil,
    }, --}}}
    git_diff = { --{{{
      cmd_deleted = "git diff --color HEAD --",
      cmd_modified = "git diff --color HEAD",
      cmd_untracked = "git diff --color --no-index /dev/null",
    }, --}}}
    man = { --{{{
      cmd = "man %s | col -bx",
    }, --}}}
    builtin = { --{{{
      syntax = true,
      syntax_limit_l = 1024 * 1024, -- syntax limit (lines), 0=nolimit
      syntax_limit_b = 1024 * 1024 * 5, -- syntax limit (bytes), 0=nolimit
      limit_b = 1024 * 1024 * 10, -- preview limit (bytes), 0=nolimit
      extensions = {
        ["jpg"] = { "ueberzug" },
        ["png"] = { "ueberzug" },
      },
      ueberzug_scaler = "contain",
    }, --}}}
  },

  files = { --{{{
    prompt = "Files❯ ",
    multiprocess = true,
    git_icons = true,
    file_icons = true,
    color_icons = true,
    find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
    rg_opts = "--color=never --files --hidden --follow --smart-case -g '!.git'",
    fd_opts = "--color=never --type f --hidden --follow --exclude .git",
    actions = {
      ["default"] = actions.file_edit,
      -- custom actions are available too
      ["ctrl-y"] = function(selected)
        print(selected[1])
      end,
    },
  }, --}}}

  git = {
    files = { --{{{
      prompt = "GitFiles❯ ",
      cmd = "git ls-files --exclude-standard",
      multiprocess = true,
      git_icons = true,
      file_icons = true,
      color_icons = true,
    }, --}}}
    status = { --{{{
      prompt = "GitStatus❯ ",
      cmd = "git status -s",
      previewer = "git_diff",
      file_icons = true,
      git_icons = true,
      color_icons = true,
      actions = {
        ["right"] = { actions.git_unstage, actions.resume },
        ["left"] = { actions.git_stage, actions.resume },
      },
    }, --}}}
    commits = { --{{{
      prompt = "Commits❯ ",
      cmd = "git log --pretty=oneline --abbrev-commit --color",
      preview = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
      actions = {
        -- ["default"] = actions.git_checkout,
      },
    }, --}}}
    bcommits = { --{{{
      prompt = "BCommits❯ ",
      cmd = "git log --pretty=oneline --abbrev-commit --color",
      preview = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
      actions = {
        ["default"] = actions.git_buf_edit,
        ["ctrl-s"] = actions.git_buf_split,
        ["ctrl-v"] = actions.git_buf_vsplit,
        ["ctrl-t"] = actions.git_buf_tabedit,
      },
    }, --}}}
    branches = { --{{{
      prompt = "Branches❯ ",
      cmd = "git branch --all --color",
      preview = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
      actions = {
        ["default"] = actions.git_switch,
      },
    }, --}}}
    icons = { --{{{
      -- ["M"] = { icon = "M", color = "yellow" },
      ["M"] = { icon = "★", color = "yellow" },
      -- ["D"] = { icon = "D", color = "red" },
      ["D"] = { icon = "✗", color = "red" },
      -- ["A"] = { icon = "A", color = "green" },
      ["A"] = { icon = "+", color = "green" },
      ["R"] = { icon = "R", color = "yellow" },
      ["C"] = { icon = "C", color = "yellow" },
      ["?"] = { icon = "?", color = "magenta" },
    }, --}}}
  },

  grep = { --{{{
    prompt = "Rg❯ ",
    input_prompt = "Grep For❯ ",
    multiprocess = true,
    git_icons = true,
    file_icons = true,
    color_icons = true,
    grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp",
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",

    -- set to 'true' to always parse globs in both 'grep' and 'live_grep'
    -- search strings will be split using the 'glob_separator' and translated
    -- to '--iglob=' arguments, requires 'rg'
    -- can still be used when 'false' by calling 'live_grep_glob' directly
    rg_glob = false, -- default to glob parsing?
    glob_flag = "--iglob", -- for case sensitive globs use '--glob'
    glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
    -- advanced usage: for custom argument parsing define
    -- 'rg_glob_fn' to return a pair:
    --   first returned argument is the new search query
    --   second returned argument are addtional rg flags
    -- rg_glob_fn = function(opts, query)
    --   ...
    --   return new_query, flags
    -- end,
    actions = {
      -- actions inherit from 'actions.files' and merge
      -- this action toggles between 'grep' and 'live_grep'
      ["ctrl-g"] = { actions.grep_lgrep },
    },
    no_header = false, -- hide grep|cwd header?
    no_header_i = false, -- hide interactive header?
  }, --}}}

  args = { --{{{
    prompt = "Args❯ ",
    files_only = true,
    actions = { ["ctrl-x"] = { actions.arg_del, actions.resume } },
  }, --}}}

  oldfiles = { --{{{
    prompt = "History❯ ",
    cwd_only = false,
    stat_file = true, -- verify files exist on disk
    include_current_session = false, -- include bufs from current session
    winopts = {
      preview = {
        delay = 20,
      },
    },
  }, --}}}

  buffers = { --{{{
    prompt = "Buffers❯ ",
    file_icons = true,
    color_icons = true,
    sort_lastused = true,
    actions = {
      ["ctrl-x"] = { actions.buf_del, actions.resume },
    },
    winopts = {
      preview = {
        delay = 0,
      },
    },
  }, --}}}

  tabs = { --{{{
    prompt = "Tabs❯ ",
    tab_title = "Tab",
    tab_marker = "<<",
    file_icons = true,
    color_icons = true,
    actions = {
      ["default"] = actions.buf_switch,
      ["ctrl-x"] = { actions.buf_del, actions.resume },
    },
    fzf_opts = {
      -- hide tabnr
      ["--delimiter"] = "'[\\):]'",
      ["--with-nth"] = "2..",
    },
  }, --}}}

  lines = { --{{{
    previewer = "builtin",
    prompt = "Lines❯ ",
    show_unlisted = false, -- exclude 'help' buffers
    no_term_buffers = true,
    fzf_opts = {
      -- do not include bufnr in fuzzy matching
      -- tiebreak by line no.
      ["--delimiter"] = "'[\\]:]'",
      ["--nth"] = "2..",
      ["--tiebreak"] = "index",
    },
    -- actions inherit from 'actions.buffers'
    winopts = {
      preview = {
        delay = 0,
      },
    },
  }, --}}}

  blines = { --{{{
    previewer = "builtin",
    prompt = "BLines❯ ",
    show_unlisted = true,
    no_term_buffers = false,
    fzf_opts = {
      -- hide filename, tiebreak by line no.
      ["--delimiter"] = "'[\\]:]'",
      ["--with-nth"] = "2..",
      ["--tiebreak"] = "index",
    },
    winopts = {
      preview = {
        delay = 0,
      },
    },
  }, --}}}

  tags = { --{{{
    prompt = "Tags❯ ",
    ctags_file = "tags",
    multiprocess = true,
    file_icons = true,
    git_icons = true,
    color_icons = true,
    -- 'tags_live_grep' options, `rg` prioritizes over `grep`
    rg_opts = "--no-heading --color=always --smart-case",
    grep_opts = "--color=auto --perl-regexp",
    actions = {
      -- this action toggles between 'grep' and 'live_grep'
      ["ctrl-g"] = { actions.grep_lgrep },
    },
    no_header = false,
    no_header_i = false,
  }, --}}}

  btags = { --{{{
    prompt = "BTags❯ ",
    ctags_file = "tags",
    multiprocess = true,
    file_icons = true,
    git_icons = true,
    color_icons = true,
    rg_opts = "--no-heading --color=always",
    grep_opts = "--color=auto --perl-regexp",
    fzf_opts = {
      ["--delimiter"] = "'[\\]:]'",
      ["--with-nth"] = "2..",
      ["--tiebreak"] = "index",
    },
  }, --}}}

  colorschemes = { --{{{
    prompt = "Colorschemes❯ ",
    live_preview = true, -- apply the colorscheme on preview?
    actions = { ["default"] = actions.colorscheme },
    winopts = { height = 0.55, width = 0.30 },
    post_reset_cb = function()
      -- reset statusline highlights after
      -- a live_preview of the colorscheme
      require("feline").reset_highlights()
    end,
  }, --}}}

  quickfix = { --{{{
    file_icons = true,
    git_icons = true,
  }, --}}}

  lsp = { --{{{
    prompt_postfix = "❯ ",
    cwd_only = false, -- LSP/diagnostics for cwd only?
    async_or_timeout = 5000, -- timeout(ms) or 'true' for async calls
    file_icons = true,
    git_icons = false,
    lsp_icons = true,
    ui_select = true,
    severity = "hint",
    icons = {
      ["Error"] = { icon = "", color = "red" },
      ["Warning"] = { icon = "", color = "yellow" },
      ["Information"] = { icon = "", color = "blue" },
      ["Hint"] = { icon = "", color = "magenta" },
    },
  }, --}}}

  file_icon_padding = "",
  file_icon_colors = {
    ["lua"] = "blue",
  },
})

-- vim: fdm=marker fdl=0
