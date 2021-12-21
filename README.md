# NeoVim

The goal of this project is to have a fast Neovim startup, provide mappings
that can be easily memorised, interact with the **Lua** API, and make
programming fun.

This setup is mostly customised to for **Go** (**Golang**) development. But
there are a few other **LSP** servers setup as well.

## Highlights

* Besides in a few places that Neovim doesn't provide an API in Lua, most
  configuration is done in **Lua**.
* It loads really fast! With over **60 plugins**, it takes **14ms** to
  **20ms** on average to start. (benchmarked with the `StartupTime` benchmark
  tool).
* There are a few **Lua** functions available for setting up
  **autocmd/augroup** and **commands** that accept **Lua functions** to run.
  They are super cool, check them out!
* **LSP**, **Treesitter**, and **fzf** are setup to work together.
* Completion with **nvim-cmp** plugin is setup.
* It is optimised to handle very **large** files.
* There are some handy **textobjects** such as **backticks** and **indents**.
* You can add the current location of the cursor or make **notes** on the
  current location in the **quickfix/local** lists with repeatable mappings.
* You can **manipulate** quickfix/local lists.
* It comes with integration with **git** and gist.
* Has a lot of useful feedback in the gutter.
* Bindings for using the **cht.sh** service.
* Statusline is configures with **feline**. It is set to give a lot of useful
  information about the buffer.
* Prettier quickfix buffer.
* The theme is setup with Lua to take advantage of its performance.

