vim.opt.background = "dark"
vim.opt.guifont = "DejaVuSansMono Nerd Font:h10"

-- Defer setting the colorscheme until the UI loads.
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    require("nvim").ex.colorscheme("arshamiser_light")
    require("arshamiser.feliniser")
    -- selene: allow(global_usage)
    _G.custom_foldtext = require("arshamiser.folding").foldtext
    vim.opt.foldtext = "v:lua.custom_foldtext()"
  end,
})
