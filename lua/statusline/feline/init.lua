local lsp = require('util.lsp')
local util = require('statusline.feline.util')
local vi_mode_utils = require('feline.providers.vi_mode')

local components = {
    active       = {{}, {}, {}},
    inactive     = {{}, {}, {}},
}

local left_ribbon_hl = {
    fg = 'grey_fg',
    bg = 'statusline_bg',
}

local mid_ribbon_hl = {
    fg = 'grey_fg',
    bg = 'statusline_bg',
}

local right_ribbon_hl = {
    fg = 'grey_fg',
    bg = 'statusline_bg',
}

table.insert(components.active[1], {
    provider = '  ',
    hl = function()
        return {
            fg = 'statusline_bg',
            bg = vi_mode_utils.get_mode_color(),
            style = 'bold',
        }
    end,
    right_sep = 'right_rounded',
})

table.insert(components.active[1], {
    provider = 'vim_mode',
    hl = function()
        return {
            fg = vi_mode_utils.get_mode_color(),
            bg = 'statusline_bg',
            style = 'bold',
        }
    end,
    right_sep = {
        str = ' ',
        hl = {
            fg = 'light_bg2',
            bg = 'statusline_bg',
            style = 'bold'
        },
    },
    icon = "  ",
})

table.insert(components.active[1], {
    provider = 'git_root',
    enabled = function() return require('feline.providers.git').git_info_exists() end,
    truncate_hide = true,
    hl = left_ribbon_hl,
    left_sep = {
        str = 'github_icon',
        hl = left_ribbon_hl,
    },
})

table.insert(components.active[1], {
    provider = 'git_branch',
    enabled = function() return require('feline.providers.git').git_info_exists() end,
    truncate_hide = true,
    hl = left_ribbon_hl,
    left_sep = {
        str = ' ',
        hl = left_ribbon_hl,
    },
    right_sep = {
        str = ' ',
        hl = left_ribbon_hl,
    },
})

table.insert(components.active[1], {
    provider = 'git_diff_added',
    enabled = function() return require('feline.providers.git').git_info_exists() end,
    hl = left_ribbon_hl,
    -- icon = "  ",
})

table.insert(components.active[1], {
    provider = 'git_diff_changed',
    enabled = function() return require('feline.providers.git').git_info_exists() end,
    hl = left_ribbon_hl,
    -- icon = "  ",
})

table.insert(components.active[1], {
    provider = 'git_diff_removed',
    enabled = function() return require('feline.providers.git').git_info_exists() end,
    hl = left_ribbon_hl,
    -- icon = "  ",
})

-- left angle
table.insert(components.active[1], {
    provider = ' ',
    hl = left_ribbon_hl,
    right_sep = {
        str = 'right_filled',
        hl = {
            fg = 'statusline_bg',
            bg = 'mid_bg',
        },
    },
})

table.insert(components.active[2], {
    provider = ' ',
    enabled = function() return vim.fn.expand('%:t') ~= '' end,
    hl = mid_ribbon_hl,
    left_sep = {
        str = "left_filled",
        hl = {
            fg = 'statusline_bg',
            bg = 'mid_bg',
            style = 'bold'
        },
    },
})

table.insert(components.active[2], {
    provider = {
        name = 'file_info',
        opts = {
            type = 'full-path',
            file_modified_icon = '',
            file_readonly_icon = '🔒',
        }
    },
    short_provider = {
        name = 'file_info',
        opts = {
            type = 'relative',
            file_modified_icon = '',
            file_readonly_icon = '🔒',
        }
    },
    enabled = function() return vim.fn.expand('%:t') ~= '' end,
    hl = {
        fg = 'white',
        bg = 'statusline_bg',
    },
})

table.insert(components.active[2], {
    provider = 'file_size',
    enabled = function() return vim.fn.expand('%:t') ~= '' end,
    truncate_hide = true,
    hl = {
        fg = 'grey_fg',
        bg = 'statusline_bg',
    },
})

table.insert(components.active[2], {
    provider = ' ',
    enabled = function() return vim.fn.expand('%:t') ~= '' end,
    hl = mid_ribbon_hl,
    right_sep = {
        str = "right_filled",
        hl = {
            fg = 'statusline_bg',
            bg = 'mid_bg',
        },
    },
})

table.insert(components.active[3], {
    provider = ' ',
    hl = right_ribbon_hl,
    left_sep = {
        str = 'left_filled',
        hl = {
            fg = 'statusline_bg',
            bg = 'mid_bg',
        },
    }
})

