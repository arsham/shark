return {
  "saecki/crates.nvim",
  -- tag = "v0.3.0",
  config = function()
    require("settings.crates-nvim")
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  event = { "BufReadPre Cargo.toml" },
}
