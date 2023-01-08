---@class HighlightOpt
---@field style string
---@field link? string if defined, everything else is ignored
---@field guifg string
---@field guibg string
---@field guisp string
---@field ctermfg string
---@field ctermbg string

---@class Quick
---@field command fun(name: string, command: string|function, opts?: table) Creates a command from provided specifics.
---@field normal fun(mode: string, motion: string, special: boolean?) Executes a command in normal mode.
---@field selection_contents fun(): string Returns the contents of the visually selected region.
---@field buffer_command fun(name: string, command: string|function, opts?: table) Creates a command from provided specifics on current buffer.
---@field call_and_centre fun(fn: fun()) Pushes the current location to the jumplist and calls the fn callback, then centres the cursor.
---@field highlight fun(group: string, opt: HighlightOpt) --Create a highlight group.

---@class LazyFloatOptions
---@field buf? number
---@field file? string
---@field margin? {top?:number, right?:number, bottom?:number, left?:number}
---@field size? {width:number, height:number}
---@field zindex? number
---@field style? "" | "minimal"
---@field border? "none" | "single" | "double" | "rounded" | "solid" | "shadow"

---@class LazyCmdOptions: LazyFloatOptions
---@field cwd? string
---@field env? table<string,string>
---@field float? LazyFloatOptions
