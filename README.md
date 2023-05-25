# NeoVim setup, fast as a shark

The goal of this project is to have a fast Neovim startup, provide mappings
that can be easily memorised, interact with the **Lua** API, and make
programming fun.

This project supports Neovim version `0.10.0` and newer.

1. [Setup](#setup)
2. [Functionality](#functionality)
   - [Plugins](#plugins)
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

</details>

## Plugin License List

<details>
    <summary>Click to view the plugin list</summary>

| Plugin                                    | License                                                              |
| ----------------------------------------- | -------------------------------------------------------------------- |
| [folke/lazy.nvim][folke/lazy.nvim]        | [Apache-2.0](https://github.com/folke/lazy.nvim/blob/main/LICENSE)   |
| [arsham/arshamiser.nvim][arshamiser.nvim] | [MIT](https://github.com/arsham/arshamiser.nvim/blob/master/LICENSE) |

</details>

[folke/lazy.nvim]: https://github.com/folke/lazy.nvim
[arshamiser.nvim]: https://github.com/arsham/arshamiser.nvim

<!--
vim: foldlevel=2 conceallevel=0
-->
