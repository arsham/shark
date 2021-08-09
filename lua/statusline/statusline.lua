local gl = require('galaxyline')
local condition = require('galaxyline.condition')
local util = require('statusline.util')
local gls = gl.section

gl.short_line_list = {'NvimTree'}

gls.left = {

    {
        FirstElement = {
            provider = function() return "▋" end,
            highlight = {util.colors.nord_blue, util.colors.nord_blue},
        }
    },

    {
        StatusIcon = {
            provider = function() return "  " end,
            highlight = {util.colors.statusline_bg, util.colors.nord_blue},
            separator = ' ',
            separator_highlight = {util.colors.nord_blue, util.colors.light_bg},
        }
    },

    {
        ViMode = {
            provider = util.mode,
            icon = "  ",
            separator = " ",
            highlight = {util.colors.red, util.colors.light_bg}
        }
    },

    {
        ParentDir = {
            provider = util.parent_dir_name,
            highlight = {util.colors.grey_fg, util.colors.light_bg2},
            separator = " ",
            icon = " ",
            separator_highlight = {util.colors.light_bg2, util.colors.statusline_bg},
            condition = condition.hide_in_width,
        }
    },

    {
        DiffAdd = {
            provider = "DiffAdd",
            condition = function()
                return condition.hide_in_width() and condition.check_git_workspace()
            end,
            icon = "  ",
            highlight = {util.colors.white, util.colors.statusline_bg}
        }
    },

    {
        DiffModified = {
            provider = "DiffModified",
            condition = function()
                return condition.hide_in_width() and condition.check_git_workspace()
            end,
            icon = "  ",
            highlight = {util.colors.grey_fg, util.colors.statusline_bg}
        }
    },

    {
        DiffRemove = {
            provider = "DiffRemove",
            condition = function()
                return condition.hide_in_width() and condition.check_git_workspace()
            end,
            icon = "  ",
            highlight = {util.colors.grey_fg, util.colors.statusline_bg}
        }
    },
}

gls.mid = {
    {
        FileName = {
            provider = {util.get_current_file_name, "FileIcon", "FileSize"},
            condition = condition.buffer_not_empty,
            highlight = {util.colors.white, util.colors.mid_bg},
            separator_highlight = {util.colors.mid_bg, util.colors.mid_bg},
        }
    },
}

gls.right = {

    {
        DiagnosticIcon = {
            provider = util.ale_lsp,
            separator = ' ',
            separator_highlight = {util.colors.statusline_bg, util.colors.statusline_bg},
            highlight = {util.colors.grey_fg, util.colors.statusline_bg},
        },
    },

    {
        AleStatus = {
            provider = util.ale_diagnostics,
            highlight = {util.colors.yellow, util.colors.statusline_bg}
        },
    },

    {
        LspProvider = {
            provider = util.lsp_provider,
            separator_highlight = {util.colors.statusline_bg, util.colors.statusline_bg},
            highlight = {util.colors.grey_fg, util.colors.statusline_bg},
            condition = condition.hide_in_width,
        }
    },

    {
        DiagnosticError = {
            provider = "DiagnosticError",
            icon = "  ",
            highlight = {util.colors.red, util.colors.statusline_bg}
        }
    },

    {
        DiagnosticWarn = {
            provider = "DiagnosticWarn",
            icon = "  ",
            highlight = {util.colors.yellow, util.colors.statusline_bg}
        }
    },

    {
        SpellCheck = {
            provider = function()
                if vim.wo.spell then return '暈' end
            end,
            highlight = {util.colors.yellow, util.colors.statusline_bg},
            condition = condition.hide_in_width,
        }
    },

    {
        BufferType = {
            provider = util.buffer_type,
            separator_highlight = {util.colors.statusline_bg,util.colors.statusline_bg},
            highlight = {util.colors.grey_fg, util.colors.statusline_bg},
        }
    },

    {
        GitBranch = {
            provider = {
                util.git_root,
                util.get_git_branch,
            },
            highlight = {util.colors.grey_fg, util.colors.statusline_bg},
            condition = condition.check_git_workspace,
        }
    },

    {
        RightIcon = {
            provider = function() return " " end,
            separator = " ",
            separator_highlight = {util.colors.green, util.colors.light_bg},
            highlight = {util.colors.light_bg, util.colors.green},
        }
    },

    {
        QuickFixCount = {
            provider = function()
                local count = #vim.fn.getqflist()
                if count == 0 then
                    return nil
                end
                return string.format(" ﰠ %d ", count)
            end,
            highlight = {util.colors.red_dark, util.colors.green},
        },
    },

    {
        LocListCount = {
            provider = function()
                local count = #vim.fn.getloclist(0)
                if count == 0 then
                    return nil
                end
                return string.format("  %d ", count)
            end,
            highlight = {util.colors.purple, util.colors.green},
        },
    },

    {
        LineInfo = {
            provider = 'LineColumn',
            separator_highlight = {util.colors.green, util.colors.light_bg},
            highlight = {util.colors.light_bg, util.colors.green},
        },
    },

    {
        LineLocation = {
            provider = util.line_location,
            highlight = {util.colors.green, util.colors.light_bg},
        }
    },
}

gls.short_line_left = {
    {
        SParentDir = {
            provider = util.parent_dir_name,
            highlight = {util.colors.white, util.colors.mid_bg},
            separator = "  ",
            icon = " ",
            separator_highlight = {util.colors.mid_bg, util.colors.mid_bg},
        }
    },

    {
        SFileName = {
            provider = {util.get_current_file_name, "FileIcon", "FileSize"},
            condition = condition.buffer_not_empty,
            highlight = {util.colors.white, util.colors.mid_bg},
            separator_highlight = {util.colors.mid_bg, util.colors.mid_bg},
        }
    },
}

gls.short_line_right = {
    {
        SRightIcon = {
            provider = function() return " " end,
            separator = " ",
            separator_highlight = {util.colors.green, util.colors.mid_bg},
            highlight = {util.colors.mid_bg, util.colors.green},
        }
    },

    {
        SLineInfo = {
            provider = 'LineColumn',
            separator_highlight = {util.colors.green, util.colors.light_bg},
            highlight = {util.colors.light_bg, util.colors.green},
        },
    },

    {
        SLineLocation = {
            provider = util.line_location,
            highlight = {util.colors.green, util.colors.mid_bg},
        }
    },
}
