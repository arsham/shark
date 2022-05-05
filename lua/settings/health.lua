local M = {}
local health = require("health")
local home = vim.env.HOME

local file_checks = {
  ["Words dictionary"] = { "/usr/share/dict/words-insane", { "yay -S words-insane" } },
  thesaurus = {
    home .. "/.local/share/thesaurus/moby.txt",
    { "Visit https://github.com/words/moby" },
  },
  viewdir = { home .. "/.cache/nvim/views", { "Create the required folder" } },
  spellfile = { home .. "/.config/nvim/spell", { "Create the required folder" } },
  undodir = { home .. "/.cache/nvim/undodir", { "Create the required folder" } },
  backdir = { home .. "/.cache/nvim/backdir", { "Create the required folder" } },
}

local executables = {
  buf = { "buf", "Run :IntallDependencies" },
  git = { "git", "yay -S git" },
  Ripgrep = { "rg", "yay -S rg" },
  FZF = { "fzf", "yay -S fzf" },
  tmux = { "tmux", "yay -S tmux" },
  tmuxinator = { "tmuxinator", "yay -S tmuxinator" },
  fd = { "fd", "yay -S fd" },
  bat = { "bat", "yay -S bat" },
  ctags = { "ctags", "yay -S ctags" },
  diagon = { "diagon", "snap install diagon" },
  golangci = { "golangci-lint", "Run :IntallDependencies" },
  gojq = { "gojq", "Run :IntallDependencies" },
  fixjson = { "fixjson", "Run :IntallDependencies" },
  prettier = { "prettier", "Run :IntallDependencies" },
  selene = { "selene", "Run :IntallDependencies" },
  stylua = { "stylua", "Run :IntallDependencies" },
  ["Python-pip"] = { "pip3", "yay -S python-pip" },
  TheSilverSearcher = { "ag", "yay -S the_silver_searcher" },
  uncrustify = { "uncrustify", "yay -S uncrustify" },
}

local libs = {
  arshlib = "arsham/arshlib.nvim",
  listish = "arsham/listish.nvim",
  matchmaker = "arsham/matchmaker.nvim",
  yanker = "arsham/yanker.nvim",
  ["arshamiser.feliniser"] = "arsham/arshamiser.nvim",
  ["indent-tools"] = "arsham/indent-tools.nvim",
  plenary = "nvim-lua/plenary.nvim",
  nvim = "norcalli/nvim.lua",
  ["bk-tree"] = "bk-tree",
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
