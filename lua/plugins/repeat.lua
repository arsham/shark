return {
  {
    "tpope/vim-repeat",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "vim-scripts/visualrepeat",
    dependencies = { "inkarkat/vim-ingo-library" },
    event = { "BufReadPost", "BufNewFile" },
    enabled = require("util").full_start,
  },
}
