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

| Function  | Plugin                                    | Description                          |
| :-------- | :---------------------------------------- | :----------------------------------- |
| 🔥 Core   | [folke/lazy.nvim][folke/lazy.nvim]        | Package manager                      |
| 🔥 Visual | [arsham/arshamiser.nvim][arshamiser.nvim] | Status line, colour scheme and folds |
| 🔥 Lists  | [arsham/listish.nvim][listish.nvim]       | Supporting quickfix and local lists  |
| 🧰 Lib    | [arsham/arshlib.nvim][arshlib.nvim]       | Library used in various plugins      |

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

| Plugin                                    | License                                                              |
| ----------------------------------------- | -------------------------------------------------------------------- |
| [folke/lazy.nvim][folke/lazy.nvim]        | [Apache-2.0](https://github.com/folke/lazy.nvim/blob/main/LICENSE)   |
| [arsham/arshamiser.nvim][arshamiser.nvim] | [MIT](https://github.com/arsham/arshamiser.nvim/blob/master/LICENSE) |
| [arsham/arshlib.nvim][arshlib.nvim]       | [MIT](https://github.com/arsham/arshlib.nvim/blob/master/LICENSE)    |
| [arsham/listish.nvim][listish.nvim]       | [MIT](https://github.com/arsham/listish.nvim/blob/master/LICENSE)    |

</details>

[folke/lazy.nvim]: https://github.com/folke/lazy.nvim
[arshamiser.nvim]: https://github.com/arsham/arshamiser.nvim
[arshlib.nvim]: https://github.com/arsham/arshlib.nvim
[listish.nvim]: https://github.com/arsham/listish.nvim

<!--
vim: foldlevel=2 conceallevel=0
-->
