local util = require('util')
-- \ go = {'golangci-lint', 'govet', 'golint', 'remove_trailing_lines', 'trim_whitespace'}
vim.g.ale_linters = {
    go = {'golangci-lint', 'remove_trailing_lines', 'trim_whitespace'}
}
-- vim.g.ale_linter_aliases = {go = {'golangci-lint'}}

vim.g.ale_go_golangci_lint_options = '--fast --build-tags=integration,e2e'
vim.g.ale_go_golangci_lint_package = 1
vim.g.ale_sign_column_always = 1
vim.g.ale_list_window_size = 5

vim.g.ale_echo_msg_format = '%severity%: %linter%: %s'
-- vim.g.ale_lint_on_save = 1
vim.g.ale_lint_on_text_changed = 'always'
-- vim.g.ale_fix_on_save = 1   -- fix files on save
-- vim.g['powerline#extensions#ale#enabled'] = 1
vim.g.ale_set_loclist = 0
-- vim.g.ale_set_quickfix = 1
vim.g.ale_open_list = 0

vim.g.ale_sign_error = '🔥'
vim.g.ale_sign_warning = '💩'
vim.g.ale_sign_info = '💬'
vim.g.ale_sign_style_error = '🔥'
vim.g.ale_sign_style_warning = '💩'
vim.g.ale_sign_priority = 2

vim.keymap.nnoremap{']l', silent=true, function()
    util.cmd_and_centre("ALENextWrap")
end}
vim.keymap.nnoremap{'[l', silent=true, function()
    util.cmd_and_centre("ALEPreviousWrap")
end}
vim.keymap.nnoremap{'<leader>ll', '<cmd>ALELint<CR>', silent=true}