table.insert(components.active[3], {
    provider = 'lsp_client_names',
    enabled = function() return lsp.is_lsp_attached() end,
    hl = right_ribbon_hl,
    truncate_hide = true,
})

table.insert(components.active[3], {
    provider = 'ale_diagnostics',
    hl = {
        fg = 'yellow_pale',
        bg = 'statusline_bg',
        style = 'bold'
    },
    left_sep = {
        str = ' ',
        hl = {
            bg = 'statusline_bg',
            fg = 'mid_bg',
            style = 'bold'
        },
    }
})

table.insert(components.active[3], {
    provider = 'diag_errors',
    enabled = function() return lsp.diagnostics_exist('Error') end,
    hl = {
        fg = 'red',
        bg = 'statusline_bg',
    }
})

table.insert(components.active[3], {
    provider = 'diag_warnings',
    enabled = function() return lsp.diagnostics_exist('Warning') end,
    hl = {
        fg = 'warn',
        bg = 'statusline_bg',
    }
})

table.insert(components.active[3], {
    provider = 'diag_hints',
    enabled = function() return lsp.diagnostics_exist('Hint') end,
    hl = {
        fg = 'green',
        bg = 'statusline_bg',
    },
})

table.insert(components.active[3], {
    provider = 'diag_info',
    enabled = function() return lsp.diagnostics_exist('Information') end,
    hl = {
        fg = 'nord_blue',
        bg = 'statusline_bg',
    },
})

-- spell checker
table.insert(components.active[3], {
    provider = '暈',
    enabled = function() return vim.wo.spell end,
    hl = {
        fg = 'yellow',
        bg = 'statusline_bg',
        style = 'bold'
    },
    right_sep = {
        str = ' ',
        hl = {
            bg = 'statusline_bg',
            fg = 'mid_bg',
            style = 'bold'
        },
    },
})

-- fileIcon
table.insert(components.active[3], {
    provider = function()
        local filename = vim.fn.expand('%:t')
        local extension = vim.fn.expand('%:e')
        local icon  = require'nvim-web-devicons'.get_icon(filename, extension)
        if icon == nil then
            icon = ''
        end
        return icon
    end,
    enabled = function() return vim.fn.expand('%:t') ~= '' end,
    hl = function()
        local val = {}
        local filename = vim.fn.expand('%:t')
        local extension = vim.fn.expand('%:e')
        local icon, name  = require'nvim-web-devicons'.get_icon(filename, extension)
        if icon ~= nil then
            val.fg = vim.fn.synIDattr(vim.fn.hlID(name), 'fg')
        else
            val.fg = 'grey_fg'
        end
        val.bg = 'statusline_bg'
        val.style = 'bold'
        return val
    end,
    right_sep = {
        str = ' ',
        hl = {
            bg = 'statusline_bg',
            fg = 'mid_bg',
            style = 'bold'
        },
    },
    left_sep = {
        str = ' ',
        hl = {
            bg = 'statusline_bg',
            fg = 'mid_bg',
            style = 'bold'
        },
    },
})

table.insert(components.active[3], {
    provider = 'file_type',
    enabled = function() return vim.fn.expand('%:t') ~= '' end,
    hl = function()
        local val = {}
        local filename = vim.fn.expand('%:t')
        local extension = vim.fn.expand('%:e')
        local icon, name  = require'nvim-web-devicons'.get_icon(filename, extension)
        if icon ~= nil then
            val.fg = vim.fn.synIDattr(vim.fn.hlID(name), 'fg')
        else
            val.fg = 'grey_fg'
        end
        val.bg = 'statusline_bg'
        val.style = 'bold'
        return val
    end,
    right_sep = {
        str = ' ',
        hl = {
            fg = 'mid_bg',
            bg = 'statusline_bg',
            style = 'bold'
        },
    }
})

-- search results key
table.insert(components.active[3], {
    provider = 'search_results',
    truncate_hide = true,
    hl = right_ribbon_hl,
    right_sep = {
        str = ' ',
        hl = {
            fg = 'mid_bg',
            bg = 'statusline_bg',
            style = 'bold'
        },
    }
})

table.insert(components.active[3], {
    provider = "",
    hl = function()
        return {
            fg = 'light_bg',
            bg = vi_mode_utils.get_mode_color(),
            style = 'bold',
        }
    end,
    left_sep = "left_rounded",
})

