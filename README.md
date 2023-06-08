# NeoVim setup, fast as a shark

The goal of this project is to have a fast Neovim startup, provide mappings
that can be easily memorised, interact with the **Lua** API, and make
programming fun.

This setup is mostly customised to for **Go** (**Golang**) and **Rust**
development. There is also a few other **LSP** servers setup for other LSP
servers to work with various file types.

This project supports Neovim version `0.10.0` and newer.

## Highlights

- Besides in a few places that Neovim doesn't provide an API in Lua, most
  configuration is done in **Lua**.
- **LSP**, **Treesitter**, and **FZF** are setup to work together.
- Seamless navigation with **tmux**.
- Completion with **nvim-cmp** plugin is setup.
- It is optimised to handle very **large** files.
- There are some handy **textobjects** such as **backticks** and **indents**.
- You can add the current location of the cursor or make **notes** on the
  current location in the **quickfix/local** lists with repeatable mappings.
- You can **manipulate** quickfix/local lists.
- It comes with integration with **git** and gist.
- Has a lot of useful feedback in the gutter.
- Statusline is configures with **feline**.
- It is set to give a lot of useful information about the buffer.
- Prettier quickfix buffer and quickfix tools.
- The theme is setup with Lua to take advantage of its performance.

1. [Setup](#setup)
2. [Functionality](#functionality)
   - [Plugins](#plugins)
   - [Core Mappings](#core-mappings)
   - [Text Objects](#text-objects)
   - [Lists](#lists)
   - [Highlight Matching](#highlight-matching)
   - [FZF](#fzf)
   - [LSP](#lsp)
   - [Snippets](#snippets)
   - [Utilities](#utilities)
3. [Plugin Licence List](#plugin-license-list)

![folds](https://user-images.githubusercontent.com/428611/148667078-25211d3c-116a-4c6f-938a-bb52b8bb1163.png)

<details>
    <summary>Click to view another image</summary>

![go](https://user-images.githubusercontent.com/428611/148667079-f441fc97-4157-4ed3-b2bb-81a64d358107.png)

</details>

<details>
    <summary>Click to view advance snippets demo</summary>

See [snippets](#snippets) section for more information.

![queryrows](https://user-images.githubusercontent.com/428611/154764948-b620896d-3303-42db-ad09-dcde94a18764.gif)

![ife](https://user-images.githubusercontent.com/428611/154764941-6398c245-01f8-4c5e-b226-302d10dc1fef.gif)

</details>

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
| 🥊 Core    | [andymass/vim-matchup][vim-matchup]              |                                       |
| 󰘜 Editing  | [monaqa/dial.nvim][monaqa/dial.nvim]             | Enhanced increment/decrement values   |
| 👗 Visuals | [stevearc/dressing.nvim][dressing.nvim]          |                                       |
|  GIT      | [mattn/vim-gist][mattn/vim-gist]                 | gist integration                      |
| 󰛡 Core     | [RaafatTurki/hex.nvim][hex.nvim]                 | Hex viewer                            |
|  Tool     | [iamcco/markdown-preview.nvim][mk-preview]       |                                       |
| 🧭 Core    | [numToStr/Navigator.nvim][navigator.nvim]        | Seamless navigation with tmux         |
| 📁 Tool    | [nvim-neo-tree/neo-tree.nvim][neo-tree]          | File explorer tree                    |
| 🪟 Core    | [s1n7ax/nvim-window-picker][window-picker]       | Window picker                         |
|  Tool     | [ralismark/opsort.vim][opsort.vim]               | Sort operator                         |
|  Tool     | [sQVe/sort.nvim][sqve/sort.nvim]                 | Line-wise and delimiter sorting       |
| 🔭 Tool    | [dhruvasagar/vim-zoom][vim-zoom]                 | Zoom windows                          |
| 🥇 Textobj | [David-Kunz/treesitter-unit][ts-unit]            | Treesitter units                      |
|  LSP      | [neovim/nvim-lspconfig][nvim-lspconfig]          | LSP configuration                     |
|  LSP      | [mason.nvim][mason.nvim]                         | Package manager for LSP, DAP, etc.    |
|  LSP      | [mason-lspconfig.nvim][mason-lspconfig]          | LSP config bridge for mason.nvim      |
|  LSP      | [hrsh7th/nvim-cmp][hrsh7th/nvim-cmp]             | Completion with LSP                   |
|  LSP      | [saadparwaiz1/cmp_luasnip][cmp_luasnip]          | Extension for nvim-cmp                |
|  LSP      | [L3MON4D3/LuaSnip][l3mon4d3/luasnip]             | Snippet engine                        |
|  LSP      | [hrsh7th/cmp-cmdline][hrsh7th/cmp-cmdline]       | Extension for nvim-cmp                |
|  LSP      | [friendly-snippets][friendly-snippets]           |                                       |
|  LSP      | [hrsh7th/cmp-buffer][cmp-buffer]                 | Extension for nvim-cmp                |
|  LSP      | [hrsh7th/cmp-calc][cmp-calc]                     | Extension for nvim-cmp                |
|  LSP      | [hrsh7th/cmp-nvim-lsp][cmp-nvim-lsp]             | Extension for nvim-cmp                |
|  LSP      | [hrsh7th/lsp-signature-help][sig-help]           | Extension for nvim-cmp                |
|  LSP      | [hrsh7th/cmp-nvim-lua][cmp-nvim-lua]             | Extension for nvim-cmp                |
|  LSP      | [hrsh7th/cmp-path][cmp-path]                     | Extension for nvim-cmp                |
|  LSP      | [lukas-reineke/cmp-rg][cmp-rg]                   | Extension for nvim-cmp                |
| 💡 LSP     | [j-hui/fidget.nvim][j-hui/fidget.nvim]           | Spinner for LSP status                |
| 📢 LSP     | [null-ls.nvim][null-ls.nvim]                     | External Tool to LSP bridge           |
| 📢 LSP     | [mason-null-ls.nvim][mason-null-ls.nvim]         | Null LS and Mason bridge              |
| 📢 LSP     | [mason-tool-installer][mason-tool-inst]          | LSP server installer                  |
| 🗒️ Editing | [numToStr/Comment.nvim][comment.nvim]            | Comment string                        |
| 🗒️ LSP     | [smjonas/inc-rename.nvim][inc-rename.nvim]       | Incremental renaming                  |
| 🗒️ Editing | [windwp/nvim-autopairs][nvim-autopairs]          |                                       |
|  Editing  | [arthurxavierx/vim-caser][vim-caser]             | Case conversion                       |
| 🖌️ Visuals | [NvChad/nvim-colorizer.lua][nvim-colorizer]      | Colourise matched colours in buffer   |
| 🦀 Tools   | [saecki/crates.nvim][saecki/crates.nvim]         | Crate.toml helper                     |
| 💡 LSP     | [kosayoda/nvim-lightbulb][nvim-lightbulb]        | Code actions buln                     |
|  Editing  | [gbprod/substitute.nvim][substitute.nvim]        | Text exchange operator                |
| 💡 LSP     | [lsp_lines.nvim][lsp_lines.nvim]                 | Show LSP diagnostics in extmarks      |
| 👈 Core    | [milisims/nvim-luaref][nvim-luaref]              |                                       |
| 🗒️ Editing | [echasnovski/mini.nvim][mini.nvim]               | For surround, alignments, etc.        |
|  Core     | [folke/neodev.nvim][folke/neodev.nvim]           |                                       |
| 📆 Tool    | [nvim-neorg/neorg][nvim-neorg/neorg]             | Note taking tool                      |
|  Lists    | [kevinhwang91/nvim-bqf][nvim-bqf]                | Better quickfix list manager          |
|  Tool     | [bfredl/nvim-luadev][bfredl/nvim-luadev]         | REPL/debug console for lua plugins    |
| 💡 LSP     | [SmiteshP/nvim-navic][nvim-navic]                | Current code context with LSP         |
|  Tool     | [kiran94/s3edit.nvim][s3edit.nvim]               | Edit files on S3 bucket               |
| 🔍 Tool    | [woosaaahh/sj.nvim][woosaaahh/sj.nvim]           | Search and quickly jump               |
|  Editing  | [mbbill/undotree][mbbill/undotree]               | Undo tree browser                     |
|  GIT      | [rbong/vim-flog][rbong/vim-flog]                 | git log graph                         |
| 🎡 Visual  | [towolf/vim-helm][towolf/vim-helm]               | Helm syntax highlighting              |
|  Core     | [tmux-plugins/vim-tmux][vim-tmux]                |                                       |
|  Editing  | [mg979/vim-visual-multi][vim-visual-multi]       | Multiple cursors                      |
| 🔫 Core    | [svban/YankAssassin.vim][yankassassin.vim]       | Stay where you are after yanking      |
|  Editing  | [zbirenbaum/copilot.lua][copilot.lua]            | Copilot                               |
|  Editing  | [Exafunction/codeium.vim][codeium.vim]           | Codeium (opensource copilot)          |
| 💡 LSP     | [utilyre/barbecue.nvim][barbecue.nvim]           | Complementary to navic                |
|  LSP      | [uga-rosa/cmp-dynamic][cmp-dynamic]              | Extension for nvim-cmp                |
|  Tool     | [stevearc/overseer.nvim][overseer.nvim]          | Task runner                           |
| 🌈 Tool    | [ziontee113/color-picker.nvim][colorpicker]      | Colour picker and updater             |
|  Editing  | [aduros/ai.vim][aduros/ai.vim]                   | OpenAI plugin                         |
|  Tool     | [tamton-aquib/duck.nvim][duck.nvim]              | Fun little ducks                      |
| 🕸️ Tool    | [rest-nvim/rest.nvim][rest.nvim]                 | Fast http client in lua               |
| 🔍 Tool    | [arsham/yanker.nvim][yanker.nvim]                | Yank history helper                   |
| 🗒️ Editing | [jbyuki/venn.nvim][jbyuki/venn.nvim]             | Draw ASCII diagrams                   |

Note that if copilot is enabled, codeium will be disabled.

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
| **d**           | **D**iff, **D**iagnostics                         |
| **h**           | **H**unk                                          |
| **c**           | **C**hange, **C**opilot, **C**odium               |
| **s**           | **S**tatement, **S**cope                          |
| **o**           | L**o**op                                          |
| **e**           | **E**lement                                       |
| **y**           | **Y**ank                                          |
| **t**           | **T**ab                                           |
| **z**           | Folds, language/spelling                          |
| **g**           | **G**o/Jump to, run something that goes/jumps to  |
| **n**           | **N**eorg related                                 |
| **r**           | **R**est                                          |

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
| `gso`             | Sort objects                                                         |
| `gsoo`            | Sort lines                                                           |
| [s][i]`<Ctrl-l>`  | Next snippet choice                                                  |
| [s][i]`<Ctrl-h>`  | Previous snippet choice                                              |
| [n,v]`gc`         | Comment operator                                                     |
| `<leader>nr`      | **R**eturn from **N**eorg buffer                                     |
| `<leader>nm`      | **M**odify code block with **N**eorg looking-glass                   |
| `<leader>nh`      | **N**eorg workspace **H**me                                          |
| `<leader>nw`      | **N**eorg **W**orkspace                                              |
| `<leader>nj`      | **N**eorg **J**ournal                                                |
| [Neorg]`]]`       | **N**eorg buffer next heading                                        |
| [Neorg]`[[`       | **N**eorg buffer previous heading                                    |
| `<leader>us`      | Unlink all open snippet sessions                                     |
| `<leader>ce`      | **E**nable **Copilot**                                               |
| `<leader>cd`      | **D**isable **Copilot**                                              |
| `<leader>cp`      | **Copilot** **P**anel                                                |
| `]]`              | (copilot panel) Jump to the next suggestion                          |
| `[[`              | (copilot panel) Jump to the previous suggestion                      |
| `<CR>`            | (copilot panel) Accept suggestion                                    |
| `gr`              | (copilot panel) Refresh                                              |
| `<Alt-CR>`        | (copilot panel) Open                                                 |
| `<Alt-]>`         | (copilot suggestion) Next suggestion                                 |
| `<Alt-[>`         | (copilot suggestion) Previous suggestion                             |
| `<C-y><C-y>`      | (copilot suggestion) Accept whole suggestion                         |
| `<C-y><C-w>`      | (copilot suggestion) Accept a word of suggestion                     |
| `<C-y><C-l>`      | (copilot suggestion) Accept a line of suggestion                     |
| `<Ctrl-]>`        | (copilot suggestion) Dismiss                                         |
| `<Leader>ce`      | **E**nable **C**odeium                                               |
| `<Leader>cd`      | **D**isable **C**odeium                                              |
| `<Leader>or`      | Run overseer task                                                    |
| `<Leader>ot`      | Toggle overseer tasks panel                                          |
| `<Leader>fl`      | **L**ocate **F**iles (neess mlocate)                                 |
| `<Leader>rr`      | **R**un **R**est **R**equest under cursor                            |
| `<Leader>rp`      | **P**review **R**est **R**equest under cursor in cURL command        |
| `<Leader>R`       | **R**review the last **R**est **R**equest                            |
| `<Leader>v`       | Enable/Disable **V**enn                                              |

Note that if copilot is enabled, codeium will be disabled.

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
| `au`        | Select around a unit                        |
| `iu`        | Select inside a unit                        |
| `il`        | **I**n line                                 |
| `al`        | **A**round line                             |

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
| `<leader>kk`       | Toggles file tree                                      |
| `<leader>kf`       | **F**inds current file in the file tree                |

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
| `<leader>yh`  | List **Y**ank **H**istory)                        |
| `<leader>y`   | **Y**ank to the `+` register (external clipboard) |
| `<leader>p`   | **P**aste from the `+` register                   |
| `<leader>P`   | **P**aste from the `+` register (before/above)    |
| (v) `p`       | **P**aste on selected text without changing "reg  |

### LSP

When a **LSP** server is attached to a buffer, a series of mappings will be
defined for that buffer based on the server's capabilities. When possible,
**fzf** will take over the results of the **LSP** mappings results.

<details>
    <summary>Click to view the mappings</summary>

| Mapping      | Description                                 |
| :----------- | :------------------------------------------ |
| `<leader>dd` | Show line **D**iagnostics                   |
| `<leader>dq` | Fill the **Q**uicklist with **D**iagnostics |
| `<leader>dw` | Fill the local list with **D**iagnostics    |
| `]d`         | Go to next **d**iagnostic issue **(R)**     |
| `[d`         | Go to previous **d**iagnostic issue **(R)** |
| `H`          | **H**over popup                             |
| [i]`<Alt-h>` | **H**over popup                             |
| `gd`         | **G**o to **D**efinition                    |
| `K`          | Show **S**ignature help                     |
| [i]`<M-l>`   | Show **S**ignature help                     |
| [i]`<Alt-l>` | Show **S**ignature help                     |
| `<leader>gq` | Format the buffer with LSP                  |
| [x]`gq`      | Format the selection with LSP               |
| `gq`         | Format operator with LSP                    |
| `<leader>i`  | Organise imports                            |
| `<leader>rn` | Incrementally rename symbol                 |
| `gr`         | Go to references                            |
| `<leader>gi` | **G**o to **I**mplementation                |
| `gD`         | **G**o to **D**eclaration                   |
| `<leader>cr` | **C**ode lens **R**un                       |
| `<leader>ca` | **C**ode **A**ctions (also in visual mode)  |
| `<leader>gc` | **Go** to **C**aller                        |
| `<leader>dr` | **R**estart the LSP server (see below)      |

### Notes

- Mappings marked with `(R)` are repeatable with `;` and `,`.
Please see the code for all available mappings.

</details>

#### CMP

| Mapping         | Description                                |
| :-------------- | :----------------------------------------- |
| [i]`<C-j>`      | Select next item                           |
| [i]`<C-k>`      | Select previous item                       |
| [i]`<C-b>`      | Scroll documents up                        |
| [i]`<C-f>`      | Scroll documents down                      |
| [i]`<C-Space>`  | Initiate completion menu (main one)        |
| [i]`<C-s>`      | Initiate completion menu (buffer, rg)      |
| [i]`<C-x><C-o>` | Initiate completion menu (lsp, buffer, rg) |
| [i]`<C-x><C-r>` | Initiate completion menu (rg)              |
| [i]`<C-x><C-s>` | Initiate completion menu (luasnip)         |
| [i]`<C-x><C-g>` | Initiate completion menu (git)             |
| [i,c]`<C-e>`    | Abort completion and close                 |
| [i,s]`<Tab>`    | Next placeholder                           |
| [i,s]`<S-Tab>`  | Previous placeholder                       |

**LSP** defines its own set of commands, however I have added a few interesting
additions.

<details>
    <summary>Click to view the commands</summary>

| Command              | Description                             |
| :------------------- | :-------------------------------------- |
| `Diagnostics`        | Alternative `Diag`                      |
| `DiagnosticsAll`     | Alternative `DiagAll`                   |
| `DiagnosticsDisable` |                                         |
| `DiagnosticsEnable`  |                                         |
| `Definition`         | Go to the definition                    |
| `WorkspaceList`      |                                         |
| `WorkspaceRemove`    |                                         |
| `WorkspaceAdd`       |                                         |
| `WorkspaceSymbols`   |                                         |
| `DocumentSymbol`     |                                         |
| `References`         |                                         |
| `Implementation`     |                                         |
| `TypeDefinition`     |                                         |
| `CodeLensRefresh`    |                                         |
| `CodeLensRun`        |                                         |
| `CodeAction`         | Also works on a visually selected text. |
| `Callers`            | Show callers and go to one              |
| `Callees`            | Show callees and go to one              |
| `RestartLsp`         |                                         |
| `UnlinkSnippets`     | Unlink all open snippet sessions        |
| `ListWorkspace`      | List attached LSP workspace folders     |

</details>

The `RestartLsp` fixes an issue when the `LspRestart` does not have any
effects.

### Commands

The following list of commands do not fit into any specific categories.

<details>
    <summary>Click to view the commands</summary>

| Command                 | Description                            |
| :---------------------- | :------------------------------------- |
| `Filename`              | View the filename                      |
| `YankFilename`          | Yank the filename to `"` register      |
| `YankFilenameC`         | Yank the filename to `+` register      |
| `YankFilepath`          | Yank the file path to `"` register     |
| `YankFilepathC`         | Yank the file path to `+` register     |
| `Nowrap`                | Stop wrapping current buffer           |
| `ToggleRelativeNumbers` | Start/Stop relative number switching   |
| `ToggleTrimWhitespaces` | Toggles trimming whitespaces on buffer |
| `Scratch`               | Create a scratch buffer                |
| {range}`Duck` [args]    | Show some ducks                        |
|                         | Give an icon for something else        |
| {range}`Cook`           | Cook some ducks                        |
| `FoldComments`          | Fold comments (sets folding to expr)   |
| `EditConfig`            | Edit configuration files in a new tab  |
| `LspCaps`               | Show short LSP capabilities            |
| `LspCapsFull`           | Show sull LSP capabilities             |
| `GoModTidy`             | Run go mod tidy on go and mod files    |
| `Tmux`                  | Start a tmux project (using tmuxp)     |
| `LazyLoadAll`           | Load all lazy-loaded plugins           |
| `CC`                    | Close all floating windows             |

</details>

### Snippets

I never was a fan of snippets, until I discovered the
[LuaSnip](https://github.com/L3MON4D3/LuaSnip) plugin and it changed my mind.
Here is a demo of a couple of snippets shipped with this setup:

<details>
    <summary>Click to view advance snippets demo</summary>

Queryrows snippet creates a useful code in Go that uses the
[Retry](https://github.com/arsham/retry) library for querying postgres.

![queryrows](https://user-images.githubusercontent.com/428611/154764948-b620896d-3303-42db-ad09-dcde94a18764.gif)

Ife snippet is an improvement over a snippet by
[tjdevries](https://github.com/tjdevries/config_manager/blob/6e48802a9c6acc9f8f2c9768fcb57d6ce1f05e00/xdg_config/nvim/lua/tj/snips/ft/go.lua)
that tries to work better with return values.

![ife](https://user-images.githubusercontent.com/428611/154764941-6398c245-01f8-4c5e-b226-302d10dc1fef.gif)

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
| [andymass/vim-matchup][vim-matchup]         | [MIT](https://github.com/andymass/vim-matchup/blob/master/LICENSE.md)      |
| [monaqa/dial.nvim][monaqa/dial.nvim]        | [MIT](https://github.com/monaqa/dial.nvim/blob/master/LICENSE)             |
| [stevearc/dressing.nvim][dressing.nvim]     | [MIT](https://github.com/stevearc/dressing.nvim/blob/master/LICENSE)       |
| [mattn/vim-gist][mattn/vim-gist]            | [N/A][mattn/vim-gist]                                                      |
| [RaafatTurki/hex.nvim][hex.nvim]            | [MIT](https://github.com/RaafatTurki/hex.nvim/blob/master/LICENSE)         |
| [iamcco/markdown-preview.nvim][mk-preview]  | [MIT][mk-preview-license]                                                  |
| [numToStr/Navigator.nvim][navigator.nvim]   | [MIT](https://github.com/numToStr/Navigator.nvim/blob/master/LICENSE)      |
| [nvim-neo-tree/neo-tree.nvim][neo-tree]     | [MIT][neo-tree-license]                                                    |
| [s1n7ax/nvim-window-picker][window-picker]  | [MIT](https://github.com/s1n7ax/nvim-window-picker/blob/main/LICENSE)      |
| [ralismark/opsort.vim][opsort.vim]          | [MIT](https://github.com/ralismark/opsort.vim/blob/main/LICENSE)           |
| [sQVe/sort.nvim][sqve/sort.nvim]            | [MIT](https://github.com/sQVe/sort.nvim/blob/main/LICENSE)                 |
| [dhruvasagar/vim-zoom][vim-zoom]            | [N/A][vim-zoom]                                                            |
| [David-Kunz/treesitter-unit][ts-unit]       | [Unlicense][ts-unit-license]                                               |
| [neovim/nvim-lspconfig][nvim-lspconfig]     | [Apache-2.0][lspconfig-license]                                            |
| [mason.nvim][mason.nvim]                    | [Apache-2.0][mason.nvim-license]                                           |
| [mason-lspconfig.nvim][mason-lspconfig]     | [Apache-2.0][mason-lspconfig-license]                                      |
| [hrsh7th/nvim-cmp][hrsh7th/nvim-cmp]        | [MIT](https://github.com/hrsh7th/nvim-cmp/blob/main/LICENSE)               |
| [saadparwaiz1/cmp_luasnip][cmp_luasnip]     | [Apache-2.0][cmp_luasnip-license]                                          |
| [L3MON4D3/LuaSnip][l3mon4d3/luasnip]        | [Apache-2.0](https://github.com/L3MON4D3/LuaSnip/blob/master/LICENSE)      |
| [hrsh7th/cmp-cmdline][hrsh7th/cmp-cmdline]  | [N/A][hrsh7th/cmp-cmdline]                                                 |
| [friendly-snippets][friendly-snippets]      | [MIT][friendly-snippets-license]                                           |
| [hrsh7th/cmp-buffer][cmp-buffer]            | [MIT](https://github.com/hrsh7th/cmp-buffer/blob/main/LICENSE)             |
| [hrsh7th/cmp-calc][cmp-calc]                | [N/A][cmp-calc]                                                            |
| [hrsh7th/cmp-nvim-lsp][cmp-nvim-lsp]        | [MIT](https://github.com/hrsh7th/cmp-nvim-lsp/blob/main/LICENSE)           |
| [hrsh7th/lsp-signature-help][sig-help]      | [N/A][sig-help]                                                            |
| [hrsh7th/cmp-nvim-lua][cmp-nvim-lua]        | [N/A][cmp-nvim-lua]                                                        |
| [hrsh7th/cmp-path][cmp-path]                | [MIT](https://github.com/hrsh7th/cmp-path/blob/main/LICENSE)               |
| [lukas-reineke/cmp-rg][cmp-rg]              | [MIT](https://github.com/lukas-reineke/cmp-rg/blob/master/LICENSE.md)      |
| [j-hui/fidget.nvim][j-hui/fidget.nvim]      | [MIT](https://github.com/j-hui/fidget.nvim/blob/main/LICENSE)              |
| [null-ls.nvim][null-ls.nvim]                | [View][null-ls.nvim-license]                                               |
| [mason-null-ls.nvim][mason-null-ls.nvim]    | [AGPL-3.0][mason-null-ls.nvim-license]                                     |
| [mason-tool-installer][mason-tool-inst]     | [MIT][mason-tool-inst-license]                                             |
| [numToStr/Comment.nvim][comment.nvim]       | [MIT](https://github.com/numToStr/Comment.nvim/blob/master/LICENSE)        |
| [smjonas/inc-rename.nvim][inc-rename.nvim]  | [MIT](https://github.com/smjonas/inc-rename.nvim/blob/main/LICENSE)        |
| [windwp/nvim-autopairs][nvim-autopairs]     | [MIT](https://github.com/windwp/nvim-autopairs/blob/master/LICENSE)        |
| [arthurxavierx/vim-caser][vim-caser]        | [View](https://github.com/arthurxavierx/vim-caser/blob/master/LICENSE)     |
| [NvChad/nvim-colorizer.lua][nvim-colorizer] | [View][nvim-colorizer-license]                                             |
| [saecki/crates.nvim][saecki/crates.nvim]    | [MIT](https://github.com/Saecki/crates.nvim/blob/main/LICENSE)             |
| [kosayoda/nvim-lightbulb][nvim-lightbulb]   | [MIT](https://github.com/kosayoda/nvim-lightbulb/blob/master/LICENSE)      |
| [gbprod/substitute.nvim][substitute.nvim]   | [WTFPL](https://github.com/gbprod/substitute.nvim/blob/main/LICENCE)       |
| [lsp_lines.nvim][lsp_lines.nvim]            | [ISC][lsp_lines.nvim]                                                      |
| [milisims/nvim-luaref][nvim-luaref]         | [MIT](https://github.com/milisims/nvim-luaref/blob/main/LICENSE)           |
| [echasnovski/mini.nvim][mini.nvim]          | [MIT](https://github.com/echasnovski/mini.nvim/blob/main/LICENSE)          |
| [folke/neodev.nvim][folke/neodev.nvim]      | [Apache-2.0](https://github.com/folke/neodev.nvim/blob/main/LICENSE)       |
| [nvim-neorg/neorg][nvim-neorg/neorg]        | [GPL-3.0](https://github.com/nvim-neorg/neorg/blob/main/LICENSE)           |
| [kevinhwang91/nvim-bqf][nvim-bqf]           | [BSD-3-Clause][nvim-bqf-license]                                           |
| [bfredl/nvim-luadev][bfredl/nvim-luadev]    | [MIT](https://github.com/bfredl/nvim-luadev/blob/master/LICENSE)           |
| [SmiteshP/nvim-navic][nvim-navic]           | [Apache-2.0][nvim-navic-license]                                           |
| [kiran94/s3edit.nvim][s3edit.nvim]          | [MIT](https://github.com/kiran94/s3edit.nvim/blob/main/LICENSE)            |
| [woosaaahh/sj.nvim][woosaaahh/sj.nvim]      | [MIT](https://github.com/woosaaahh/sj.nvim/blob/main/LICENSE)              |
| [mbbill/undotree][mbbill/undotree]          | [N/A][mbbill/undotree]                                                     |
| [towolf/vim-helm][towolf/vim-helm]          | [View](https://github.com/towolf/vim-helm/blob/master/LICENSE)             |
| [tmux-plugins/vim-tmux][vim-tmux]           | [N/A][vim-tmux]                                                            |
| [mg979/vim-visual-multi][vim-visual-multi]  | [MIT](https://github.com/mg979/vim-visual-multi/blob/master/LICENSE)       |
| [svban/YankAssassin.vim][yankassassin.vim]  | [N/A][yankassassin.vim]                                                    |
| [zbirenbaum/copilot.lua][copilot.lua]       | [MIT](https://github.com/zbirenbaum/copilot.lua/blob/master/LICENSE)       |
| [Exafunction/codeium.vim][codeium.vim]      | [MIT](https://github.com/Exafunction/codeium.vim/blob/main/LICENSE)        |
| [utilyre/barbecue.nvim][barbecue.nvim]      | [MIT](https://github.com/utilyre/barbecue.nvim/blob/main/LICENSE)          |
| [uga-rosa/cmp-dynamic][cmp-dynamic]         | [MIT](https://github.com/uga-rosa/cmp-dynamic/blob/main/LICENSE)           |
| [stevearc/overseer.nvim][overseer.nvim]     | [MIT](https://github.com/stevearc/overseer.nvim/blob/master/LICENSE)       |
| [ziontee113/color-picker.nvim][colorpicker] | [MIT][colorpicker-license]                                                 |
| [aduros/ai.vim][aduros/ai.vim]              | [ISC](https://github.com/aduros/ai.vim/blob/main/LICENSE.txt)              |
| [tamton-aquib/duck.nvim][duck.nvim]         | [MIT](https://github.com/tamton-aquib/duck.nvim/blob/main/LICENSE)         |
| [nvim-rest/rest.nvim][rest.nvim]            | [MIT](https://github.com/rest-nvim/rest.nvim/blob/main/LICENSE)            |
| [arsham/yanker.nvim][yanker.nvim]           | [MIT](https://github.com/arsham/yanker.nvim/blob/master/LICENSE)           |
| [jbyuki/venn.nvim][jbyuki/venn.nvim]        | [MIT](https://github.com/jbyuki/venn.nvim/blob/master/LICENSE)             |

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
[vim-matchup]: https://github.com/andymass/vim-matchup
[monaqa/dial.nvim]: https://github.com/monaqa/dial.nvim
[dressing.nvim]: https://github.com/stevearc/dressing.nvim
[mattn/vim-gist]: https://github.com/mattn/vim-gist
[hex.nvim]: https://github.com/RaafatTurki/hex.nvim
[mk-preview]: https://github.com/iamcco/markdown-preview.nvim
[mk-preview-license]: https://github.com/iamcco/markdown-preview.nvim/blob/master/LICENSE
[navigator.nvim]: https://github.com/numToStr/Navigator.nvim
[neo-tree]: https://github.com/nvim-neo-tree/neo-tree.nvim
[neo-tree-license]: https://github.com/nvim-neo-tree/neo-tree.nvim/blob/v2.x/LICENSE
[window-picker]: https://github.com/s1n7ax/nvim-window-picker
[opsort.vim]: https://github.com/ralismark/opsort.vim
[sqve/sort.nvim]: https://github.com/sQVe/sort.nvim
[vim-zoom]: https://github.com/dhruvasagar/vim-zoom
[ts-unit]: https://github.com/David-Kunz/treesitter-unit
[ts-unit-license]: https://github.com/David-Kunz/treesitter-unit/blob/main/LICENSE
[nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[mason-lspconfig]: https://github.com/williamboman/mason-lspconfig.nvim
[mason-lspconfig-license]: https://github.com/williamboman/mason-lspconfig.nvim/blob/main/LICENSE
[mason.nvim]: https://github.com/williamboman/mason.nvim
[mason.nvim-license]: https://github.com/williamboman/mason.nvim/blob/main/LICENSE
[lspconfig-license]: https://github.com/neovim/nvim-lspconfig/blob/master/LICENSE.md
[hrsh7th/nvim-cmp]: https://github.com/hrsh7th/nvim-cmp
[cmp_luasnip]: https://github.com/saadparwaiz1/cmp_luasnip
[cmp_luasnip-license]: https://github.com/saadparwaiz1/cmp_luasnip/blob/master/LICENSE
[l3mon4d3/luasnip]: https://github.com/L3MON4D3/LuaSnip
[hrsh7th/cmp-cmdline]: https://github.com/hrsh7th/cmp-cmdline
[friendly-snippets]: https://github.com/rafamadriz/friendly-snippets
[friendly-snippets-license]: https://github.com/rafamadriz/friendly-snippets/blob/main/LICENSE
[cmp-buffer]: https://github.com/hrsh7th/cmp-buffer
[cmp-calc]: https://github.com/hrsh7th/cmp-calc
[cmp-nvim-lsp]: https://github.com/hrsh7th/cmp-nvim-lsp
[sig-help]: https://github.com/hrsh7th/cmp-nvim-lsp-signature-help
[cmp-nvim-lua]: https://github.com/hrsh7th/cmp-nvim-lua
[cmp-path]: https://github.com/hrsh7th/cmp-path
[cmp-rg]: https://github.com/lukas-reineke/cmp-rg
[j-hui/fidget.nvim]: https://github.com/j-hui/fidget.nvim
[null-ls.nvim]: https://github.com/jose-elias-alvarez/null-ls.nvim
[null-ls.nvim-license]: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/LICENSE
[mason-null-ls.nvim]: https://github.com/jay-babu/mason-null-ls.nvim
[mason-null-ls.nvim-license]: https://github.com/jay-babu/mason-null-ls.nvim/blob/main/LICENSE
[mason-tool-inst]: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
[mason-tool-inst-license]: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/blob/main/LICENSE
[comment.nvim]: https://github.com/numToStr/Comment.nvim
[inc-rename.nvim]: https://github.com/smjonas/inc-rename.nvim
[nvim-autopairs]: https://github.com/windwp/nvim-autopairs
[vim-caser]: https://github.com/arthurxavierx/vim-caser
[nvim-colorizer]: https://github.com/NvChad/nvim-colorizer.lua
[nvim-colorizer-license]: https://github.com/NvChad/nvim-colorizer.lua/blob/master/LICENSE
[saecki/crates.nvim]: https://github.com/saecki/crates.nvim
[nvim-lightbulb]: https://github.com/kosayoda/nvim-lightbulb
[substitute.nvim]: https://github.com/gbprod/substitute.nvim
[lsp_lines.nvim]: https://git.sr.ht/~whynothugo/lsp_lines.nvim
[nvim-luaref]: https://github.com/milisims/nvim-luaref
[mini.nvim]: https://github.com/echasnovski/mini.nvim
[folke/neodev.nvim]: https://github.com/folke/neodev.nvim
[nvim-neorg/neorg]: https://github.com/nvim-neorg/neorg
[nvim-bqf]: https://github.com/kevinhwang91/nvim-bqf
[nvim-bqf-license]: https://github.com/kevinhwang91/nvim-bqf/blob/main/LICENSE
[bfredl/nvim-luadev]: https://github.com/bfredl/nvim-luadev
[nvim-navic]: https://github.com/SmiteshP/nvim-navic
[nvim-navic-license]: https://github.com/SmiteshP/nvim-navic/blob/master/LICENSE.md
[s3edit.nvim]: https://github.com/kiran94/s3edit.nvim
[woosaaahh/sj.nvim]: https://github.com/woosaaahh/sj.nvim
[mbbill/undotree]: https://github.com/mbbill/undotree
[rbong/vim-flog]: https://github.com/rbong/vim-flog
[towolf/vim-helm]: https://github.com/towolf/vim-helm
[vim-tmux]: https://github.com/tmux-plugins/vim-tmux
[vim-visual-multi]: https://github.com/mg979/vim-visual-multi
[yankassassin.vim]: https://github.com/svban/YankAssassin.vim
[copilot.lua]: https://github.com/zbirenbaum/copilot.lua
[codeium.vim]: https://github.com/Exafunction/codeium.vim
[barbecue.nvim]: https://github.com/utilyre/barbecue.nvim
[cmp-dynamic]: https://github.com/uga-rosa/cmp-dynamic
[overseer.nvim]: https://github.com/stevearc/overseer.nvim
[colorpicker]: https://github.com/ziontee113/color-picker.nvim
[colorpicker-license]: https://github.com/ziontee113/color-picker.nvim/blob/master/LICENSE
[aduros/ai.vim]: https://github.com/aduros/ai.vim
[duck.nvim]: https://github.com/tamton-aquib/duck.nvim
[rest.nvim]: https://github.com/rest-nvim/rest.nvim
[yanker.nvim]: https://github.com/arsham/yanker.nvim
[jbyuki/venn.nvim]: https://github.com/jbyuki/venn.nvim

<!--
vim: foldlevel=2 conceallevel=0
-->
