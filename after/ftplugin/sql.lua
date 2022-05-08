local nvim = require("nvim")
vim.opt_local.expandtab = true
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.formatoptions:remove({ "t", "c" })

-- stylua: ignore start
nvim.ex.iabbrev{"<buffer>", "as",         "AS"}
nvim.ex.iabbrev{"<buffer>", "by",         "BY"}
nvim.ex.iabbrev{"<buffer>", "cascade",    "CASCADE"}
nvim.ex.iabbrev{"<buffer>", "create",     "CREATE"}
nvim.ex.iabbrev{"<buffer>", "delete",     "DELETE"}
nvim.ex.iabbrev{"<buffer>", "drop",       "DROP"}
nvim.ex.iabbrev{"<buffer>", "else",       "ELSE"}
nvim.ex.iabbrev{"<buffer>", "end",        "END"}
nvim.ex.iabbrev{"<buffer>", "foreign",    "FOREIGN"}
nvim.ex.iabbrev{"<buffer>", "from",       "FROM"}
nvim.ex.iabbrev{"<buffer>", "group",      "GROUP"}
nvim.ex.iabbrev{"<buffer>", "having",     "HAVING"}
nvim.ex.iabbrev{"<buffer>", "index",      "INDEX"}
nvim.ex.iabbrev{"<buffer>", "insert",     "INSERT"}
nvim.ex.iabbrev{"<buffer>", "into",       "INTO"}
nvim.ex.iabbrev{"<buffer>", "join",       "JOIN"}
nvim.ex.iabbrev{"<buffer>", "key",        "KEY"}
nvim.ex.iabbrev{"<buffer>", "limit",      "LIMIT"}
nvim.ex.iabbrev{"<buffer>", "offset",     "OFFSET"}
nvim.ex.iabbrev{"<buffer>", "on",         "ON"}
nvim.ex.iabbrev{"<buffer>", "order",      "ORDER"}
nvim.ex.iabbrev{"<buffer>", "primary",    "PRIMARY"}
nvim.ex.iabbrev{"<buffer>", "references", "REFERENCES"}
nvim.ex.iabbrev{"<buffer>", "select",     "SELECT"}
nvim.ex.iabbrev{"<buffer>", "set",        "SET"}
nvim.ex.iabbrev{"<buffer>", "table",      "TABLE"}
nvim.ex.iabbrev{"<buffer>", "then",       "THEN"}
nvim.ex.iabbrev{"<buffer>", "union",      "UNION"}
nvim.ex.iabbrev{"<buffer>", "unique",     "UNIQUE"}
nvim.ex.iabbrev{"<buffer>", "update",     "UPDATE"}
nvim.ex.iabbrev{"<buffer>", "values",     "VALUES"}
nvim.ex.iabbrev{"<buffer>", "when",       "WHEN"}
nvim.ex.iabbrev{"<buffer>", "where",      "WHERE"}
-- stylua: ignore end
