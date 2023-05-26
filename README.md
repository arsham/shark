# NeoVim setup, fast as a shark

The goal of this project is to have a fast Neovim startup, provide mappings
that can be easily memorised, interact with the **Lua** API, and make
programming fun.

This project supports Neovim version `0.10.0` and newer.

## Highlights

- Besides in a few places that Neovim doesn't provide an API in Lua, most
  configuration is done in **Lua**.
- You can add the current location of the cursor or make **notes** on the
  current location in the **quickfix/local** lists with repeatable mappings.
- You can **manipulate** quickfix/local lists.

1. [Setup](#setup)
2. [Functionality](#functionality)
   - [Plugins](#plugins)
   - [Core Mappings](#core-mappings)
   - [Lists](#lists)
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

### Plugins

This list might change at any time depending on if there is a better
replacement or the requirement changes.

<details>
    <summary>Click to view the plugin list</summary>

Some plugins are not listed here. You can find the complete list in the
[plugins](./lua/plugins/) folder.

Licenses for plugins can be found [here](#plugin-license-list).

| Function  | Plugin                                           | Description                          |
| :-------- | :----------------------------------------------- | :----------------------------------- |
| 🔥 Core   | [folke/lazy.nvim][folke/lazy.nvim]               | Package manager                      |
| 🔥 Visual | [arsham/arshamiser.nvim][arshamiser.nvim]        | Status line, colour scheme and folds |
| 🔥 Lists  | [arsham/listish.nvim][listish.nvim]              | Supporting quickfix and local lists  |
| 🧰 Lib    | [arsham/arshlib.nvim][arshlib.nvim]              | Library used in various plugins      |
| ⚡ Visual | [nvim-tree/nvim-web-devicons][nvim-web-devicons] |                                      |
| 🔍 Finder | [junegunn/fzf][fzf]                              | Fuzzy finder                         |
| 🔍 Finder | [junegunn/fzf.vim][fzf.vim]                      | fzf plugin for vim                   |
| 🔥 Finder | [arsham/fzfmania.nvim][fzfmania.nvim]            | Very powerful FZF setup in lua       |
| 🔥 Finder | [ibhagwan/fzf-lua][fzf-lua]                      | fzf :heart: lua - fzf frontend       |
| 🧰 Core   | [nvim-lua/plenary.nvim][plenary.nvim]            |                                      |
| ⏩ Core   | [tweekmonster/startuptime.vim][startuptime]      | Benchmarking startup                 |
| 🔁 Core   | [tpope/vim-repeat][tpope/vim-repeat]             |                                      |

</details>

### Core Mappings

In most mappings we are following this theme, unless there is an uncomfortable
situation or messes with a community-driven or Vim's very well known mapping:

| Part of mapping | Description                                       |
| :-------------- | :------------------------------------------------ |
| **q**           | **Q**uickfix list mappings                        |
| **w**           | **L**ocal list mappings (because it's near **q**) |
| **]**           | Jumps to the next item                            |
| **[**           | Jumps to the previous item                        |
| **b**           | **B**uffer                                        |
| **f**           | **F**ile, **F**ind                                |

The `leader` key is `space`!

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

<!--
vim: foldlevel=2 conceallevel=0
-->
