# NeoVim setup, fast as a shark

The goal of this project is to have a fast Neovim startup, provide mappings
that can be easily memorised, interact with the **Lua** API, and make
programming fun.

This project supports Neovim version `0.10.0` and newer.

## Highlights

- Besides in a few places that Neovim doesn't provide an API in Lua, most
  configuration is done in **Lua**.
- There are some handy **textobjects** such as **backticks** and **indents**.
- You can add the current location of the cursor or make **notes** on the
  current location in the **quickfix/local** lists with repeatable mappings.
- You can **manipulate** quickfix/local lists.
- Statusline is configures with **feline**.

1. [Setup](#setup)
2. [Functionality](#functionality)
   - [Plugins](#plugins)
   - [Core Mappings](#core-mappings)
   - [Text Objects](#text-objects)
   - [Lists](#lists)
   - [Highlight Matching](#highlight-matching)
   - [FZF](#fzf)
   - [Utilities](#utilities)
3. [Plugin Licence List](#plugin-license-list)

![folds](https://user-images.githubusercontent.com/428611/148667078-25211d3c-116a-4c6f-938a-bb52b8bb1163.png)

## Setup

Just clone this project:

```bash
$ git clone https://github.com/arsham/shark.git ~/.config/nvim
```

Once you start `Neovim`, it will install the package manager and installs the
listed plugins.

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
[plugins](./lua/plugins/) folder.

Licenses for plugins can be found [here](#plugin-license-list).

| Function   | Plugin                                           | Description                           |
| :--------- | :----------------------------------------------- | :------------------------------------ |
| 🔥 Core    | [folke/lazy.nvim][folke/lazy.nvim]               | Package manager                       |
| 🔥 Visual  | [arsham/arshamiser.nvim][arshamiser.nvim]        | Status line, colour scheme and folds  |
| 🔥 Lists   | [arsham/listish.nvim][listish.nvim]              | Supporting quickfix and local lists   |
| 🧰 Lib     | [arsham/arshlib.nvim][arshlib.nvim]              | Library used in various plugins       |
| ⚡ Visual  | [nvim-tree/nvim-web-devicons][nvim-web-devicons] |                                       |
| 🔍 Finder  | [junegunn/fzf][fzf]                              | Fuzzy finder                          |
| 🔍 Finder  | [junegunn/fzf.vim][fzf.vim]                      | fzf plugin for vim                    |
| 🔥 Finder  | [arsham/fzfmania.nvim][fzfmania.nvim]            | Very powerful FZF setup in lua        |
| 🔥 Finder  | [ibhagwan/fzf-lua][fzf-lua]                      | fzf :heart: lua - fzf frontend        |
| 🧰 Core    | [nvim-lua/plenary.nvim][plenary.nvim]            |                                       |
| ⏩ Core    | [tweekmonster/startuptime.vim][startuptime]      | Benchmarking startup                  |
| 🔁 Core    | [tpope/vim-repeat][tpope/vim-repeat]             |                                       |
| 🥇 Textobj | [arsham/archer.nvim][arsham/archer.nvim]         | Mappings and text objects for archers |
| 🧰 Visuals | [MunifTanjim/nui.nvim][muniftanjim/nui.nvim]     | UI component                          |
| 🥇 Textobj | [arsham/indent-tools.nvim][indent-tools.nvim]    | Indent mappings and text object       |
| 🔥 Visuals | [arsham/matchmaker.nvim][matchmaker.nvim]        | Creates highlight for user matches    |
| 🛢️ Tool    | [stevearc/oil.nvim][oil.nvim]                    | File explorer                         |
|  GIT      | [tpope/vim-fugitive][tpope/vim-fugitive]         | git integration                       |
|  GIT      | [tpope/vim-rhubarb][tpope/vim-rhubarb]           | Go to selection's code Github page    |
|  Core     | [tpope/vim-git][tpope/vim-git]                   |                                       |
| 🌲 Visuals | [nvim-treesitter][nvim-treesitter]               | Highlighting engine                   |
| 🔥 GIT     | [lewis6991/gitsigns.nvim][gitsigns.nvim]         | git signs in the gutter               |
| 🥇 Textobj | [nvim-treesitter-textobjects][ts-textobjects]    | Treesitter Text Objects               |
| 🔥 Visuals | [freddiehaddad/feline.nvim][feline.nvim]         | Statusline (default)                  |
| 🗨️ Visuals | [rcarriga/nvim-notify][nvim-notify]              | Better notification UI                |
| 🌈 Visuals | [treesitter-refactor][treesitter-refactor]       | Treesitter plugin                     |
| 🗒️ Visuals | [nvim-treesitter/playground][playground]         | Treesitter plugin                     |
| 󰐣 Editing  | [context-commentstring][ctx-commentstring]       |                                       |

</details>

### Core Mappings

In most mappings we are following this theme, unless there is an uncomfortable
situation or messes with a community-driven or Vim's very well known mapping:

| Part of mapping | Description                                       |
| :-------------- | :------------------------------------------------ |
| **q**           | **Q**uickfix list mappings                        |
| **w**           | **L**ocal list mappings (because it's near **q**) |
| **w**           | **W**indow                                        |
| **]**           | Jumps to the next item                            |
| **[**           | Jumps to the previous item                        |
| **b**           | **B**uffer                                        |
| **f**           | **F**ile, **F**ind                                |
| **a**           | **A**ll, or disabling certain constraints         |
| **a**           | **A**rgument (parameter)                          |
| **i**           | **I**ndent                                        |
| **m**           | **M**atch highlighting                            |
| **d**           | **D**iff                                          |
| **h**           | **H**unk                                          |
| **c**           | **C**hange                                        |
| **s**           | **S**tatement, **S**cope                          |
| **o**           | L**o**op                                          |
| **e**           | **E**lement                                       |
| **y**           | **Y**ank                                          |
| **t**           | **T**ab                                           |
| **z**           | Folds, language/spelling                          |

The `leader` key is `space`!

<details>
    <summary>Click to view mappings</summary>

| Mapping           | Description                                                          |
| :---------------- | :------------------------------------------------------------------- |
| `<Alt-,>`         | Adds `,` at the end of current line without moving (repeatable)      |
| `<S-Alt-,>`       | Removes `,` from the end of current line without moving (repeatable) |
| `<Alt-.>`         | Adds `.` at the end of current line without moving (repeatable)      |
| `<S-Alt-.>`       | Removes `.` from the end of current line without moving (repeatable) |
| `<Alt-;>`         | Adds `;` at the end of current line without moving (repeatable)      |
| `<S-Alt-;>`       | Removes `;` from the end of current line without moving (repeatable) |
| `<Alt-{>`         | Adds curly brackets at the end of line into insert mode (repeatable) |
| [count]`]<space>` | Inserts [count] empty lines after (repeatable)                       |
| [count]`[<space>` | Inserts [count] empty lines before (repeatable)                      |
| `]i`              | Jump down along the **i**ndents                                      |
| `[i`              | Jump up along the **i**ndents                                        |
| `<leader>oo`      | **O**pen the **O**il buffer.                                         |
| `<leader>gg`      | Fu**g**itive git buffer                                              |
| `<leader>gd`      | Fu**g**itive git **D**iff                                            |
| `]c`              | Jump to the next **c**hange                                          |
| `[c`              | Jump to the previous **c**hange                                      |
| `<leader>gs`      | (gitsigns) Toggle **S**igns                                          |
| `<leader>hb`      | (gitsigns) **B**lame line                                            |
| `<leader>hs`      | (gitsigns) **S**tage **h**unk                                        |
| `<leader>hl`      | (gitsigns) **S**tage **l**ine                                        |
| `<leader>hu`      | (gitsigns) **U**nstage **h**unk                                      |
| `<leader>hr`      | (gitsigns) **R**eset **h**unk                                        |
| `<leader>hR`      | (gitsigns) **R**eset buffer                                          |
| `<leader>hp`      | (gitsigns) **P**review **h**unk                                      |
| `]f`              | Go to start of the next function                                     |
| `[f`              | Go to start of the previous function                                 |
| `]F`              | Go to end of the next function                                       |
| `[F`              | Go to end of the previous function                                   |
| `]b`              | Go to start of the next block                                        |
| `[b`              | Go to start of the previous block                                    |
| `]B`              | Go to end of the next block                                          |
| `[B`              | Go to end of the previous block                                      |
| `]gc`             | Go to start of the next comment                                      |
| `[gc`             | Go to start of the previous comment                                  |
| `]a`              | Go to start of the next parameter                                    |
| `[a`              | Go to start of the previous parameter                                |
| `]A`              | Go to end of the next parameter                                      |
| `[A`              | Go to end of the previous parameter                                  |
| `]o`              | Go to the next loop                                                  |
| `[o`              | Go to the previous loop                                              |
| `]s`              | Go to the next scope                                                 |
| `[s`              | Go to the previous scope                                             |
| `<leader>.f`      | Swap around with the next function                                   |
| `<leader>,f`      | Swap around with the previous function                               |
| `<leader>.e`      | Swap with the next element                                           |
| `<leader>,e`      | Swap with the previous element                                       |
| `<leader>.a`      | Swap with the next parameter                                         |
| `<leader>,a`      | Swap with the previous parameter                                     |
| `<leader>df`      | Peek function definition                                             |
| [count]`<Alt-j>`  | Shifts line(s) down and format                                       |
| [count]`<Alt-k>`  | Shifts line(s) up and format                                         |
| `g=`              | Re-indents the hole buffer                                           |
| `<Left>`          | Reduce vertical size                                                 |
| `<Right>`         | Increase vertical size                                               |
| `<Up>`            | Reduce horizontal size                                               |
| `<Down>`          | Increase horizontal size                                             |
| `<Esc><Esc>`      | Clear hlsearch                                                       |
| `<leader>gw`      | **G**rep current **W**ord in buffer. Populates the locallist.        |
| `<leader>sp`      | Toggle **Sp**elling for buffer                                       |
| `<leader>sf`      | Auto **f**ixe previous misspelled word                               |
| `<leader>hh`      | Opens the **help** for current word                                  |
| `<C-w>b`          | Delete current buffer                                                |
| `<C-w><C-b>`      | Delete current buffer                                                |
| `<C-w>t`          | Open current buffer in new tab                                       |
| `<C-w><C-t>`      | Open current buffer in new tab                                       |
| `cn`              | Initiate a `cgn` on current `word`                                   |
| [V]`cn`           | Initiate a `cgn` on current visually                                 |
|                   | selected string                                                      |
| `g.`              | Use last change (anything) as the                                    |
|                   | initiate a `cgn` on current `word`                                   |
| `<leader>zm`      | Set folding method to **M**anual                                     |
| `<leader>ze`      | Set folding method to **E**xpression                                 |
| `<leader>zi`      | Set folding method to **I**ndent                                     |
| `<leader>zk`      | Set folding method to Mar**k**er                                     |
| `<leader>zs`      | Set folding method to **S**yntax                                     |
| [c]`<Alt-a>`      | Go to begging of the line                                            |
| [c]`<Alt-e>`      | Go to end of the line                                                |
| [c]`<C-r><C-l>`   | Copy current line in the buffer                                      |
| `<Tab><Tab>`      | Switch to the alternative buffer                                     |

</details>

There are more specialised mappings provided, keep reading please!

### Text Objects

<details>
    <summary>Click to view the text objects</summary>

| Text Object | Description                                 |
| :---------- | :------------------------------------------ |
| `` i` ``    | **I**n backtick pairs (multi-line)          |
| `` a` ``    | **A**round backtick pairs (multi-line)      |
| `an`        | **A**round **N**ext pairs (current lint)    |
| `in`        | **I**n **N**ext pairs (current line)        |
| `iN`        | **I**n **N**umeric value (can be float too) |
| `aN`        | **A**round **N**umeric value                |
| `az`        | **A**round folds                            |
| `iz`        | **I**n folds                                |
| `ai`        | **A**round **I**ndentation block            |
| `ii`        | **I**n **I**ndentation block                |
| `ah`        | **A**round **H**unk                         |
| `ih`        | **I**n **H**unk                             |
| `af`        | Select around a function                    |
| `if`        | Select inside a function                    |
| `am`        | Select around a method                      |
| `im`        | Select inside a method                      |
| `ab`        | Select around a block                       |
| `ib`        | Select inside a block                       |
| `aa`        | Select around a parameter                   |
| `ia`        | Select inside a parameter                   |
| `as`        | Select around a statement                   |
| `H`         | To the beginning of line                    |
| `L`         | To the end of line                          |

There are sets of **i\*** and **a\*** text objects, where `*` can be any of:
**\_ . : , ; | / \ \* + - #**

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
| :----------- | :----------------------------------------------------------------------- |
| `<leader>cc` | Close both quickfix and local list windows                               |
| `<leader>qq` | Add current line and column to the **q**uickfix list.                    |
| `<leader>qn` | Add current line and column with your **n**ote to the **q**uickfix list. |
| `<leader>qo` | **O**pen the **q**uickfix list.                                          |
| `<leader>qd` | **D**rop the **q**uickfix list.                                          |
| `<leader>qc` | **C**lose the **q**uickfix list.                                         |
| `]q`         | Go to the next item in the **q**uickfix list and centre.                 |
| `[q`         | Go to the previous item in the **q**uickfix list and centre.             |
| `<leader>wq` | Add current line and column to the locallist.                            |
| `<leader>wn` | Add current line and column with your **n**ote to the locallist.         |
| `<leader>wo` | **O**pen the locallist.                                                  |
| `<leader>wd` | **D**rop the locallist.                                                  |
| `<leader>wc` | **C**lose the locallist.                                                 |
| `]w`         | Go to the next item in the locallist and centre.                         |
| `[w`         | Go to the previous item in the locallist and centre.                     |

</details>

<details>
    <summary>Click to view commands for lists</summary>

| Command         | Description                                 |
| :-------------- | :------------------------------------------ |
| `Clearquickfix` | **Clear** the quickfix list.                |
| `Clearloclist`  | **Clear** the local list of current buffer. |

</details>

### Highlight Matching

You can **highlight** words with random colours.

`<leader>ma` and `<leader>me` are repeatable with **.**!

<details>
    <summary>Click to view the mappings</summary>

Note that all these mappings are bound to the current window.

| Mapping      | Description                                              |
| :----------- | :------------------------------------------------------- |
| `<leader>ma` | **A**dd current word as a sub-pattern to the highlights. |
| `<leader>me` | Add an **e**xact match on current term.                  |
| `<leader>mp` | Add an match by asking for a **p**attern.                |
| `<leader>ml` | Add current **l**ine                                     |
| `<leader>md` | **D**elete **M**atches with fzf search.                  |
| `<leader>mc` | **C**lear all **m**atched patterns on current window.    |

</details>

### Fzf

<details>
    <summary>Click to view the mappings</summary>

Most actions can apply to multiple selected items if possible.

| Mapping            | Description                                            |
| :----------------- | :----------------------------------------------------- |
| `<Ctrl-p>`         | File list in current folder.                           |
| `<Alt-p>`          | File list in home folder.                              |
| `<Ctrl-b>`         | **B**uffer list.                                       |
| `<Alt-b>`          | Delete **b**uffers from the buffer list.               |
| `<Ctrl-/>`         | Search in lines on current buffer.                     |
| `<Alt-/>`          | Search in lines of **all open buffers**.               |
| `<leader>@`        | Search in **ctags** or **LSP** symbols (see below).    |
| `<leader>:`        | Commands                                               |
| `<leader>ff`       | **F**ind in contents of all files in current folder.   |
| `<leader>fF`       | Like `<leader>ff`, but you can filter filenames too    |
| `<leader>fa`       | **F**ind **A**ll disabling `.gitignore` handling.      |
| `<leader>fA`       | Like `<leader>fA`, but you can filter filenames too    |
| `<leader>fi`       | **I**ncrementally **F**ind.                            |
| `<leader>rg`       | Search (**rg**) with current word.                     |
| `<leader>fG`       | Like `<leader>fG`, but you can filter filenames too    |
| `<leader>ra`       | Search (**rg**) disabling `.gitignore` handling.       |
| `<leader>rA`       | Like `<leader>rA`, but you can filter filenames too    |
| `<leader>ri`       | **I**ncrementally search (**rg**) with current word.   |
| `<leader>fh`       | **F**ile **H**istory                                   |
| `<leader>fl`       | **F**ile **l**ocate (requires mlocate)                 |
| `<leader>gf`       | **GFiles**                                             |
| `<leader>mm`       | **Marks**                                              |
| `<Ctrl-x><Ctrl-k>` | Search in **dictionaries** (requires **words-insane**) |
| `<Ctrl-x><Ctrl-f>` | Search in **f**iles                                    |
| `<Ctrl-x><Ctrl-l>` | Search in **l**ines                                    |

If you keep hitting `<Ctrl-/>` the preview window will change width. With
`Shift-/` you can show and hide the preview window.

When a file is selected, additional to what **fzf** provides out of the box,
you can invoke one of these secondary actions:

| Mapping | Description                        |
| :------ | :--------------------------------- |
| `alt-/` | To search in the lines.            |
| `alt-@` | To search in ctags or lsp symbols. |
| `alt-:` | To go to a specific line.          |
| `alt-q` | Add items to the quickfix list.    |
| `alt-w` | Add items to the local list.       |

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

| Command       | Description                                |
| :------------ | :----------------------------------------- |
| `GGrep`       | Run **git grep**                           |
| `GTree`       | Browse **git** commits                     |
| `Marks`       | Show **marks** with preview                |
| `MarksDelete` | Delete **marks**                           |
| `Todo`        | List **todo**/**fixme** lines              |
| `ArgsAdd`     | Select and add files to the args list      |
| `ArgsDelete`  | Select and delete files from the args list |
| `Worktree`    | Switch between git worktrees               |
| `BLines`      | Search in current buffer                   |
| `History`     | Show open file history                     |
| `Checkout`    | Checkout a branch                          |
| `GitStatus`   | Show git status                            |
| `Jumps`       | Choose from jump list                      |
| `Autocmds`    | Show autocmds                              |
| `Changes`     | Show change list                           |
| `Registers`   | Show register contents                     |

</details>

| Yank Mappings | Description                                       |
| :------------ | :------------------------------------------------ |
| `<leader>y`   | **Y**ank to the `+` register (external clipboard) |
| `<leader>p`   | **P**aste from the `+` register                   |
| `<leader>P`   | **P**aste from the `+` register (before/above)    |
| (v) `p`       | **P**aste on selected text without changing "reg  |

### Utilities

These are commands you can use in **Lua** land. Assign the required module to a
variable and re-use.

```lua
local quick = require("arshlib.quick")
```

#### Normal

Executes a normal command. For example:

```lua
quick.normal("n", "y2k")
```

See `:h feedkeys()` for values of the mode.

#### Highlight

Create `highlight` groups:

```lua
quick.highlight("LspReferenceRead", { ctermbg = 180, guibg = "#43464F", style = "bold" })
```

#### Call and Centre

These functions will call your function/command and then centres the buffer:

```lua
quick.call_and_centre(function()
  print("Yolo!")
end)
quick.cmd_and_centre("SomeCommand")
```

## Plugin License List

<details>
    <summary>Click to view the plugin list</summary>

| Plugin                                      | License                                                                    |
| ------------------------------------------- | -------------------------------------------------------------------------- |
| [folke/lazy.nvim][folke/lazy.nvim]          | [Apache-2.0](https://github.com/folke/lazy.nvim/blob/main/LICENSE)         |
| [arsham/arshamiser.nvim][arshamiser.nvim]   | [MIT](https://github.com/arsham/arshamiser.nvim/blob/master/LICENSE)       |
| [arsham/arshlib.nvim][arshlib.nvim]         | [MIT](https://github.com/arsham/arshlib.nvim/blob/master/LICENSE)          |
| [arsham/listish.nvim][listish.nvim]         | [MIT](https://github.com/arsham/listish.nvim/blob/master/LICENSE)          |
| [nvim-web-devicons][nvim-web-devicons]      | [MIT](https://github.com/nvim-tree/nvim-web-devicons/blob/master/LICENSE)  |
| [nvim-lua/plenary.nvim][plenary.nvim]       | [MIT](https://github.com/nvim-lua/plenary.nvim/blob/master/LICENSE)        |
| [junegunn/fzf][fzf]                         | [MIT](https://github.com/junegunn/fzf/blob/master/LICENSE)                 |
| [junegunn/fzf.vim][fzf.vim]                 | [MIT](https://github.com/junegunn/fzf.vim/blob/master/LICENSE)             |
| [arsham/fzfmania.nvim][fzfmania.nvim]       | [MIT](https://github.com/arsham/fzfmania.nvim/blob/master/LICENSE)         |
| [ibhagwan/fzf-lua][fzf-lua]                 | [AGPL-3.0](https://github.com/ibhagwan/fzf-lua/blob/main/LICENSE)          |
| [tweekmonster/startuptime.vim][startuptime] | [MIT](https://github.com/tweekmonster/startuptime.vim/blob/master/LICENSE) |
| [tpope/vim-repeat][tpope/vim-repeat]        | [N/A][tpope/vim-repeat]                                                    |
| [arsham/archer.nvim][arsham/archer.nvim]    | [MIT](https://github.com/arsham/archer.nvim/blob/master/LICENSE)           |
| [nui.nvim][muniftanjim/nui.nvim]            | [MIT](https://github.com/MunifTanjim/nui.nvim/blob/main/LICENSE)           |
| [indent-tools.nvim][indent-tools.nvim]      | [MIT](https://github.com/arsham/indent-tools.nvim/blob/master/LICENSE)     |
| [matchmaker.nvim][matchmaker.nvim]          | [MIT](https://github.com/arsham/matchmaker.nvim/blob/master/LICENSE)       |
| [stevearc/oil.nvim][oil.nvim]               | [MIT](https://github.com/stevearc/oil.nvim/blob/master/LICENSE)            |
| [stevearc/oil.nvim][oil.nvim]               | [MIT](https://github.com/stevearc/oil.nvim/blob/master/LICENSE)            |
| [tpope/vim-fugitive][tpope/vim-fugitive]    | [N/A][tpope/vim-fugitive]                                                  |
| [tpope/vim-rhubarb][tpope/vim-rhubarb]      | [MIT](https://github.com/tpope/vim-rhubarb/blob/master/LICENSE)            |
| [tpope/vim-git][tpope/vim-git]              | [N/A][tpope/vim-git]                                                       |
| [nvim-treesitter][nvim-treesitter]          | [Apache-2.0][nvim-treesitter-license]                                      |
| [lewis6991/gitsigns.nvim][gitsigns.nvim]    | [MIT](https://github.com/lewis6991/gitsigns.nvim/blob/main/LICENSE)        |
| [treesitter-textobjects][ts-textobjects]    | [Apache-2.0][treesitter-textobjects-license]                               |
| [freddiehaddad/feline.nvim][feline.nvim]    | [GPL-3.0][feline.nvim-license]                                             |
| [rcarriga/nvim-notify][nvim-notify]         | [MIT](https://github.com/rcarriga/nvim-notify/blob/master/LICENSE)         |
| [treesitter-refactor][treesitter-refactor]  | [Apache-2.0][treesitter-refactor-license]                                  |
| [nvim-treesitter/playground][playground]    | [Apache-2.0][treesitter-playground-license]                                |
| [context-commentstring][ctx-commentstring]  | [MIT][ctx-commentstring-license]                                           |

</details>

[folke/lazy.nvim]: https://github.com/folke/lazy.nvim
[arshamiser.nvim]: https://github.com/arsham/arshamiser.nvim
[arshlib.nvim]: https://github.com/arsham/arshlib.nvim
[listish.nvim]: https://github.com/arsham/listish.nvim
[nvim-web-devicons]: https://github.com/nvim-tree/nvim-web-devicons
[plenary.nvim]: https://github.com/nvim-lua/plenary.nvim
[fzf]: https://github.com/junegunn/fzf
[fzf.vim]: https://github.com/junegunn/fzf.vim
[fzfmania.nvim]: https://github.com/arsham/fzfmania.nvim
[fzf-lua]: https://github.com/ibhagwan/fzf-lua
[startuptime]: https://github.com/tweekmonster/startuptime.vim
[tpope/vim-repeat]: https://github.com/tpope/vim-repeat
[arsham/archer.nvim]: https://github.com/arsham/archer.nvim
[muniftanjim/nui.nvim]: https://github.com/MunifTanjim/nui.nvim
[indent-tools.nvim]: https://github.com/arsham/indent-tools.nvim
[matchmaker.nvim]: https://github.com/arsham/matchmaker.nvim
[oil.nvim]: https://github.com/stevearc/oil.nvim
[tpope/vim-fugitive]: https://github.com/tpope/vim-fugitive
[tpope/vim-rhubarb]: https://github.com/tpope/vim-rhubarb
[tpope/vim-git]: https://github.com/tpope/vim-git
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[nvim-treesitter-license]: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/LICENSE
[gitsigns.nvim]: https://github.com/lewis6991/gitsigns.nvim
[ts-textobjects]: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
[treesitter-textobjects-license]: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/LICENSE
[feline.nvim]: https://github.com/freddiehaddad/feline.nvim
[feline.nvim-license]: https://github.com/freddiehaddad/feline.nvim/blob/master/LICENSE.md
[nvim-notify]: https://github.com/rcarriga/nvim-notify
[treesitter-refactor]: https://github.com/nvim-treesitter/nvim-treesitter-refactor
[treesitter-refactor-license]: https://github.com/nvim-treesitter/nvim-treesitter-refactor/blob/master/LICENSE
[playground]: https://github.com/nvim-treesitter/playground
[treesitter-playground-license]: https://github.com/nvim-treesitter/playground/blob/master/LICENSE
[ctx-commentstring]: https://github.com/JoosepAlviste/nvim-ts-context-commentstring
[ctx-commentstring-license]: https://github.com/JoosepAlviste/nvim-ts-context-commentstring/blob/main/LICENSE

<!--
vim: foldlevel=2 conceallevel=0
-->
