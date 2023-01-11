# NeoVim setup, fast as a shark

The goal of this project is to have a fast Neovim startup, provide mappings
that can be easily memorised, interact with the **Lua** API, and make
programming fun.

This setup is mostly customised to for **Go** (**Golang**) and **Rust**
development. There is also a few other **LSP** servers setup for other LSP
servers to work with various file types.

This project supports Neovim version `0.8.0` and newer.

## Highlights

- Besides in a few places that Neovim doesn't provide an API in Lua, most
  configuration is done in **Lua**.
- It loads really fast! With over **100 plugins**, it takes **1ms** to
  **10ms** on average to load up. This has become possible With the new
  `filetype.lua` and heavily lazy-loaded plugins (benchmarked with the
  `StartupTime` benchmark tool). Hyperfine benchmarks shows a full
  startup/shutdow cycle of **70ms** on average.
- **LSP**, **Treesitter**, and **FZF** are setup to work together.
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
3. [Folder Structure](#folder-structure)
4. [Plugin Licence List](#plugin-license-list)

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

You need to run the `InstallDependencies` command to install some dependencies.
Run `TSUpdate` to satisfy treesitter dependencies, and finally run
`LspInstallInfo` and install the LSP servers you need. Some dependencies can't
be installed with this tool (yet), therefore you need to install them manually.
The command will let you know what you need to install in the notification.

You can check the health of your installation by running the `checkhealth`
command. To make sure health of all plugins are run invoke `:LazyLoadAll`
before `checkhealth`.

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

Licenses for plugins can be found [here](#plugin-license-list).

| Function    | Plugin                                            | Description                                          |
| :---------- | :------------------------------------------------ | :--------------------------------------------------- |
| Core        | [folke/lazy.nvim][folke/lazy.nvim]                | Package manager                                      |
| Core        | [arsham/arshlib.nvim][arsham/arshlib.nvim]        | Supporting library                                   |
| Core        | [numToStr/Navigator.nvim][navigator.nvim]         | Seamlessly navigate between tmux and vim             |
| Core        | [tpope/vim-repeat][tpope/vim-repeat]              |                                                      |
| Finder      | [junegunn/fzf][junegunn/fzf]                      | Fuzzy finder                                         |
| Finder      | [junegunn/fzf.vim][junegunn/fzf.vim]              | fzf plugin for vim                                   |
| Finder      | [arsham/fzfmania.nvim][arsham/fzfmania.nvim]      | Very powerful FZF setup in lua                       |
| Finder      | [ibhagwan/fzf-lua][ibhagwan/fzf-lua]              | fzf :heart: lua - fzf frontend                       |
| Visuals     | [arsham/arshamiser.nvim][arsham/arshamiser.nvim]  | Status line, colour scheme and folds                 |
| Lists       | [arsham/listish.nvim][arsham/listish.nvim]        | Supporting quickfix and local lists                  |
| Lists       | [kevinhwang91/nvim-bqf][kevinhwang91/nvim-bqf]    | Better quickfix list manager                         |
| Text Object | [arsham/archer.nvim][arsham/archer.nvim]          | Mappings and text objects for archers                |
| Text Object | [arsham/indent-tools.nvim][indent-tools.nvim]     | Indent mappings and text object                      |
| Visuals     | [arsham/matchmaker.nvim][arsham/matchmaker.nvim]  | Creates highlight for user matches                   |
| Tool        | [arsham/yanker.nvim][arsham/yanker.nvim]          | Yank history                                         |
| LSP         | [neovim/nvim-lspconfig][neovim/nvim-lspconfig]    | LSP configuration                                    |
| LSP         | [mason.nvim][mason.nvim]                          | Package manager for LSP, DAP, formatters and linters |
| LSP         | [mason-lspconfig.nvim][mason-lspconfig.nvim]      | LSP config bridge for mason.nvim                     |
| LSP         | [mason-tool-installer][mason-tool-installer]      | Install and upgrade mason servers                    |
| LSP         | [j-hui/fidget.nvim][j-hui/fidget.nvim]            | Spinner for LSP status                               |
| LSP         | [null-ls.nvim][null-ls.nvim]                      | External Tool to LSP bridge                          |
| LSP         | [hrsh7th/nvim-cmp][hrsh7th/nvim-cmp]              | Completion with LSP                                  |
| LSP         | [hrsh7th/cmp-buffer][hrsh7th/cmp-buffer]          | Extension for nvim-cmp                               |
| LSP         | [hrsh7th/cmp-calc][hrsh7th/cmp-calc]              | Extension for nvim-cmp                               |
| LSP         | [hrsh7th/cmp-cmdline][hrsh7th/cmp-cmdline]        | Extension for nvim-cmp                               |
| LSP         | [hrsh7th/cmp-nvim-lsp][hrsh7th/cmp-nvim-lsp]      | Extension for nvim-cmp                               |
| LSP         | [hrsh7th/lsp-signature-help][lsp-signature-help]  | Extension for nvim-cmp                               |
| LSP         | [hrsh7th/cmp-nvim-lua][hrsh7th/cmp-nvim-lua]      | Extension for nvim-cmp                               |
| LSP         | [hrsh7th/cmp-path][hrsh7th/cmp-path]              | Extension for nvim-cmp                               |
| LSP         | [lukas-reineke/cmp-rg][lukas-reineke/cmp-rg]      | Extension for nvim-cmp                               |
| LSP         | [saadparwaiz1/cmp_luasnip][cmp_luasnip]           | Extension for nvim-cmp                               |
| LSP         | [L3MON4D3/LuaSnip][l3mon4d3/luasnip]              | Snippet engine                                       |
| LSP         | [smjonas/inc-rename.nvim][inc-rename.nvim]        | Incremental renaming with inccommand support         |
| LSP         | [friendly-snippets][friendly-snippets]            |                                                      |
| LSP         | [ray-x/go.nvim][ray-x/go.nvim]                    | Modern Go Plugin for Neovim                          |
| LSP         | [nanotee/sqls.nvim][nanotee/sqls.nvim]            | SQL LSP                                              |
| Visuals     | [nvim-treesitter][nvim-treesitter]                | Highlighting engine                                  |
| Visuals     | [treesitter-refactor][nvim-treesitter-refactor]   | Treesitter plugin                                    |
| Text Object | [treesitter-textobjects][treesitter-textobjects]  | Treesitter Text Objects                              |
| Visuals     | [nvim-treesitter/playground][playground]          | Treesitter plugin                                    |
| Visuals     | [David-Kunz/treesitter-unit][treesitter-unit]     | Treesitter plugin                                    |
| Tool        | [nvim-neorg/neorg][nvim-neorg/neorg]              | Note taking tool                                     |
| LSP         | [mfussenegger/nvim-dap][mfussenegger/nvim-dap]    | Debug Adapter Protocol                               |
| LSP         | [rcarriga/nvim-dap-ui][rcarriga/nvim-dap-ui]      | A UI for nvim-dap                                    |
| LSP         | [nvim-dap-virtual-text][dap-virtual-text]         | DAP related                                          |
| LSP         | [leoluz/nvim-dap-go][leoluz/nvim-dap-go]          | DAP related                                          |
| Testing     | [nvim-neotest/neotest][nvim-neotest/neotest]      | Run tests                                            |
| Testing     | [nvim-neotest/neotest-go][neotest-go]             | Neotest Go driver                                    |
| Testing     | [rouge8/neotest-rust][rouge8/neotest-rust]        | Neotest Rust driver                                  |
| LSP         | [one-small-step-for-vimkind][vimkind]             | DAP related                                          |
| LSP         | [SmiteshP/nvim-navic][smiteshp/nvim-navic]        | Current code context with LSP                        |
| LSP         | [lsp_lines.nvim][lsp_lines.nvim]                  | Show LSP diagnostics in extmarks                     |
| Tools       | [saecki/crates.nvim][saecki/crates.nvim]          | Crate.toml helper                                    |
| Tool        | [nvim-neo-tree/neo-tree.nvim][neo-tree.nvim]      | File explorer tree                                   |
| Visuals     | [feline-nvim/feline.nvim][feline.nvim]            | Statusline (default)                                 |
| Tool        | [gelguy/wilder.nvim][gelguy/wilder.nvim]          | Fuzzy completion for command mode                    |
| Visuals     | [stevearc/dressing.nvim][stevearc/dressing.nvim]  |                                                      |
| GIT         | [tpope/vim-fugitive][tpope/vim-fugitive]          | git integration                                      |
| GIT         | [tpope/vim-rhubarb][tpope/vim-rhubarb]            | Go to code's Github page for selection               |
| GIT         | [mattn/vim-gist][mattn/vim-gist]                  | gist integration                                     |
| GIT/Visuals | [lewis6991/gitsigns.nvim][gitsigns.nvim]          | git signs in the gutter                              |
| GIT         | [ldelossa/gh.nvim][ldelossa/gh.nvim]              | Code review plugin                                   |
| GIT         | [ldelossa/litee.nvim][ldelossa/litee.nvim]        | Dependency for `gh.nvim`                             |
| Editing     | [numToStr/Comment.nvim][numtostr/comment.nvim]    |                                                      |
| Editing     | [ts-context-commentstring][context-commentstring] |                                                      |
| Editing     | [vim-scripts/visualrepeat][visualrepeat]          | Repeat in visual mode                                |
| Editing     | [arthurxavierx/vim-caser][vim-caser]              | Case conversion                                      |
| Editing     | [mg979/vim-visual-multi][mg979/vim-visual-multi]  | Multiple cursors                                     |
| Editing     | [gbprod/substitute.nvim][gbprod/substitute.nvim]  | Text exchange operator                               |
| Editing     | [windwp/nvim-autopairs][windwp/nvim-autopairs]    |                                                      |
| Visuals     | [rcarriga/nvim-notify][rcarriga/nvim-notify]      | Better notification UI                               |
| Visuals     | [MunifTanjim/nui.nvim][muniftanjim/nui.nvim]      | UI component                                         |
| Visuals     | [folke/noice.nvim][folke/noice.nvim]              | Replaces the UI for messages                         |
| Editing     | [mbbill/undotree][mbbill/undotree]                | Undo tree browser                                    |
| Visuals     | [towolf/vim-helm][towolf/vim-helm]                | Helm syntax highlighting                             |
| Editing     | [echasnovski/mini.nvim][echasnovski/mini.nvim]    | For surround, trailing spaces and alignments         |
| Text Object | [glts/vim-textobj-comment][vim-textobj-comment]   |                                                      |
| Text Object | [kana/vim-textobj-user][kana/vim-textobj-user]    |                                                      |
| Text Object | [woosaaahh/sj.nvim][woosaaahh/sj.nvim]            | Search and quickly jump                              |
| Visuals     | [nvim-tree/nvim-web-devicons][nvim-web-devicons]  |                                                      |
| Tool        | [dhruvasagar/vim-zoom][dhruvasagar/vim-zoom]      |                                                      |
| Visuals     | [NvChad/nvim-colorizer.lua][nvim-colorizer.lua]   | Colourise matched colours in buffer                  |
| Visuals     | [ziontee113/color-picker.nvim][color-picker]      | Slider for changing colours in buffer                |
| Visuals     | [chentoast/marks.nvim][chentoast/marks.nvim]      | Mark and Bookmark viewer                             |
| Tool        | [iamcco/markdown-preview.nvim][markdown-preview]  |                                                      |
| Tool        | [willchao612/vim-diagon][willchao612/vim-diagon]  | Make diagrams from text                              |
| Tool        | [jbyuki/venn.nvim][jbyuki/venn.nvim]              | Create diagrams easier                               |
| Editing     | [monaqa/dial.nvim][monaqa/dial.nvim]              | Enhanced increment/decrement values                  |
| Tool        | [bfredl/nvim-luadev][bfredl/nvim-luadev]          | REPL/debug console for nvim lua plugins              |
| Tool        | [sQVe/sort.nvim][sqve/sort.nvim]                  | Sort plugin with line-wise and delimiter sorting     |
| Tool        | [ralismark/opsort.vim][ralismark/opsort.vim]      | Sort operator                                        |
| Tool        | [kiran94/s3edit.nvim][kiran94/s3edit.nvim]        | Edit files on S3 bucket                              |
| Core        | [tweekmonster/startuptime.vim][startuptime.vim]   |                                                      |
| Core        | [svban/YankAssassin.vim][svban/yankassassin.vim]  | Stay where you are after yanking                     |
| Core        | [tmux-plugins/vim-tmux][tmux-plugins/vim-tmux]    |                                                      |
| Core        | [tpope/vim-git][tpope/vim-git]                    |                                                      |
| Core        | [andymass/vim-matchup][andymass/vim-matchup]      |                                                      |
| Core        | [folke/neodev.nvim][folke/neodev.nvim]            |                                                      |
| Core        | [mattn/webapi-vim][mattn/webapi-vim]              |                                                      |
| Core        | [milisims/nvim-luaref][milisims/nvim-luaref]      |                                                      |
| Core        | [nvim-lua/plenary.nvim][nvim-lua/plenary.nvim]    |                                                      |
| Core        | [samjwill/nvim-unception][nvim-unception]         | Neovim in Neovim = 1 Neovim                          |
| Core        | [s1n7ax/nvim-window-picker][nvim-window-picker]   | Window picker                                        |

</details>

### Core Mappings

In most mappings we are following this theme, unless there is an uncomfortable
situation or messes with a community-driven or Vim's very well known mapping:

| Part of mapping | Description                                                |
| :-------------- | :--------------------------------------------------------- |
| **b**           | **B**uffer                                                 |
| **q**           | **Q**uickfix list mappings                                 |
| **w**           | **L**ocal list mappings (because it's beside **q**)        |
| **d**           | LSP **D**iagnostics or **D**AP bindings                    |
| **g**           | **G**o to, Jump to, run something that goes to or jumps to |
| **m**           | **M**atch highlighting, **m**arks                          |
| **f**           | **F**ile, **F**ind                                         |
| **y**           | **Y**ank                                                   |
| **a**           | **A**ll, or disabling certain constraints                  |
| **]**           | Jumps to the next item                                     |
| **[**           | Jumps to the previous item                                 |
| **h**           | **H**unk                                                   |
| **z**           | Folds, language/spelling                                   |
| **i**           | **I**ndent                                                 |
| **t**           | **T**ab, **T**est, **T**erminal                            |
| **w**           | **W**indow                                                 |

The `leader` key is `space`!

<details>
    <summary>Click to view the mappings</summary>

| Mapping            | Description                                                          |
| :----------------- | :------------------------------------------------------------------- |
| `<Ctrl-Shift-p>`   | Show **C**ontrol panel (commands)                                    |
| `<Ctrl-w>b`        | Delete current **B**uffer                                            |
| `<Ctrl-w>y`        | **Y**ank current window for exchange (see next mapping)              |
| `<Ctrl-w>x`        | E**x**change current window with previously yanked window            |
| `<Ctrl-w><Ctrl-e>` | Run **e**dit silently on current window                              |
| `<leader>e`        | Run edit silently on all windows of the current tab                  |
| `<leader>kk`       | Toggles Neovim tree                                                  |
| `<leader><leader>` | Toggles Neovim tree                                                  |
| `<leader>kf`       | **F**inds current file in the Neovim tree                            |
| `<Alt-j>`          | Shifts line(s) down one line and format                              |
| [count]`<Alt-k>`   | Shifts line(s) up one line and format                                |
| `<Alt-,>`          | Adds `,` at the end of current line without moving (repeatable)      |
| `<S-Alt-,>`        | Removes `,` from the end of current line without moving (repeatable) |
| `<Alt-.>`          | Adds `.` at the end of current line without moving (repeatable)      |
| `<S-Alt-,>`        | Removes `.` from the end of current line without moving (repeatable) |
| `<Alt-;>`          | Adds `;` at the end of current line without moving (repeatable)      |
| `<S-Alt-,>`        | Removes `;` from the end of current line without moving (repeatable) |
| `<Alt-{>`          | Adds curly brackets at the end of line into insert mode (repeatable) |
| [count]`]<space>`  | Inserts [count] empty lines after (repeatable)                       |
| [count]`[<space>`  | Inserts [count] empty lines before (repeatable)                      |
| `]i`               | Jump down along the **i**ndents                                      |
| `[i`               | Jump up along the **i**ndents                                        |
| `[t`               | Move to previous **t**ab                                             |
| `]t`               | Move to next **t**ab                                                 |
| `<leader>gw`       | **G**reps for current **W**ord in buffer. Populates the locallist    |
| `<leader>sp`       | Toggles **Sp**elling on current buffer                               |
| `<leader>sf`       | Auto **f**ixes previous misspelled word                              |
| `cn`               | Initiate a `cgn` on current `word`                                   |
| [V]`cn`            | Initiate a `cgn` on current visually selected string                 |
| `g.`               | Use last change (anything) as the initiate a `cgn` on current `word` |
| `z=`               | Show spell recommendations                                           |
| `g=`               | Re-indents the hole buffer                                           |
| `]c`               | (gitsigns) Next hunk                                                 |
| `[c`               | (gitsigns) Previous hunk                                             |
| `<leader>ch`       | **C**ommand **H**eight toggle (between 0 and 1)                      |
| [V]`<leader>be`    | **B**ase64 **e**ncode visually selected text                         |
| [V]`<leader>bd`    | **B**ase64 **d**ecode visually selected text                         |
| `<leader>gg`       | Fu**g**itive git buffer                                              |
| `<leader>hb`       | (gitsigns) **B**lame line                                            |
| `<leader>hs`       | (gitsigns) **S**tage **h**unk                                        |
| `<leader>hl`       | (gitsigns) **S**tage **l**ine                                        |
| `<leader>hu`       | (gitsigns) **U**nstage **h**unk                                      |
| `<leader>hr`       | (gitsigns) **R**eset **h**unk                                        |
| `<leader>hR`       | (gitsigns) **R**eset buffer                                          |
| `<leader>hp`       | (gitsigns) **P**review **h**unk                                      |
| `<leader>hh`       | Opens the **help** for current word                                  |
| `<leader>sb`       | Toggle **s**croll **b**ind on current buffer                         |
| `<Alt-Left>`       | Reduce vertical size                                                 |
| `<Alt-Right>`      | Increase vertical size                                               |
| `<Alt-Up>`         | Reduce horizontal size                                               |
| `<Alt-Down>`       | Increase horizontal size                                             |
| `<Esc><Esc>`       | Clear hlsearch                                                       |
| `<leader>1`        | Diff get from LOCAL (left)                                           |
| `<leader>2`        | Diff get from BASE (middle)                                          |
| `<leader>3`        | Diff get from REMOTE (right)                                         |
| [V]`@<reg>`        | Execute a macro over range of selected lines                         |
| `<leader>zm`       | Set folding method to **M**anual                                     |
| `<leader>ze`       | Set folding method to **E**xpression                                 |
| `<leader>zi`       | Set folding method to **I**ndent                                     |
| `<leader>zm`       | Set folding method to Mar**k**er                                     |
| `<leader>zs`       | Set folding method to **S**yntax                                     |
| `<leader>db`       | Set **d**ebugger **b**reakpoint                                      |
| `<localleader>dB`  | **D**ebugger **b**reakpoint condition                                |
| `<localleader>dc`  | **D**ebugger **c**ontinue                                            |
| `<localleader>di`  | **D**ebugger step **i**nto                                           |
| `<localleader>do`  | **D**ebugger step **o**ver                                           |
| `<localleader>dO`  | **D**ebugger step **o**ut                                            |
| `<localleader>dT`  | **D**ebugger **t**ermination                                         |
| `<localleader>du`  | Toggle **d**ebugger **U**I                                           |
| `<localleader>dh`  | **D**ebugger **h**over                                               |
| `<localleader>tu`  | Run nearest **T**est **u**nit                                        |
| `<localleader>ta`  | **A**tach to the nearest **t**est                                    |
| `<localleader>tU`  | Stop the nearest **T**est **u**nit                                   |
| `<localleader>tf`  | Run **T**ests for current **f**ile                                   |
| `<localleader>tf`  | Run **T**ests for entire **F**older                                  |
| `<localleader>tr`  | **R**e-run last **t**est                                             |
| `<localleader>to`  | Show **T**est **o**utput window                                      |
| `<localleader>ts`  | Show **T**est **s**ummary tree                                       |
| `<leader>ot`       | **O**pen **T**erminal at project root in floating window             |
| `<leader>oT`       | **O**pen **T**erminal at current file's dir in floating window       |

</details>

There are more specialised mappings provided, keep reading please!

### Text Objects

<details>
    <summary>Click to view the text objects</summary>

| Text Object | Description                                 |
| :---------- | :------------------------------------------ |
| `H`         | To the beginning of line                    |
| `L`         | To the end of line                          |
| `ii`        | **I**n **I**ndentation                      |
| `` i` ``    | **I**n backtick pairs (multi-line)          |
| `` a` ``    | **A**round backtick pairs (multi-line)      |
| `an`        | **A**round **N**ext pairs (current lint)    |
| `in`        | **I**n **N**ext pairs (current line)        |
| `il`        | **I**n line                                 |
| `al`        | **A**round line                             |
| `iN`        | **I**n **N**umeric value (can be float too) |
| `aN`        | **A**round **N**umeric value                |
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
| `az`        | **A**round folds                            |
| `iz`        | **I**n folds                                |

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
| `<leader>ml` | Add current line                                         |
| `<leader>md` | **D**elete **M**atches with fzf search.                  |
| `<leader>mc` | **C**lear all matched patterns on current window.        |

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
| `<leader>fA`       | Like `<leader>fA`, but you can filter filenames too    |
| `<leader>ri`       | **I**ncrementally search (**rg**) with current word.   |
| `<leader>fh`       | **F**ile **H**istory                                   |
| `<leader>fl`       | **F**ile **l**ocate (requires mlocate)                 |
| `<leader>gf`       | **GFiles**                                             |
| `<leader>mm`       | **Marks**                                              |
| `<Ctrl-x><Ctrl-k>` | Search in **dictionaries** (requires **words-insane**) |
| `<Ctrl-x><Ctrl-f>` | Search in **f**iles                                    |
| `<Ctrl-x><Ctrl-l>` | Search in **l**ines                                    |

| Yank Mappings | Description                                       |
| :------------ | :------------------------------------------------ |
| `<leader>yh`  | List **Y**ank **H**istory)                        |
| `<leader>y`   | **Y**ank to the `+` register (external clipboard) |
| `<leader>p`   | **P**aste from the `+` register                   |
| `<leader>P`   | **P**aste from the `+` register (before/above)    |
| (v) `p`       | **P**aste on selected text without changing "reg  |

If you keep hitting `<Ctrl-/>` the preview window will change width. With
`Shift-/` you can show and hide the preview window.

When you invoke `<leader>yh` you will be presented with a history of the
**yanked** items. Upon choosing one, the item will be set to the unnamed
register and you use **p** from there.

When a file is selected, additional to what **fzf** provides out of the box,
you can invoke one of these secondary actions:

| Mapping | Description                        |
| :------ | :--------------------------------- |
| `alt-/` | To search in the lines.            |
| `alt-@` | To search in ctags or lsp symbols. |
| `alt-:` | To go to a specific line.          |
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
| :---------- | :----------------------------------------- |
| ArgAdd      | Select and add files to the args list      |
| ArgDelete   | Select and delete files from the args list |
| GGrep       | Run **git grep**                           |
| Marks       | Show marks with preview                    |
| MarksDelete | Delete marks                               |
| Worktree    | (Also WT) switches between git worktrees   |
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
| :------------ | :--------------------------------------------------------- |
| `gd`          | **G**o to **D**efinition                                   |
| `gD`          | **G**o to **D**eclaration                                  |
| `<leader>df`  | Show function **d**e**f**inition in popup                  |
| `<leader>gi`  | **G**o to **I**mplementation                               |
| `gr`          | Show **R**eferences                                        |
| `<leader>@`   | Document Symbols                                           |
| `<leader>gc`  | Show **C**allers (incoming calls)                          |
| `H`           | **H**over popup                                            |
| `<Alt-h>`     | (insert mode) Show **H**over popup                         |
| `K`           | Show **S**ignature help                                    |
| `<Alt-l>`     | (insert mode) Show **S**ignature help                      |
| `<Ctrl-l>`    | (insert/select mode) next snippet choice                   |
| `<Ctrl-h>`    | (insert/select mode) previous snippet choice               |
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
| `<leader>.f`  | Swap **f**unction to next                                  |
| `<leader>,f`  | Swap **f**unction to previous                              |
| `<Alt-n>`     | Initiate **n**ode selection                                |
| `<CR>`        | After selection is initiated, increment selection          |
| `<BS>`        | After selection is initiated, decrease selection           |
| `<Alt-n>`     | After selection is initiated, increment selection on scope |

### Notes

- The `<leader>@` binding will use the `LSP` symbols if is attached to the
  buffer, or `ctags` otherwise.
- Invoke `<leader>df` twice to enter the flowing window. `q` exits.

Please see the code for all available mappings.

</details>

**LSP** defines its own set of commands, however I have added a few interesting
additions.

<details>
    <summary>Click to view the commands</summary>

| Command            | Description                                   |
| :----------------- | :-------------------------------------------- |
| `RestartLsp`       | Restart LSP with a delay.                     |
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

| Command               | Description                             |
| :-------------------- | :-------------------------------------- |
| `InstallDependencies` | Install required dependencies           |
| `CC`                  | Close all floating windows              |
| `Scratch`             | Create a scratch buffer                 |
| `Filename`            | View the filename                       |
| `YankFilename`        | Yank the filename to `"` register       |
| `YankFilenameC`       | Yank the filename to `+` register       |
| `YankFilepath`        | Yank the file path to `"` register      |
| `YankFilepathC`       | Yank the file path to `+` register      |
| `MergeConflict`       | Search for merge conflicts              |
| `JsonDiff`            | Diff json files after formatting them   |
| `Tmux`                | Start a tmux project (using tmuxp)      |
| [count]`Lorem`        | Insert (count) line(s) Lorem Ipsum text |
| `Faster`              | Disable feature to make Neovim smoother |
| `Slower`              | Undoes the `Faster` changes             |

After running `InstallDependencies` you will be notified to install some
programs.

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

#### User Input

This launches a popup buffer for the input:

```lua
require("arshlib.util").user_input({
  prompt = "Message: ",
  on_submit = function(value)
    print("Thank you for your note: " .. value)
  end,
})
```

#### Dump

Unpacks and prints tables. This function is injected into the global scope.

```lua
dump({ name = "Arsham" })
```

## Folder Structure

You will notice not everything is where they should be. For example there is a
`lua/mappings.lua` file that contains a lot of mappings, but there are a few
more in plugin settings and lsp folder. The same goes for the commands.

The reason for this is because I wanted to make sure if I disable a plugin,
none of its associated mappings or commands are loaded.

## Plugin License List

<details>
    <summary>Click to view the plugin list</summary>

| Plugin                                            | License                                                                                                  |
| ------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| [folke/lazy.nvim][folke/lazy.nvim]                | [Apache-2.0 license](https://github.com/folke/lazy.nvim/blob/main/LICENSE)                               |
| [arsham/arshlib.nvim][arsham/arshlib.nvim]        | [MIT license](https://github.com/arsham/arshlib.nvim/blob/master/LICENSE)                                |
| [numToStr/Navigator.nvim][navigator.nvim]         | [MIT license](https://github.com/numToStr/Navigator.nvim/blob/master/LICENSE)                            |
| [tpope/vim-repeat][tpope/vim-repeat]              | [N/A][tpope/vim-repeat]                                                                                  |
| [junegunn/fzf][junegunn/fzf]                      | [MIT license](https://github.com/junegunn/fzf/blob/master/LICENSE)                                       |
| [junegunn/fzf.vim][junegunn/fzf.vim]              | [MIT license](https://github.com/junegunn/fzf.vim/blob/master/LICENSE)                                   |
| [arsham/fzfmania.nvim][arsham/fzfmania.nvim]      | [MIT license](https://github.com/arsham/fzfmania.nvim/blob/master/LICENSE)                               |
| [ibhagwan/fzf-lua][ibhagwan/fzf-lua]              | [AGPL-3.0 license](https://github.com/ibhagwan/fzf-lua/blob/main/LICENSE)                                |
| [arsham/arshamiser.nvim][arsham/arshamiser.nvim]  | [MIT license](https://github.com/arsham/arshamiser.nvim/blob/master/LICENSE)                             |
| [arsham/listish.nvim][arsham/listish.nvim]        | [MIT license](https://github.com/arsham/listish.nvim/blob/master/LICENSE)                                |
| [kevinhwang91/nvim-bqf][kevinhwang91/nvim-bqf]    | [BSD-3-Clause license](https://github.com/kevinhwang91/nvim-bqf/blob/main/LICENSE)                       |
| [arsham/archer.nvim][arsham/archer.nvim]          | [MIT license](https://github.com/arsham/archer.nvim/blob/master/LICENSE)                                 |
| [arsham/indent-tools.nvim][indent-tools.nvim]     | [MIT license](https://github.com/arsham/indent-tools.nvim/blob/master/LICENSE)                           |
| [arsham/matchmaker.nvim][arsham/matchmaker.nvim]  | [MIT license](https://github.com/arsham/matchmaker.nvim/blob/master/LICENSE)                             |
| [arsham/yanker.nvim][arsham/yanker.nvim]          | [MIT license](https://github.com/arsham/yanker.nvim/blob/master/LICENSE)                                 |
| [neovim/nvim-lspconfig][neovim/nvim-lspconfig]    | [View license](https://github.com/neovim/nvim-lspconfig/blob/master/LICENSE.md)                          |
| [mason.nvim][mason.nvim]                          | [Apache-2.0 license](https://github.com/williamboman/mason.nvim/blob/main/LICENSE)                       |
| [mason-lspconfig.nvim][mason-lspconfig.nvim]      | [Apache-2.0 license](https://github.com/williamboman/mason-lspconfig.nvim/blob/main/LICENSE)             |
| [mason-tool-installer][mason-tool-installer]      | [MIT license](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/blob/main/LICENSE)            |
| [j-hui/fidget.nvim][j-hui/fidget.nvim]            | [MIT license](https://github.com/j-hui/fidget.nvim/blob/main/LICENSE)                                    |
| [null-ls.nvim][null-ls.nvim]                      | [View license](https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/LICENSE)                     |
| [hrsh7th/nvim-cmp][hrsh7th/nvim-cmp]              | [MIT license](https://github.com/hrsh7th/nvim-cmp/blob/main/LICENSE)                                     |
| [hrsh7th/cmp-buffer][hrsh7th/cmp-buffer]          | [MIT license](https://github.com/hrsh7th/cmp-buffer/blob/main/LICENSE)                                   |
| [hrsh7th/cmp-calc][hrsh7th/cmp-calc]              | [N/A][hrsh7th/cmp-calc]                                                                                  |
| [hrsh7th/cmp-cmdline][hrsh7th/cmp-cmdline]        | [N/A][hrsh7th/cmp-cmdline]                                                                               |
| [hrsh7th/cmp-nvim-lsp][hrsh7th/cmp-nvim-lsp]      | [MIT license](https://github.com/hrsh7th/cmp-nvim-lsp/blob/main/LICENSE)                                 |
| [hrsh7th/lsp-signature-help][lsp-signature-help]  | [N/A][lsp-signature-help]                                                                                |
| [hrsh7th/cmp-nvim-lua][hrsh7th/cmp-nvim-lua]      | [N/A][hrsh7th/cmp-nvim-lua]                                                                              |
| [hrsh7th/cmp-path][hrsh7th/cmp-path]              | [MIT license](https://github.com/hrsh7th/cmp-path/blob/main/LICENSE)                                     |
| [lukas-reineke/cmp-rg][lukas-reineke/cmp-rg]      | [MIT license](https://github.com/lukas-reineke/cmp-rg/blob/master/LICENSE.md)                            |
| [saadparwaiz1/cmp_luasnip][cmp_luasnip]           | [Apache-2.0 license](https://github.com/saadparwaiz1/cmp_luasnip/blob/master/LICENSE)                    |
| [L3MON4D3/LuaSnip][l3mon4d3/luasnip]              | [Apache-2.0 license](https://github.com/L3MON4D3/LuaSnip/blob/master/LICENSE)                            |
| [smjonas/inc-rename.nvim][inc-rename.nvim]        | [MIT license](https://github.com/smjonas/inc-rename.nvim/blob/main/LICENSE)                              |
| [friendly-snippets][friendly-snippets]            | [MIT license](https://github.com/rafamadriz/friendly-snippets/blob/main/LICENSE)                         |
| [ray-x/go.nvim][ray-x/go.nvim]                    | [MIT license](https://github.com/ray-x/go.nvim/blob/master/LICENSE)                                      |
| [nanotee/sqls.nvim][nanotee/sqls.nvim]            | [MIT license](https://github.com/nanotee/sqls.nvim/blob/main/LICENSE)                                    |
| [nvim-treesitter][nvim-treesitter]                | [Apache-2.0 license](https://github.com/nvim-treesitter/nvim-treesitter/blob/master/LICENSE)             |
| [treesitter-refactor][nvim-treesitter-refactor]   | [Apache-2.0 license](https://github.com/nvim-treesitter/nvim-treesitter-refactor/blob/master/LICENSE)    |
| [treesitter-textobjects][treesitter-textobjects]  | [Apache-2.0 license](https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/LICENSE) |
| [nvim-treesitter/playground][playground]          | [Apache-2.0 license](https://github.com/nvim-treesitter/playground/blob/master/LICENSE)                  |
| [David-Kunz/treesitter-unit][treesitter-unit]     | [Unlicense license](https://github.com/David-Kunz/treesitter-unit/blob/main/LICENSE)                     |
| [nvim-neorg/neorg][nvim-neorg/neorg]              | [GPL-3.0 license](https://github.com/nvim-neorg/neorg/blob/main/LICENSE)                                 |
| [mfussenegger/nvim-dap][mfussenegger/nvim-dap]    | [GPL-3.0 license](https://github.com/mfussenegger/nvim-dap/blob/master/LICENSE.txt)                      |
| [rcarriga/nvim-dap-ui][rcarriga/nvim-dap-ui]      | [N/A][rcarriga/nvim-dap-ui]                                                                              |
| [nvim-dap-virtual-text][dap-virtual-text]         | [GPL-3.0 license](https://github.com/theHamsta/nvim-dap-virtual-text/blob/master/LICENSE.txt)            |
| [leoluz/nvim-dap-go][leoluz/nvim-dap-go]          | [N/A][leoluz/nvim-dap-go]                                                                                |
| [nvim-neotest/neotest][nvim-neotest/neotest]      | [MIT license]()                                                                                          |
| [nvim-neotest/neotest-go][neotest-go]             | [N/A][neotest-go]                                                                                        |
| [rouge8/neotest-rust][rouge8/neotest-rust]        | [MIT license](https://github.com/rouge8/neotest-rust/blob/main/LICENSE)                                  |
| [one-small-step-for-vimkind][vimkind]             | [MIT license](https://github.com/jbyuki/one-small-step-for-vimkind/blob/main/LICENSE)                    |
| [SmiteshP/nvim-navic][smiteshp/nvim-navic]        | [Apache-2.0 license]()                                                                                   |
| [lsp_lines.nvim][lsp_lines.nvim]                  | [ISC][lsp_lines.nvim]                                                                                    |
| [saecki/crates.nvim][saecki/crates.nvim]          | [MIT license](https://github.com/Saecki/crates.nvim/blob/main/LICENSE)                                   |
| [nvim-neo-tree/neo-tree.nvim][neo-tree.nvim]      | [MIT](https://github.com/nvim-neo-tree/neo-tree.nvim/blob/v2.x/LICENSE)                                  |
| [feline-nvim/feline.nvim][feline.nvim]            | [GPL-3.0 license](https://github.com/feline-nvim/feline.nvim/blob/master/LICENSE.md)                     |
| [gelguy/wilder.nvim][gelguy/wilder.nvim]          | [MIT license](https://github.com/gelguy/wilder.nvim/blob/master/LICENSE)                                 |
| [stevearc/dressing.nvim][stevearc/dressing.nvim]  | [MIT license](https://github.com/stevearc/dressing.nvim/blob/master/LICENSE)                             |
| [tpope/vim-fugitive][tpope/vim-fugitive]          | [N/A][tpope/vim-fugitive]                                                                                |
| [tpope/vim-rhubarb][tpope/vim-rhubarb]            | [MIT license](https://github.com/tpope/vim-rhubarb/blob/master/LICENSE)                                  |
| [mattn/vim-gist][mattn/vim-gist]                  | [N/A][mattn/vim-gist]                                                                                    |
| [lewis6991/gitsigns.nvim][gitsigns.nvim]          | [MIT license](https://github.com/lewis6991/gitsigns.nvim/blob/main/LICENSE)                              |
| [ldelossa/gh.nvim][ldelossa/gh.nvim]              | [MIT license](https://github.com/ldelossa/gh.nvim/blob/main/LICENSE)                                     |
| [ldelossa/litee.nvim][ldelossa/litee.nvim]        | [N/A][ldelossa/litee.nvim]                                                                               |
| [numToStr/Comment.nvim][numtostr/comment.nvim]    | [MIT license](https://github.com/numToStr/Comment.nvim/blob/master/LICENSE)                              |
| [ts-context-commentstring][context-commentstring] | [MIT license](https://github.com/JoosepAlviste/nvim-ts-context-commentstring/blob/main/LICENSE)          |
| [vim-scripts/visualrepeat][visualrepeat]          | [N/A][visualrepeat]                                                                                      |
| [arthurxavierx/vim-caser][vim-caser]              | [View license](https://github.com/arthurxavierx/vim-caser/blob/master/LICENSE)                           |
| [mg979/vim-visual-multi][mg979/vim-visual-multi]  | [MIT license](https://github.com/mg979/vim-visual-multi/blob/master/LICENSE)                             |
| [gbprod/substitute.nvim][gbprod/substitute.nvim]  | [WTFPL license]()                                                                                        |
| [windwp/nvim-autopairs][windwp/nvim-autopairs]    | [MIT license](https://github.com/windwp/nvim-autopairs/blob/master/LICENSE)                              |
| [rcarriga/nvim-notify][rcarriga/nvim-notify]      | [MIT license](https://github.com/rcarriga/nvim-notify/blob/master/LICENSE)                               |
| [MunifTanjim/nui.nvim][muniftanjim/nui.nvim]      | [MIT license](https://github.com/MunifTanjim/nui.nvim/blob/main/LICENSE)                                 |
| [folke/noice.nvim][folke/noice.nvim]              | [Apache-2.0 license](https://github.com/folke/noice.nvim/blob/main/LICENSE)                              |
| [mbbill/undotree][mbbill/undotree]                | [N/A][mbbill/undotree]                                                                                   |
| [towolf/vim-helm][towolf/vim-helm]                | [View license](https://github.com/towolf/vim-helm/blob/master/LICENSE)                                   |
| [echasnovski/mini.nvim][echasnovski/mini.nvim]    | [MIT license]()                                                                                          |
| [glts/vim-textobj-comment][vim-textobj-comment]   | [N/A][vim-textobj-comment]                                                                               |
| [kana/vim-textobj-user][kana/vim-textobj-user]    | [N/A][kana/vim-textobj-user]                                                                             |
| [woosaaahh/sj.nvim][woosaaahh/sj.nvim]            | [MIT license](https://github.com/woosaaahh/sj.nvim/blob/main/LICENSE)                                    |
| [nvim-tree/nvim-web-devicons][nvim-web-devicons]  | [MIT license](https://github.com/nvim-tree/nvim-web-devicons/blob/master/LICENSE)                        |
| [dhruvasagar/vim-zoom][dhruvasagar/vim-zoom]      | [N/A][dhruvasagar/vim-zoom]                                                                              |
| [NvChad/nvim-colorizer.lua][nvim-colorizer.lua]   | [View license](https://github.com/NvChad/nvim-colorizer.lua/blob/master/LICENSE)                         |
| [ziontee113/color-picker.nvim][color-picker]      | [MIT license](https://github.com/ziontee113/color-picker.nvim/blob/master/LICENSE)                       |
| [chentoast/marks.nvim][chentoast/marks.nvim]      | [MIT license](https://github.com/chentoast/marks.nvim/blob/master/LICENSE)                               |
| [iamcco/markdown-preview.nvim][markdown-preview]  | [MIT license](https://github.com/iamcco/markdown-preview.nvim/blob/master/LICENSE)                       |
| [willchao612/vim-diagon][willchao612/vim-diagon]  | [MIT license](https://github.com/willchao612/vim-diagon/blob/main/LICENSE)                               |
| [jbyuki/venn.nvim][jbyuki/venn.nvim]              | [MIT license](https://github.com/jbyuki/venn.nvim/blob/main/LICENSE)                                     |
| [monaqa/dial.nvim][monaqa/dial.nvim]              | [MIT license](https://github.com/monaqa/dial.nvim/blob/master/LICENSE)                                   |
| [bfredl/nvim-luadev][bfredl/nvim-luadev]          | [MIT license](https://github.com/bfredl/nvim-luadev/blob/master/LICENSE)                                 |
| [sQVe/sort.nvim][sqve/sort.nvim]                  | [MIT license](https://github.com/sQVe/sort.nvim/blob/main/LICENSE)                                       |
| [ralismark/opsort.vim][ralismark/opsort.vim]      | [MIT license](https://github.com/ralismark/opsort.vim/blob/main/LICENSE)                                 |
| [kiran94/s3edit.nvim][kiran94/s3edit.nvim]        | [MIT license](https://github.com/kiran94/s3edit.nvim/blob/main/LICENSE)                                  |
| [tweekmonster/startuptime.vim][startuptime.vim]   | [MIT license](https://github.com/tweekmonster/startuptime.vim/blob/master/LICENSE)                       |
| [svban/YankAssassin.vim][svban/yankassassin.vim]  | [N/A][svban/yankassassin.vim]                                                                            |
| [tmux-plugins/vim-tmux][tmux-plugins/vim-tmux]    | [N/A][tmux-plugins/vim-tmux]                                                                             |
| [tpope/vim-git][tpope/vim-git]                    | [N/A][tpope/vim-git]                                                                                     |
| [andymass/vim-matchup][andymass/vim-matchup]      | [MIT license](https://github.com/andymass/vim-matchup/blob/master/LICENSE.md)                            |
| [folke/neodev.nvim][folke/neodev.nvim]            | [Apache-2.0 license](https://github.com/folke/neodev.nvim/blob/main/LICENSE)                             |
| [mattn/webapi-vim][mattn/webapi-vim]              | [N/A][mattn/webapi-vim]                                                                                  |
| [milisims/nvim-luaref][milisims/nvim-luaref]      | [MIT license](https://github.com/milisims/nvim-luaref/blob/main/LICENSE)                                 |
| [nvim-lua/plenary.nvim][nvim-lua/plenary.nvim]    | [MIT license](https://github.com/nvim-lua/plenary.nvim/blob/master/LICENSE)                              |
| [samjwill/nvim-unception][nvim-unception]         | [MIT license](https://github.com/samjwill/nvim-unception/blob/main/LICENSE)                              |
| [s1n7ax/nvim-window-picker][nvim-window-picker]   | [MIT license](https://github.com/s1n7ax/nvim-window-picker/blob/main/LICENSE)                            |

</details>

[folke/lazy.nvim]: https://github.com/folke/lazy.nvim
[arsham/arshlib.nvim]: https://github.com/arsham/arshlib.nvim
[navigator.nvim]: https://github.com/numToStr/Navigator.nvim
[tpope/vim-repeat]: https://github.com/tpope/vim-repeat
[junegunn/fzf]: https://github.com/junegunn/fzf
[junegunn/fzf.vim]: https://github.com/junegunn/fzf.vim
[arsham/fzfmania.nvim]: https://github.com/arsham/fzfmania.nvim
[ibhagwan/fzf-lua]: https://github.com/ibhagwan/fzf-lua
[arsham/arshamiser.nvim]: https://github.com/arsham/arshamiser.nvim
[arsham/listish.nvim]: https://github.com/arsham/listish.nvim
[kevinhwang91/nvim-bqf]: https://github.com/kevinhwang91/nvim-bqf
[arsham/archer.nvim]: https://github.com/arsham/archer.nvim
[indent-tools.nvim]: https://github.com/arsham/indent-tools.nvim
[arsham/matchmaker.nvim]: https://github.com/arsham/matchmaker.nvim
[arsham/yanker.nvim]: https://github.com/arsham/yanker.nvim
[neovim/nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[mason.nvim]: https://github.com/williamboman/mason.nvim
[mason-lspconfig.nvim]: https://github.com/williamboman/mason-lspconfig.nvim
[mason-tool-installer]: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
[j-hui/fidget.nvim]: https://github.com/j-hui/fidget.nvim
[null-ls.nvim]: https://github.com/jose-elias-alvarez/null-ls.nvim
[hrsh7th/nvim-cmp]: https://github.com/hrsh7th/nvim-cmp
[hrsh7th/cmp-buffer]: https://github.com/hrsh7th/cmp-buffer
[hrsh7th/cmp-calc]: https://github.com/hrsh7th/cmp-calc
[hrsh7th/cmp-cmdline]: https://github.com/hrsh7th/cmp-cmdline
[hrsh7th/cmp-nvim-lsp]: https://github.com/hrsh7th/cmp-nvim-lsp
[lsp-signature-help]: https://github.com/hrsh7th/cmp-nvim-lsp-signature-help
[hrsh7th/cmp-nvim-lua]: https://github.com/hrsh7th/cmp-nvim-lua
[hrsh7th/cmp-path]: https://github.com/hrsh7th/cmp-path
[lukas-reineke/cmp-rg]: https://github.com/lukas-reineke/cmp-rg
[cmp_luasnip]: https://github.com/saadparwaiz1/cmp_luasnip
[l3mon4d3/luasnip]: https://github.com/L3MON4D3/LuaSnip
[inc-rename.nvim]: https://github.com/smjonas/inc-rename.nvim
[friendly-snippets]: https://github.com/rafamadriz/friendly-snippets
[ray-x/go.nvim]: https://github.com/ray-x/go.nvim
[nanotee/sqls.nvim]: https://github.com/nanotee/sqls.nvim
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[nvim-treesitter-refactor]: https://github.com/nvim-treesitter/nvim-treesitter-refactor
[treesitter-textobjects]: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
[playground]: https://github.com/nvim-treesitter/playground
[treesitter-unit]: https://github.com/David-Kunz/treesitter-unit
[nvim-neorg/neorg]: https://github.com/nvim-neorg/neorg
[mfussenegger/nvim-dap]: https://github.com/mfussenegger/nvim-dap
[rcarriga/nvim-dap-ui]: https://github.com/rcarriga/nvim-dap-ui
[dap-virtual-text]: https://github.com/theHamsta/nvim-dap-virtual-text
[leoluz/nvim-dap-go]: https://github.com/leoluz/nvim-dap-go
[nvim-neotest/neotest]: https://github.com/nvim-neotest/neotest
[neotest-go]: https://github.com/nvim-neotest/neotest-go
[rouge8/neotest-rust]: https://github.com/rouge8/neotest-rust
[vimkind]: https://github.com/jbyuki/one-small-step-for-vimkind
[smiteshp/nvim-navic]: https://github.com/SmiteshP/nvim-navic
[lsp_lines.nvim]: https://git.sr.ht/~whynothugo/lsp_lines.nvim
[saecki/crates.nvim]: https://github.com/saecki/crates.nvim
[neo-tree.nvim]: https://github.com/nvim-neo-tree/neo-tree.nvim
[feline.nvim]: https://github.com/feline-nvim/feline.nvim
[gelguy/wilder.nvim]: https://github.com/gelguy/wilder.nvim
[stevearc/dressing.nvim]: https://github.com/stevearc/dressing.nvim
[tpope/vim-fugitive]: https://github.com/tpope/vim-fugitive
[tpope/vim-rhubarb]: https://github.com/tpope/vim-rhubarb
[mattn/vim-gist]: https://github.com/mattn/vim-gist
[gitsigns.nvim]: https://github.com/lewis6991/gitsigns.nvim
[ldelossa/gh.nvim]: https://github.com/ldelossa/gh.nvim
[ldelossa/litee.nvim]: https://github.com/ldelossa/litee.nvim
[numtostr/comment.nvim]: https://github.com/numToStr/Comment.nvim
[context-commentstring]: https://github.com/JoosepAlviste/nvim-ts-context-commentstring
[visualrepeat]: https://github.com/vim-scripts/visualrepeat
[vim-caser]: https://github.com/arthurxavierx/vim-caser
[mg979/vim-visual-multi]: https://github.com/mg979/vim-visual-multi
[gbprod/substitute.nvim]: https://github.com/gbprod/substitute.nvim
[windwp/nvim-autopairs]: https://github.com/windwp/nvim-autopairs
[rcarriga/nvim-notify]: https://github.com/rcarriga/nvim-notify
[muniftanjim/nui.nvim]: https://github.com/MunifTanjim/nui.nvim
[folke/noice.nvim]: https://github.com/folke/noice.nvim
[mbbill/undotree]: https://github.com/mbbill/undotree
[towolf/vim-helm]: https://github.com/towolf/vim-helm
[echasnovski/mini.nvim]: https://github.com/echasnovski/mini.nvim
[vim-textobj-comment]: https://github.com/glts/vim-textobj-comment
[kana/vim-textobj-user]: https://github.com/kana/vim-textobj-user
[woosaaahh/sj.nvim]: https://github.com/woosaaahh/sj.nvim
[nvim-web-devicons]: https://github.com/nvim-tree/nvim-web-devicons
[dhruvasagar/vim-zoom]: https://github.com/dhruvasagar/vim-zoom
[nvim-colorizer.lua]: https://github.com/NvChad/nvim-colorizer.lua
[color-picker]: https://github.com/ziontee113/color-picker.nvim
[chentoast/marks.nvim]: https://github.com/chentoast/marks.nvim
[markdown-preview]: https://github.com/iamcco/markdown-preview.nvim
[willchao612/vim-diagon]: https://github.com/willchao612/vim-diagon
[jbyuki/venn.nvim]: https://github.com/jbyuki/venn.nvim
[monaqa/dial.nvim]: https://github.com/monaqa/dial.nvim
[bfredl/nvim-luadev]: https://github.com/bfredl/nvim-luadev
[sqve/sort.nvim]: https://github.com/sQVe/sort.nvim
[ralismark/opsort.vim]: https://github.com/ralismark/opsort.vim
[kiran94/s3edit.nvim]: https://github.com/kiran94/s3edit.nvim
[startuptime.vim]: https://github.com/tweekmonster/startuptime.vim
[svban/yankassassin.vim]: https://github.com/svban/YankAssassin.vim
[tmux-plugins/vim-tmux]: https://github.com/tmux-plugins/vim-tmux
[tpope/vim-git]: https://github.com/tpope/vim-git
[andymass/vim-matchup]: https://github.com/andymass/vim-matchup
[folke/neodev.nvim]: https://github.com/folke/neodev.nvim
[mattn/webapi-vim]: https://github.com/mattn/webapi-vim
[milisims/nvim-luaref]: https://github.com/milisims/nvim-luaref
[nvim-lua/plenary.nvim]: https://github.com/nvim-lua/plenary.nvim
[nvim-unception]: https://github.com/samjwill/nvim-unception
[nvim-window-picker]: https://github.com/s1n7ax/nvim-window-picker

<!--
vim: foldlevel=2 conceallevel=0
-->