table.insert(components.active[3], {
    provider = 'quickfix_count',
    enabled = function()
        return #vim.fn.getqflist() > 0
    end,
    truncate_hide = true,
    hl = function()
        return {
            fg = 'red_dark',
            bg = vi_mode_utils.get_mode_color(),
            style = 'bold',
        }
    end,
})

local locallist_conf = {
    provider = 'locallist_count',
    enabled = function()
        return #vim.fn.getloclist(0) > 0
    end,
    truncate_hide = true,
    hl = function()
        return {
            fg = 'purple',
            bg = vi_mode_utils.get_mode_color(),
            style = 'bold',
        }
    end,
}
table.insert(components.active[3], locallist_conf)

table.insert(components.active[3], {
    provider = 'position',
    hl = function()
        return {
            fg = 'statusline_bg',
            bg = vi_mode_utils.get_mode_color(),
            style = 'bold',
        }
    end,
    right_sep = {
        str = ' ',
        hl = function()
            return {
                fg = vi_mode_utils.get_mode_color(),
                bg = 'statusline_bg',
                style = 'bold',
            }
        end,
    }
})

table.insert(components.active[3], {
    provider = 'line_percentage',
    hl = function()
        return {
            fg = vi_mode_utils.get_mode_color(),
            bg = 'statusline_bg',
            style = 'bold',
        }
    end,
})

table.insert(components.inactive[1], {
    provider = 'git_root',
    enabled = function() return require('feline.providers.git').git_info_exists() end,
    truncate_hide = true,
    hl = {
        fg = 'white',
        bg = 'short_bg',
        style = 'bold'
    },
    left_sep = {
        str = 'github_icon',
        hl = {
            fg = 'white',
            bg = 'short_bg',
            style = 'bold'
        },
    },
    right_sep = {
        str = "slant_right_2",
        hl = {
            fg = 'short_bg',
            bg = 'mid_bg',
            style = 'bold'
        },
    },
})

table.insert(components.inactive[2], {
    provider = {
        name = 'file_info',
        opts = {
            type = 'full-path',
            file_modified_icon = '',
            file_readonly_icon = '🔒',
        }
    },
    short_provider = {
        name = 'file_info',
        opts = {
            type = 'relative',
            file_modified_icon = '',
            file_readonly_icon = '🔒',
        }
    },
    enabled = function() return vim.fn.expand('%:t') ~= '' end,
    hl = {
        fg = 'grey_fg',
        bg = 'short_bg',
    },
    left_sep = {
        str = "slant_right_2",
        hl = {
            fg = 'mid_bg',
            bg = 'short_bg',
            style = 'bold'
        },
    },
    right_sep = {
        str = "slant_right_2",
        hl = {
            fg = 'short_bg',
            bg = 'mid_bg',
            style = 'bold'
        },
    },
})

table.insert(components.inactive[3], {
    provider = '',
    hl = {
        fg = 'mid_bg',
        bg = 'green_pale',
        style = 'bold',
    },
    left_sep = {
        str = 'slant_left',
        hl = {
            fg = 'green_pale',
            bg = 'mid_bg',
        },
    }
})

table.insert(components.inactive[3], locallist_conf)

table.insert(components.inactive[3], {
    provider = 'position',
    hl = {
        fg = 'light_bg',
        bg = 'green_pale',
        style = 'bold'
    },
})

table.insert(components.inactive[3], {
    provider = 'line_percentage',
    hl = {
        fg = 'green_pale',
        bg = 'mid_bg',
    },
    left_sep = {
        str = ' ',
        hl = {
            fg = 'green_pale',
            bg = 'mid_bg',
        },
    }
})

require('feline').setup({
    colors           = util.colors,
    default_bg       = util.colors.bg,
    default_fg       = util.colors.fg,
    vi_mode_colors   = util.vi_mode_colors,
    components       = components,
    force_inactive   = util.force_inactive,
    separators       = util.separators,
    custom_providers = {
        vim_mode        = util.vim_mode,
        search_results  = util.search_results,
        ale_diagnostics = util.ale_diagnostics,
        locallist_count = util.locallist_count,
        quickfix_count  = util.quickfix_count,
        git_root        = util.git_root,
        diag_errors     = lsp.diagnostic_errors,
        diag_info       = lsp.diagnostic_info,
        diag_warnings   = lsp.diagnostic_warnings,
        diag_hints      = lsp.diagnostic_hints,
    },
})
