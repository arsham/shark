return {
  {
    "tpope/vim-repeat",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "vim-scripts/visualrepeat",
    dependencies = { "inkarkat/vim-ingo-library" },
    event = { "BufReadPost", "BufNewFile" },
    cond = require("util").full_start,
  },
}
