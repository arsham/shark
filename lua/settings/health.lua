local M = {}
local health = vim.health or require("health")
local home = vim.env.HOME

local file_checks = {
  backdir = { home .. "/.cache/nvim/backdir", { "Create the required folder" } },
  spellfile = { home .. "/.config/nvim/spell", { "Create the required folder" } },
  undodir = { home .. "/.cache/nvim/undodir", { "Create the required folder" } },
  thesaurus = {
    home .. "/.local/share/thesaurus/moby.txt",
    { "Visit https://github.com/words/moby" },
  },
  viewdir = { home .. "/.cache/nvim/views", { "Create the required folder" } },
  ["Words dictionary"] = { "/usr/share/dict/words-insane", { "yay -S words-insane" } },
}

local executables = {
  bat = { "bat", "yay -S bat" },
  buf = { "buf", "Run :IntallDependencies" },
  ctags = { "ctags", "yay -S ctags" },
  diagon = { "diagon", "snap install diagon" },
  fd = { "fd", "yay -S fd" },
  fixjson = { "fixjson", "Run :IntallDependencies" },
  fzf = { "fzf", "yay -S fzf" },
  git = { "git", "yay -S git" },
  gojq = { "gojq", "Run :IntallDependencies" },
  golangci = { "golangci-lint", "Run :IntallDependencies" },
  prettier = { "prettier", "Run :IntallDependencies" },
  ["Python-pip"] = { "pip3", "yay -S python-pip" },
  ripgrep = { "rg", "yay -S rg" },
  selene = { "selene", "Run :IntallDependencies" },
  stylua = { "stylua", "Run :IntallDependencies" },
  TheSilverSearcher = { "ag", "yay -S the_silver_searcher" },
  tmux = { "tmux", "yay -S tmux" },
  tmuxp = { "tmuxp", "yay -S tmuxp" },
  uncrustify = { "uncrustify", "yay -S uncrustify" },
}

local libs = {
  ["arshamiser.feliniser"] = "arsham/arshamiser.nvim",
  arshlib = "arsham/arshlib.nvim",
  ["bk-tree"] = "bk-tree",
  ["indent-tools"] = "arsham/indent-tools.nvim",
  listish = "arsham/listish.nvim",
  matchmaker = "arsham/matchmaker.nvim",
  plenary = "nvim-lua/plenary.nvim",
  yanker = "arsham/yanker.nvim",
}

M.check = function()
  health.report_start("Shark Health Check")
  for name, aspect in pairs(file_checks) do
    local p = require("plenary.path"):new(aspect[1])
    if not p:exists() then
      health.report_error(name .. " not found at: " .. aspect[1], aspect[2])
    else
      health.report_ok(name .. " was found at: " .. aspect[1])
    end
  end

  for name, package in pairs(libs) do
    if not pcall(require, name) then
      health.report_error(package .. " was not found", {
        'Please install "' .. package .. '"',
      })
    else
      health.report_ok(package .. " is installed")
    end
  end

  for name, aspect in pairs(executables) do
    local ok = vim.fn.executable(aspect[1])
    if ok == 1 then
      health.report_ok(name .. " is installed")
    else
      health.report_error(name .. " is not installed.", aspect[2])
    end
  end
end

return M