1. [Setup](#setup)
2. [Functionality](#functionality)
    * [Plugins](#plugins)
    * [Core Mappings](#core-mappings)
    * [Text Objects](#text-objects)
    * [Lists](#lists)
    * [Highlight Matching](#highlight-matching)
    * [FZF](#fzf)
    * [LSP](#lsp)
    * [Commands](#commands)
    * [Utilities](#utilities)
3. [Folder Structure](#folder-structure)

## Setup

Just use **Stow** and stow this folder. Once you start Neovim, it will install
the package manager and installs the listed plugins.

You need to run the `InstallDependencies` command to install some dependencies.
Run `TSUpdate` to satisfy treesitter dependencies, and finally run
`LspInstallInfo` and install the LSP servers you need. Some dependencies can't
be installed with this tool (yet), therefore you need to install them manually.
The command will let you know what you need to install in the notification.

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

Some plugins are not listed here. You can find the complete list in the
[plugins.lua](./lua/plugins.lua) file.

| Plugin                                                                                                        | Description                                            |
| :---                                                                                                          | :---                                                   |
| [wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)                                           | Package manager                                        |
| [junegunn/fzf.vim](https://github.com/junegunn/fzf.vim)                                                       | Fuzzy matching a lot of actions                        |
| [junegunn/fzf](https://github.com/junegunn/fzf)                                                               |                                                        |
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                                             | LSP configuration                                      |
| [williamboman/nvim-lsp-installer](https://github.com/williamboman/nvim-lsp-installer)                         | Automatically install LSP servers                      |
| [ojroques/nvim-lspfuzzy](https://github.com/ojroques/nvim-lspfuzzy)                                           | Use FZF for various LSP actions                        |
| [jose-elias-alvarez/null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim)                         |                                                        |
| [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)                                                       | Completion, and its related plugins.                   |
| [nanotee/sqls.nvim](https://github.com/nanotee/sqls.nvim)                                                     | SQL LSP                                                |
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)                         | Highlighting engine                                    |
| [nvim-treesitter/nvim-treesitter-refactor](https://github.com/nvim-treesitter/nvim-treesitter-refactor)       |                                                        |
| [nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) |                                                        |
| [David-Kunz/treesitter-unit](https://github.com/David-Kunz/treesitter-unit)                                   |                                                        |
| [numToStr/Navigator.nvim](https://github.com/numToStr/Navigator.nvim)                                         | Seamlessly navigate between tmux panes and vim windows |
| [kyazdani42/nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua)                                       | File explorer tree                                     |
| [famiu/feline.nvim](https://github.com/famiu/feline.nvim)                                                     | Statusline (default)                                   |
| [glepnir/galaxyline.nvim](https://github.com/glepnir/galaxyline.nvim)                                         | Statusline                                             |
| [gelguy/wilder.nvim](https://github.com/gelguy/wilder.nvim)                                                   | Fuzzy completion for command mode                      |
| [kevinhwang91/nvim-bqf](https://github.com/kevinhwang91/nvim-bqf)                                             | Better quickfix list manager                           |
| [stevearc/dressing.nvim](https://github.com/stevearc/dressing.nvim)                                           | Better quickfix list manager                           |
| [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive) and vim-rhubarb                                   | git integration                                        |
| [mattn/vim-gist](https://github.com/mattn/vim-gist)                                                           | gist integration                                       |
| [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)                                         | git signs in the gutter                                |
| [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)                                             |                                                        |
| [JoosepAlviste/nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring) |                                                        |
| [tpope/vim-repeat](https://github.com/tpope/vim-repeat)                                                       |                                                        |
| [vim-scripts/visualrepeat](https://github.com/vim-scripts/visualrepeat)                                       | Repeat in visual mode                                  |
| [arthurxavierx/vim-caser](https://github.com/arthurxavierx/vim-caser)                                         | Case conversion                                        |
| [junegunn/vim-easy-align](https://github.com/junegunn/vim-easy-align)                                         | Text alignment                                         |
| [mg979/vim-visual-multi](https://github.com/mg979/vim-visual-multi)                                           | Multiple cursors                                       |
| [tommcdo/vim-exchange](https://github.com/tommcdo/vim-exchange)                                               | Text exchange operator                                 |
| [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)                                             |                                                        |
| [rcarriga/nvim-notify](https://github.com/rcarriga/nvim-notify)                                               | Better notification UI                                 |
| [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim)                                               | UI component                                           |
| [uarun/vim-protobuf](https://github.com/uarun/vim-protobuf)                                                   |                                                        |
| [towolf/vim-helm](https://github.com/towolf/vim-helm)                                                         |                                                        |
| [blackCauldron7/surround.nvim](https://github.com/blackCauldron7/surround.nvim)                               |                                                        |
| [glts/vim-textobj-comment](https://github.com/glts/vim-textobj-comment)                                       |                                                        |
| [kana/vim-textobj-user](https://github.com/kana/vim-textobj-user)                                             |                                                        |
| [kyazdani42/nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)                               |                                                        |
| [dhruvasagar/vim-zoom](https://github.com/dhruvasagar/vim-zoom)                                               |                                                        |
| [norcalli/nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua)                                 |                                                        |
| [iamcco/markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)                               |                                                        |
| [bronson/vim-trailing-whitespace](https://github.com/bronson/vim-trailing-whitespace)                         |                                                        |
| [tweekmonster/startuptime.vim](https://github.com/tweekmonster/startuptime.vim)                               |                                                        |
| [tjdevries/astronauta.nvim](https://github.com/tjdevries/astronauta.nvim)                                     |                                                        |
| [willchao612/vim-diagon](https://github.com/willchao612/vim-diagon)                                           | Make diagrams from text                                |

</details>

### Core Mappings

In most mappings we are following this theme, unless there is an uncomfortable
situation or messes with a community-driven or Vim's very well known mapping:

| Part of mapping | Description                                                |
| :---            | :---                                                       |
| **q**           | **Q**uickfix list mappings                                 |
| **w**           | **L**ocal list mappings (because it's beside **q**)        |
| **d**           | LSP **D**iagnostics                                        |
| **g**           | **G**o to, Jump to, run something that goes to or jumps to |
| **m**           | **M**atch highlighting, **m**arks                          |
| **f**           | **F**ile, **F**ind                                         |
| **y**           | **Y**ank                                                   |
| **a**           | **A**ll, or disabling certain constraints                  |
| **]**           | Jumps to the next item                                     |
| **[**           | Jumps to the previous item                                 |

The `leader` key is `space`!

<details>
    <summary>Click to view the mappings</summary>

| Mapping       | Description                                                       |
| :---          | :---                                                              |
| `<leader>kk`  | (Also `<leader><leader>`)Toggles Neovim tree                      |
| `<leader>kf`  | **F**inds current file in the Neovim tree                         |
| `<Alt-j>`     | Shifts line(s) down one line and format                           |
| `<Alt-k>`     | Shifts line(s) up one line and format                             |
| `<Alt-,>`     | Adds `,` at the end of current line without moving                |
| `<S-Alt-,>`   | Removes `,` from the end of current line without moving           |
| `<Alt-.>`     | Adds `.` at the end of current line without moving                |
| `<S-Alt-,>`   | Removes `.` from the end of current line without moving           |
| `<Alt-;>`     | Adds `;` at the end of current line without moving                |
| `<S-Alt-,>`   | Removes `;` from the end of current line without moving           |
| `<Alt-{>`     | Adds curly brackets at the end of line into insert mode           |
| `]<space>`    | Inserts [count] empty lines after                                 |
| `[<space>`    | Inserts [count] empty lines before                                |
| `]=`          | Jump down along the indents                                       |
| `[=`          | Jump up along the indents                                         |
| `<leader>gw`  | **G**reps for current **W**ord in buffer. Populates the locallist |
| `<leader>sp`  | Toggles **Sp**elling on current buffer                            |
| `<leader>sf`  | Auto **f**ixes previous misspelled word                           |
| `z=`          | Show spell recommendations                                        |
| `g=`          | Re-indents the hole buffer                                        |
| `]c`          | (gitsigns) Next hunk                                              |
| `[c`          | (gitsigns) Previous hunk                                          |
| `<leader>hb`  | (gitsigns) **B**lame line                                         |
| `<leader>hs`  | (gitsigns) **S**tage **h**unk                                     |
| `<leader>hl`  | (gitsigns) **S**tage **l**ine                                     |
| `<leader>hu`  | (gitsigns) **U**nstage **h**unk                                   |
| `<leader>hr`  | (gitsigns) **R**eset **h**unk                                     |
| `<leader>hR`  | (gitsigns) **R**eset buffer                                       |
| `<leader>hp`  | (gitsigns) **P**review **h**unk                                   |
| `<leader>hh`  | Opens the **help** for current word                               |
| `<leader>cs`  | Search for **C**heat**S**heets with cht.sh service                |
| `<leader>cq`  | **C**heat**S**heets with quotes                                   |
| `<leader>cn`  | **C**heat**S**heet **N**ext example                               |
| `<Alt-Left>`  | Reduce vertical size                                              |
| `<Alt-Right>` | Increase vertical size                                            |
| `<Alt-Up>`    | Reduce horizontal size                                            |
| `<Alt-Down>`  | Increase horizontal size                                          |
| `<Esc><Esc>`  | Clear hlsearch                                                    |
| `<leader>1`   | Diff get from LOCAL (left)                                        |
| `<leader>2`   | Diff get from BASE (middle)                                       |
| `<leader>3`   | Diff get from REMOTE (right)                                      |

All operations with adding/removing `.`, `,`, `;` are **repeatable** and can be
operated on visually selected lines.

To use the **C**heat**S**heet functionality, type your query in the buffer and
invoke the key binding. The response will be inserted on the next lint in the
buffer and puts you in the `SELECT` mode. If you want the results just hit
`Esc` key. The `<leader>cn` will append the next available `\N` value and runs
the query again.

</details>

There are more specialised mappings provided, keep reading please!

### Text Objects

<details>
    <summary>Click to view the text objects</summary>

| Text Object | Description                                 |
| :---        | :---                                        |
| `H`         | To the beginning of line                    |
| `L`         | To the end of line                          |
| `ii`        | **I**n **I**ndentation                      |
| i`          | **I**n backtick (`) pairs (multi-line)      |
| a`          | **A**round backtick (`) pairs (multi-line)  |
| `an`        | **A**round **N**ext pairs (current lint)    |
| `in`        | **I**n **N**ext pairs (current line)        |
| `il`        | **I**n line                                 |
| `al`        | **A**round line                             |
| `iN`        | **I**n **N**umeric value (can be float too) |
| `ih`        | **I**n **H**unk                             |
| `af`        | **A**round **F**unction                     |
| `if`        | **I**n **F**unction                         |
| `am`        | **A**round call                             |
| `im`        | **I**n call                                 |
| `ab`        | **A**round **B**lock                        |
| `ib`        | **I**n **B**lock                            |
| `ah`        | **A**round **H**unk (git changes)           |
| `ih`        | **I**n **H**kunk (git changes)              |
| `au`        | **A**round **U**nit                         |
| `iu`        | **I**n **U**nit                             |
| `aa`        | **A**round **A**rgument                     |
| `ia`        | **I**n **A**rgument                         |

There are sets of **i*** and **a*** text objects, where `*` can be any of:
**_ . : , ; | / \ * + - #**

</details>

### Lists

There are a few tools for interacting with **quickfix** and **local** lists.
Following mappings can be used for either cases, all you need to do it to
substitute `w` for `q` or vice versa. Generally **q** is for **quickfix** list
and **w** is for **local list**. I chose **w** because it's beside **q** and it
makes it easy to think about these two types of lists.

`<leader>qq`, `<leader>ww`, `<leader>qn` and `<leader>wn` are repeatable with
**.**!

After adding an item to the list, an indicator in the **statusline** will show
you how many items you have in a list.

<details>
    <summary>Click to view mappings for lists</summary>

| Mapping      | Description                                                              |
| :---         | :---                                                                     |
| `<leader>cc` | Close both quickfix and local list windows                               |
| `<leader>qq` | Add current line and column to the **q**uickfix list.                    |
| `<leader>qn` | Add current line and column with your **n**ote to the **q**uickfix list. |
| `<leader>qo` | **O**pen the **q**uickfix list.                                          |
| `<leader>qc` | **C**lear the **q**uickfix list.                                         |
| `]q`         | Go to the next item in the **q**uickfix list and centre.                 |
| `[q`         | Go to the previous item in the **q**uickfix list and centre.             |
| `<leader>wq` | Add current line and column to the locallist.                            |
| `<leader>wn` | Add current line and column with your **n**ote to the locallist.         |
| `<leader>wo` | **O**pen the locallist.                                                  |
| `<leader>wc` | **C**lear the locallist.                                                 |
| `]w`         | Go to the next item in the locallist and centre.                         |
| `[w`         | Go to the previous item in the locallist and centre.                     |

</details>

<details>
    <summary>Click to view commands for lists</summary>

| Command         | Description                                 |
| :---            | :---                                        |
| `Clearquickfix` | **Clear** the quickfix list.                |
| `Clearloclist`  | **Clear** the local list of current buffer. |

</details>

Additional to [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) bindings,
you can do `<count>dd` in the quickfix/local list buffers to delete `<count>`
rows from quickfix/local list buffer.

### Highlight Matching

You can **highlight** words with random colours.

`<leader>ma` and `<leader>me` are repeatable with **.**!

<details>
    <summary>Click to view the mappings</summary>

Note that all these mappings are bound to the current window.

| Mapping      | Description                                              |
| :---         | :---                                                     |
| `<leader>ma` | **A**dd current word as a sub-pattern to the highlights. |
| `<leader>me` | Add an **e**xact match on current term.                  |
| `<leader>mp` | Add an match by asking for a **p**attern.                |
| `<leader>md` | **D**elete **M**atches with fzf search.                  |
| `<leader>mc` | **C**lear all matched patterns on current window.        |

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
| `<Alt-/>`          | Search in lines of **all open buffers**.               |
| `<leader>@`        | Search in **ctags** or **LSP** symbols (see below).    |
| `<leader>:`        | Commands                                               |
| `<leader>ff`       | **F**ind in contents of all files in current folder.   |
| `<leader>fa`       | **F**ind **A**ll disabling `.gitignore` handling.      |
| `<leader>rg`       | Search (**rg**) with current word.                     |
| `<leader>ra`       | Search (**rg**) disabling `.gitignore` handling.       |
| `<leader>fh`       | **F**ile **H**istory                                   |
| `<leader>fl`       | **F**ile **l**ocate (requires mlocate)                 |
| `<leader>gg`       | **GGrep**                                              |
| `<leader>gf`       | **GFiles**                                             |
| `<leader>mm`       | **Marks**                                              |
| `<Ctrl-x><Ctrl-k>` | Search in **dictionaries** (requires **words-insane**) |

| Yank Mappings   | Description                                       |
| :---            | :---                                              |
| `<leader>yh`    | List **Y**ank **H**istory)                        |
| `<leader>y`     | **Y**ank to the `+` register (external clipboard) |
| `<leader>p`     | **P**aste from the `+` register                   |
| `<leader>P`     | **P**aste from the `+` register (before/above)    |
| (v) `<leader>p` | **P**aste on selected text without changing "reg  |

If you keep hitting `<Ctrl-/>` the preview window will change width. With
`Shift-/` you can show and hide the preview window.

When you invoke `<leader>yh` you will be presented with a history of the
**yanked** items. Upon choosing one, the item will be set to the unnamed
register and you use **p** from there.

When a file is selected, additional to what **fzf** provides out of the box,
you can invoke one of these secondary actions:

| Mapping | Description                        |
| :---    | :---                               |
| `/`     | To search in the lines.            |
| `@`     | To search in ctags or lsp symbols. |
| `:`     | To go to a specific line.          |
| `alt-q` | Add items to the quickfix list.    |

Note that if a `LSP` server is not attached to the buffer, it will fall back to
`ctags`.

Sometimes when you list files and `sink` with **@**, the `LSP` might not be
ready yet, therefore it falls back to `ctags` immediately. In this case you can
cancel, which will land you to the file, and you can invoke `<leader>@` for
**LSP** symbols.

</details>

There are a few added commands to what fzf provides.

<details>
    <summary>Click to view the commands</summary>

| Command     | Description                                |
| :---        | :---                                       |
| Reload      | Reload one or more lua config files        |
| ArgAdd      | Select and add files to the args list      |
| ArgDelete   | Select and delete files from the args list |
| GGrep       | Run **git grep**                           |
| Marks       | Show marks with preview                    |
| MarksDelete | Delete marks                               |
| Todo        | List **todo**/**fixme** lines              |

</details>

### LSP

When a **LSP** server is attached to a buffer, a series of mappings will be
defined for that buffer based on the server's capabilities. When possible,
**fzf** will take over the results of the **LSP** mappings results.

Please note that I have remapped `<Ctrl-n>` and `<Ctrl-p>` with `<Ctrl-j>` and
`<Ctrl-k>` in completion menu in order to move up and down.

<details>
    <summary>Click to view the mappings</summary>

| Mapping       | Description                                                |
| :---          | :---                                                       |
| `gd`          | **G**o to **D**efinition                                   |
| `gD`          | **G**o to **D**eclaration                                  |
| `<leader>df`  | Show function **d**e**f**inition in popup                  |
| `<leader>gi`  | **G**o to **I**mplementation                               |
| `gr`          | Show **R**eferences                                        |
| `<leader>@`   | Document Symbols                                           |
| `<leader>gc`  | Show **C**allers (incoming calls)                          |
| `H`           | **H**over popup                                            |
| `<Ctrl-h>`    | (insert mode) Show **H**over popup                         |
| `K`           | Show **S**ignature help                                    |
| `<Ctrl-l>`    | (insert mode) Show **S**ignature help                      |
| `<Tab>`       | (insert mode) Next completion item                         |
| `<Shift-Tab>` | (insert mode) Previous completion item                     |
| `<Ctrl-j>`    | (insert mode) Next completion item                         |
| `<Ctrl-k>`    | (insert mode) Previous completion item                     |
| `<Alt-n>`     | (insert mode) Next completion source                       |
| `<Alt-p>`     | (insert mode) Previous completion source                   |
| `<leader>dd`  | Show line **D**iagnostics                                  |
| `<leader>dq`  | Fill the **Q**uicklist with **D**iagnostics                |
| `<leader>dw`  | Fill the local list with **D**iagnostics                   |
| `]d`          | Go to next **d**iagnostic issue                            |
| `[d`          | Go to previous **d**iagnostic issue                        |
| `<leader>i`   | Organise **i**mports                                       |
| `<leader>gq`  | Format the buffer with LSP                                 |
| `<leader>dr`  | **R**estart the LSP server (see below)                     |
| `<leader>ca`  | **C**ode **A**ctions (also in visual mode)                 |
| `<leader>cr`  | **C**ode lens **R**un                                      |
| `]f`          | Jumps to the start of next **f**unction                    |
| `[f`          | Jumps to the start of previous **f**unction                |
| `]b`          | Jumps to the start of next **b**lock                       |
| `[b`          | Jumps to the start of previous **b**lock                   |
| `<leader>.a`  | Swap parameter to right                                    |
| `<leader>,a`  | Swap parameter to left                                     |
| `<leader>.f`  | Swap **f**unction to next                                  |
| `<leader>,f`  | Swap **f**unction to previous                              |
| `<Alt-n>`     | Initiate **n**ode selection                                |
| `<CR>`        | After selection is initiated, increment selection          |
| `<BS>`        | After selection is initiated, decrease selection           |
| `<Alt-n>`     | After selection is initiated, increment selection on scope |

### Notes

* The `<leader>@` binding will use the `LSP` symbols if is attached to the
buffer, or `ctags` otherwise.
* Invoke `<leader>df` twice to enter the flowing window. `q` exits.

Please see the code for all available mappings.

</details>

**LSP** defines its own set of commands, however I have added a few interesting
additions.

<details>
    <summary>Click to view the commands</summary>

| Command            | Description                                   |
| :---               | :---                                          |
| `RestartLsp`       | Restart LSP with a delay.                     |
| `Rename`           | Rename a symbol                               |
| `CodeAction`       | Also works on a visually selected text.       |
| `WorkspaceSymbols` |                                               |
| `DocumentSymbol`   |                                               |
| `Callees`          |                                               |
| `Callers`          |                                               |
| `CodeLensRefresh`  |                                               |
| `CodeLensRun`      |                                               |
| `Diagnostics`      |                                               |
| `DiagnosticsAll`   |                                               |
| `Definition`       |                                               |
| `TypeDefinition`   |                                               |
| `Implementation`   |                                               |
| `References`       |                                               |
| `ListWorkspace`    |                                               |
| `Test`             | Find a test with the name of current function |
| `Log`              | Show LSP logs                                 |

</details>

The `RestartLsp` fixes an issue when the `LspRestart` does not have any
effects.

### Commands

The following list of commands do not fit into any specific categories.

<details>
    <summary>Click to view the commands</summary>

| Command               | Description                                  |
| :---                  | :---                                         |
| `InstallDependencies` | Install required dependencies                |
| `WatchLuaFileChanges` | Watch for changes in current file and reload |
| `CC`                  | Close all floating windows                   |
| `Scratch`             | Create a scratch buffer                      |
| `Filename`            | View the filename                            |
| `YankFilename`        | Yank the filename to `"` register            |
| `YankFilenameC`       | Yank the filename to `+` register            |
| `YankFilepath`        | Yank the file path to `"` register           |
| `YankFilepathC`       | Yank the file path to `+` register           |
| `MergeConflict`       | Search for merge conflicts                   |
| `JsonDiff`            | Diff json files after formatting them        |

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
    {"BufReadPost", buffer=true, run=":LspStop"},
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
util.cmd_and_centre("SomeCommand")
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

Unpacks and prints tables. This function is injected into the global scope.

```lua
dump({name = "Arsham"})
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
│   │   ├── cmp.lua
│   │   ├── fzf
│   │   │   └── init.lua
│   │   ├── gitsigns.lua
│   │   ├── lsp
│   │   │   └── init.lua
│   │   ├── treesitter.lua
│   │   └── wilder.lua               # For fuzzy Ex commands.
│   ├── statusline
│   │   ├── feline                   # Feline config.
│   │   └── galaxyline               # Galaxyline config.
│   ├── util
│   │   └── init.lua                 # Common utilities.
│   └── visuals.lua
└── spell
```
</details>
