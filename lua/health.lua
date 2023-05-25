local M = {}
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
  ["Words dictionary"] = { "/usr/share/dict/words-insane", { "paru -S words-insane" } },
}

local executables = {
  ripgrep = { "rg", "paru -S rg" },
  git = { "git", "paru -S git" },
}

M.check = function()
  vim.health.start("Shark Health Check")
  for name, aspect in pairs(file_checks) do
    local p = require("plenary.path"):new(aspect[1])
    if not p:exists() then
      vim.health.error(name .. " not found at: " .. aspect[1], aspect[2])
    else
      vim.health.ok(name .. " was found at: " .. aspect[1])
    end
  end

  for name, aspect in pairs(executables) do
    local ok = vim.fn.executable(aspect[1])
    if ok == 1 then
      vim.health.ok(name .. " is installed")
    else
      vim.health.error(name .. " is not installed.", aspect[2])
    end
  end
end

return M
