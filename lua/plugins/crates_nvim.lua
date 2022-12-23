return {
  "saecki/crates.nvim",
  -- tag = "v0.3.0",
  config = function()
    require("crates").setup()
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  event = { "BufReadPre Cargo.toml" },
}
