return {
  "saecki/crates.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  event = { "BufReadPre Cargo.toml" },
  opts = {
    popup = {
      autofocus = true,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
      pattern = "Cargo.toml",
      callback = function()
        local crates = require("crates")
        local opts = { noremap = true, silent = true, buffer = true }

        vim.keymap.set("n", "<localleader>ct", crates.toggle, opts)
        vim.keymap.set("n", "<localleader>cr", crates.reload, opts)

        vim.keymap.set("n", "H", crates.show_popup, opts)
        vim.keymap.set("n", "<localleader>cv", crates.show_versions_popup, opts)
        vim.keymap.set("n", "<localleader>cf", crates.show_features_popup, opts)
        vim.keymap.set("n", "<localleader>cd", crates.show_dependencies_popup, opts)

        vim.keymap.set("n", "<localleader>cu", crates.update_crate, opts)
        vim.keymap.set("v", "<localleader>cu", crates.update_crates, opts)
        vim.keymap.set("n", "<localleader>ca", crates.update_all_crates, opts)
        vim.keymap.set("n", "<localleader>cU", crates.upgrade_crate, opts)
        vim.keymap.set("v", "<localleader>cU", crates.upgrade_crates, opts)
        vim.keymap.set("n", "<localleader>cA", crates.upgrade_all_crates, opts)

        vim.keymap.set("n", "<localleader>cH", crates.open_homepage, opts)
        vim.keymap.set("n", "<localleader>cR", crates.open_repository, opts)
        vim.keymap.set("n", "<localleader>cD", crates.open_documentation, opts)
        vim.keymap.set("n", "<localleader>cC", crates.open_crates_io, opts)
      end,
    })
  end,
}
