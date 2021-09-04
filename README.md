# NeoVim

The goal of this setup is to start-up fast, provide mappings that can be easily
memorised, interact with the **Lua** API, and make programming fun. This is not
a framework.

This setup is mostly customised to be used for **Go** (**Golang**) development.
But there are a few other **LSP** servers setup as well.

## Highlights

* Besides in a few places that Neovim doesn't provide an API in Lua, most
  configuration is done in **Lua**.
* It loads really fast! With about **38 plugins**, it takes **18ms** to
  **25ms** on average to start. (benchmarked with the `StartupTime` benchmark
  tool).
* There are a few **Lua** functions available for setting up
  **autocmd/augroup** and **commands** that accept **Lua functions** to run.
  They are super cool, check them out!
* **LSP**, **Treesitter**, and **fzf** are setup to work together.
* It is optimised to handle very **large** files.
* There are some handy **textobjects** such as **backticks** and **indents**.
* You can make **notes** for files/lines in the **quickfix/local** lists.
* You can **manipulate** quickfix/local lists.
* Statusline is configures with **galaxyline**.
* The theme is inspired by Sonokai theme; However it is setup with Lua to take
  advantage of its performance.

1. [Setup](#setup)
2. [Functionality](#functionality)
    * [Plugins](#plugins)
    * [Core Mappings](#core-mappings)
    * [Text Objects](#text-objects)
    * [Lists](#lists)
    * [Matching](#matching)
    * [FZF](#fzf)
    * [LSP and ALE](#lsp-and-ale)
    * [Commands](#commands)
    * [Utilities](#utilities)
3. [Folder Structure](#folder-structure)

## Setup

Just use **Stow** and stow this folder. Once you start Neovim, it will install
the package manager and installs the listed plugins.

You need to run the `InstallDependencies` command to install LSP servers and
other dependencies. Some dependencies can't be installed with this tool (yet),
therefore you need to install them manually. The command will let you know what
you need to install in the notification.

## Functionality

Some default mappings/commands are augmented to **centre the buffer** after the
execution.

Some mappings/commands are obvious, but I've left them here as a reminder. Some
are left out either because they are not used too often, or they are defined
after writing this document and I've forgot to document.

I would recommend you have a look at the code to see what is available to you.

### Plugins

This list might change at any time depending on if there is a better
replacement or the requirement changes.

<details>
    <summary>Click to view the plugin list</summary>

* [wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)
* [junegunn/fzf.vim](https://github.com/junegunn/fzf.vim)
* [junegunn/fzf](https://github.com/junegunn/fzf)
* [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
* [dense-analysis/ale](https://github.com/dense-analysis/ale)
* [nvim-lua/completion-nvim](https://github.com/nvim-lua/completion-nvim)
* [ojroques/nvim-lspfuzzy](https://github.com/ojroques/nvim-lspfuzzy)
* [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
* [nvim-treesitter/nvim-treesitter-refactor](https://github.com/nvim-treesitter/nvim-treesitter-refactor)
* [nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
* [David-Kunz/treesitter-unit](https://github.com/David-Kunz/treesitter-unit)
* [kyazdani42/nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua)
* [glepnir/galaxyline.nvim](https://github.com/glepnir/galaxyline.nvim)
* [gelguy/wilder.nvim](https://github.com/gelguy/wilder.nvim)
* [kevinhwang91/nvim-bqf](https://github.com/kevinhwang91/nvim-bqf)
* [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)
* [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
* [b3nj5m1n/kommentary](https://github.com/b3nj5m1n/kommentary)
* [tpope/vim-repeat](https://github.com/tpope/vim-repeat)
* [arthurxavierx/vim-caser](https://github.com/arthurxavierx/vim-caser)
* [junegunn/vim-easy-align](https://github.com/junegunn/vim-easy-align)
* [mg979/vim-visual-multi](https://github.com/mg979/vim-visual-multi)
* [tommcdo/vim-exchange](https://github.com/tommcdo/vim-exchange)
* [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)
* [rcarriga/nvim-notify](https://github.com/rcarriga/nvim-notify)
* [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim)
* [steelsojka/completion-buffers](https://github.com/steelsojka/completion-buffers)
* [uarun/vim-protobuf](https://github.com/uarun/vim-protobuf)
* [towolf/vim-helm](https://github.com/towolf/vim-helm)
* [blackCauldron7/surround.nvim](https://github.com/blackCauldron7/surround.nvim)
* [glts/vim-textobj-comment](https://github.com/glts/vim-textobj-comment)
* [kana/vim-textobj-user](https://github.com/kana/vim-textobj-user)
* [kyazdani42/nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)
* [dhruvasagar/vim-zoom](https://github.com/dhruvasagar/vim-zoom)
* [norcalli/nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua)
* [bronson/vim-trailing-whitespace](https://github.com/bronson/vim-trailing-whitespace)
* [SirVer/ultisnips](https://github.com/SirVer/ultisnips)
* [tweekmonster/startuptime.vim](https://github.com/tweekmonster/startuptime.vim)
* [tjdevries/astronauta.nvim](https://github.com/tjdevries/astronauta.nvim)

</details>

### Core Mappings

In most mappings we are following this theme, unless there is an uncomfortable
situation or messes with a community-driven or Vim's very well known mapping:

| Part of mapping | Description                                                |
| :---            | :---                                                       |
| **q**           | **quickfix** list mappings                                 |
| **w**           | **local list** mappings                                    |
| **d**           | LSP diagnostics                                            |
| **l**           | ALE **l**inting                                            |
| **g**           | **G**o to, Jump to, run something that goes to or jumps to |
| **m**           | **M**atch highlighting, marks                              |
| **f**           | **F**ile, **F**ind                                         |

<details>
    <summary>Click to view the mappings</summary>

| Mapping      | Description                                             |
| :---         | :---                                                    |
| `<leader>kb` | Toggles Neovim tree                                     |
| `<leader>kf` | Finds current file in the Neovim tree                   |
| `<Alt-j>`    | Shifts line(s) down one line and format                 |
| `<Alt-k>`    | Shifts line(s) up one line and format                   |
| `<Alt-,>`    | Adds `,` at the end of current line without moving      |
| `<Alt-.>`    | Adds `.` at the end of current line without moving      |
| `<Alt-{>`    | Adds curly brackets at the end of line into insert mode |
| `]<space>`   | Inserts [count] empty lines after                       |
| `[<space>`   | Inserts [count] empty lines before                      |
| `<leader>gw` | **G**reps for current **W**ord                          |
| `<leader>sp` | Toggles **Sp**elling on current buffer                  |
| `<leader>sf` | Auto **f**ixes previous misspelled word                 |
| `g=`         | Re-indents the hole buffer                              |
| `]c`         | (gitsigns) Next hunk                                    |
| `[c`         | (gitsigns) Previous hunk                                |
| `<leader>hb` | (gitsigns) **B**lame line                               |
| `<leader>hs` | (gitsigns) **S**tage **h**unk                           |
| `<leader>hu` | (gitsigns) **U**nstage **h**unk                         |
| `<leader>hr` | (gitsigns) **R**eset staged **h**unk                    |
| `<leader>hR` | (gitsigns) **R**eset buffer                             |
| `<leader>hp` | (gitsigns) **P**review **h**unk                         |
| `]]`         | Jumps to the next function                              |
| `[[`         | Jumps to the previous function                          |
| `<leader>hh` | Opens the **help** for current word                     |

</details>


### Text Objects

<details>
    <summary>Click to view the text objects</summary>

| Text Object | Description                                |
| :---        | :---                                       |
| `H`         | To the beginning of line                   |
| `L`         | To the end of line                         |
| `ii`        | **I**n **I**ndentation                     |
| i`          | **I**n backtick (`) pairs (multi-line)     |
| a`          | **A**round backtick (`) pairs (multi-line) |
| `an`        | **A**round **N**ext pairs (current lint)   |
| `in`        | **I**n **N**ext pairs (current line)       |
| `il`        | **I**n line                                |
| `al`        | **A**round line                            |
| `iN`        | **I**n numeric value (can be float too)    |
| `ih`        | Select **H**unk                            |
| `af`        | **A**round **F**unction                    |
| `if`        | **I**n **F**unction                        |
| `am`        | **A**round **M**ethod                      |
| `im`        | **I**n **M**ethod                          |
| `ab`        | **A**round **B**lock                       |
| `ib`        | **I**n **B**lock                           |

There are sets of **i*** and **a*** text objects, where `*` can be any of:
**_ . : , ; | / \ * + - #**

</details>

### Lists

There are a few tools for interacting with **quickfix** and **local** lists.
Following mappings can be used for either cases, all you need to do it to
substitute `w` for `q` or vice versa. Generally **q** is for **quickfix** list
and **w** is for **local list**.

After adding an item to the list, an indicator in the statusline will show you
how many items you have in a list.

<details>
    <summary>Click to view mappings for lists</summary>

| Mapping      | Description                                                      |
| :---         | :---                                                             |
| `<leader>qq` | Add current line and column to the list.                         |
| `<leader>qn` | Add current line and column with a **note**. (you will be asked) |
| `<leader>qc` | **Clear** the list.                                              |
| `]q` & `]w`  | Go to the next item in the list and centre.                      |
| `[q` & `[w`  | Go to the previous item in the list and centre.                  |

</details>

Additional to [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) bindings,
you can do `<count>dd` in the quickfix/local list buffers to delete `<count>`
rows from quickfix/local list buffer.

### Matching

You can highlight words with random colours. We are using the `match`
functionality, which means these groups are applied only to the current buffer.

<details>
    <summary>Click to view the mappings</summary>

| Mapping      | Description                                              |
| :---         | :---                                                     |
| `<leader>ma` | **A**dd current word as a sub-pattern to the highlights. |
| `<leader>me` | Add an **e**xact match on current term.                  |
| `<leader>mp` | Add an match by asking for a **p**attern.                |
| `<leader>mc` | **C**lear all matched patterns on current buffer.        |

</details>

### Fzf

<details>
    <summary>Click to view the mappings</summary>

Most actions can apply to multiple selected items if possible.

| Mapping            | Description                                            |
| :---               | :---                                                   |
| `<Ctrl-p>`         | File list in current folder.                           |
| `<Alt-p>`          | File list in home folder.                              |
| `<Ctrl-b>`         | **B**uffer list.                                       |
| `<Alt-b>`          | Delete **b**uffers from the buffer list.               |
| `<Ctrl-/>`         | Search in lines on current buffer.                     |
| `<Alt-/>`          | Search in lines of all open buffers.                   |
| `<leader>@`        | Search in ctags or LSP symbols (see note below).       |
| `<leader>:`        | Commands                                               |
| `<leader>ff`       | **F**ind in contents of all files in current folder.   |
| `<leader>fa`       | **F**ind **A**ll disabling `.gitignore` handling.      |
| `<leader>rg`       | Search (**rg**) with current word.                     |
| `<leader>ra`       | Search (**rg**) disabling `.gitignore` handling.       |
| `<leader>fh`       | **F**ile **H**istory                                   |
| `<leader>fl`       | File **locate** (requires mlocate)                     |
| `<leader>gg`       | **GGrep**                                              |
| `<leader>gf`       | **GFiles**                                             |
| `<leader>mm`       | **Marks**                                              |
| `z=`               | Show spell recommendation                              |
| `<Ctrl-x><Ctrl-k>` | Search in **dictionaries** (requires **words-insane**) |

When a file is selected, additional to what fzf provides out of the box, you
can invoke one of these secondary actions:


| Mapping | Description                        |
| :---    | :---                               |
| `/`     | To search in the lines.            |
| `@`     | To search in ctags or lsp symbols. |
| `:`     | To go to a specific line.          |
| `alt-q` | Add items to the quickfix list.    |

Note that if a `LSP` server is not attached to the buffer, it will fall back to
`ctags`.

</details>

There are a few added commands to what fzf provides.

<details>
    <summary>Click to view the commands</summary>

| Command     | Description                                |
| :---        | :---                                       |
| ArgAdd      | Select and add files to the args list      |
| ArgDelete   | Select and delete files from the args list |
| GGrep       | Run **git grep**                           |
| MarksDelete | Delete marks                               |
| Todo        | List **todo**/**fixme** lines              |

</details>

### LSP and ALE

When a LSP server is attached to a buffer, a bunch of mappings will be defined
for that buffer. When possible, fzf will take over the results of the LSP
mappings results. ALE also provides some mappings internally.

<details>
    <summary>Click to view the mappings</summary>

| Mapping       | Description                                 |
| :---          | :---                                        |
| `<leader>ll`  | Run ALE **l**inters                         |
| `]l`          | Go to next **l**inting issue                |
| `[l`          | Go to previous **l**inting issue            |
| `]d`          | Go to next **d**iagnostic issue             |
| `[d`          | Go to previous **d**iagnostic issue         |
| `<leader>gq`  | Format the buffer with LSP                  |
| `H`           | **H**over popup                             |
| `K`           | Show **Signature**                          |
| `<Ctrl-k>`    | (insert mode) Show **Signature**            |
| `gd`          | **G**o to **D**efinition                    |
| `gD`          | **G**o to **D**eclaration                   |
| `<leader>gi`  | **G**o to **I**mplementation                |
| `gr`          | Show **R**eferences                         |
| `<leader>@`   | Document Symbols                            |
| `<leader>gc`  | Show **C**allers                            |
| `<Tab>`       | (insert mode) Next completion item          |
| `<Shift-Tab>` | (insert mode) Previous completion item      |
| `<Ctrl-j>`    | (insert mode) Next completion source        |
| `<Ctrl-k>`    | (insert mode) Previous completion source    |
| `<leader>dd`  | Show line **D**iagnostics                   |
| `<leader>dq`  | Fill the **Q**uicklist with **D**iagnostics |
| `<leader>dw`  | Fill the local list with **D**iagnostics    |
| `<leader>dr`  | Restart the LSP server (see below)          |

Please note that the `<leader>@` binding will use the `LSP` symbols if is
attached to the buffer, and `ctags` if not.

Please see the code for all available mappings.
</details>

LSP and ALE define their own set of commands, I have added a few useful ones.

<details>
    <summary>Click to view the commands</summary>

| Command            | Description                                   |
| :---               | :---                                          |
| `RestartLsp`       | Restart LSP with a delay.                     |
| `Rename`           | Rename a symbol                               |
| `Test`             | Find a test with the name of current function |
| `Log`              | Show LSP logs                                 |
| `TypeDefinition`   |                                               |
| `WorkspaceSymbols` |                                               |
| `Callees`          |                                               |
| `Callers`          |                                               |
| `Diagnostics`      |                                               |
| `DiagnosticsAll`   |                                               |

</details>

The `RestartLsp` fixes an issue when the `LspRestart` does not have any
effects.

### Commands

The following list of commands do not land into any specific categories.

<details>
    <summary>Click to view the commands</summary>

| Command               | Description                           |
| :---                  | :---                                  |
| `Filename`            | View the filename                     |
| `YankFilename`        | Yank the filename to `"` register     |
| `YankFilenameC`       | Yank the filename to `+` register     |
| `YankFilepath`        | Yank the file path to `"` register    |
| `YankFilepathC`       | Yank the file path to `+` register    |
| `MergeConflict`       | Search for merge conflicts            |
| `JsonDiff`            | Diff json files after formatting them |
| `InstallDependencies` | Install required dependencies         |

After running `InstallDependencies` you will be notified to install some
programs.

</details>

### Utilities

These are commands you can use in **Lua** land. Assign the required module to a
variable and re-use.

```lua
local util = require('util')
```

#### Normal

Executes a normal command. For example:

```lua
util.normal('n', 'y2k')
```

See `:h feedkeys()` for values of the mode.

#### Command

Creates a command. It can accept a LUA function or a VimL string.

```lua
util.command{"Filename", function()
    print(vim.fn.expand '%:p')
end}
util.command{"Notes", "call fzf#vim#files('~/Dropbox/Notes', <bang>0)", attrs="-bang"}
util.command{"Todo", "grep todo|fixme **/*", post_run="cw", silent=true}
util.command{"Yepyepyep", function() print("aha aha") end, docs="useless command!"}
```

The `docs` is useful when you query `:verbose command Yepyepyep` to identify
what's happening.

#### Augroup and Autocmd

```lua
util.augroup{"SOME_AUTOMATION", {
    {"BufReadPost", "*", function()
        vim.notify("This just happened!", vim.lsp.log_levels.INFO)
    end},
    {"BufReadPost", buffer=true, run=":ALELintStop"},
    {"BufReadPost", "*.go", docs="an example of nested autocmd", run=function()
        vim.notify("Buffer is read", vim.lsp.log_levels.INFO)
        util.autocmd{"BufDelete", buffer=true, run=function()
            vim.notify("Buffer deleted", vim.lsp.log_levels.INFO)
        end}
    end},
}}

-- Or on its own.
util.autocmd{"BufLeave", "*", function()
    vim.notify("Don't do this though", vim.lsp.log_levels.INFO)
end},
```

#### Highlight

Create `highlight` groups:

```lua
util.highlight("LspReferenceRead",  {ctermbg=180, guibg='#43464F', style='bold'})
```

#### Call and Centre

These functions will call your function/command and then centres the buffer:

```lua
util.call_and_centre(function() print("Yolo!") end)
util.cmd_and_centre("ALENextWrap")
```

#### User Input

This launches a popup buffer for the input:

```lua
util.user_input{
    prompt = "Message: ",
    on_submit = function(value)
        print("Thank you for your note: " .. value)
    end,
}
```

#### Dump

Unpacks and prints tables. This function is injected into the global variable.

```lua
util.dump({name = "Arsham"})
```

## Folder Structure

You will notice not everything is where they should be. For example there is a
`lua/mappings.lua` file that contains a lot of mappings, but there are a few
more in plugin settings and lsp folder. The same goes for the commands.

The reason for this is because I wanted to make sure if I disable a plugin,
none of its associated mappings or commands are loaded.

<details>
    <summary>Click to view the tree</summary>

```bash
.
├── init.lua                         # Entry point.
├── colors
│   └── arsham.vim
├── lua
│   ├── arsham.lua                   # My colorscheme.
│   ├── autocmd.lua
│   ├── commands.lua
│   ├── textobjects.lua
│   ├── lists.lua                    # Manages quickfix and local lists.
│   ├── matching.lua                 # To highlight matched words.
│   ├── mappings.lua
│   ├── options.lua                  # Core settings.
│   ├── plugins.lua                  # Plugings are loaded here.
│   ├── settings                     # Pluging settings are here.
│   │   ├── init.lua
│   │   ├── ale.lua
│   │   ├── completion.lua
│   │   ├── fzf
│   │   │   └── init.lua
│   │   ├── gitsigns.lua
│   │   ├── lsp
│   │   │   └── init.lua
│   │   ├── treesitter.lua
│   │   └── wilder.lua               # For fuzzy Ex commands.
│   ├── statusline                   # Galaxyline config.
│   │   └── init.lua
│   ├── util
│   │   └── init.lua                 # Common utilities.
│   └── visuals.lua
└── spell
```
</details>
