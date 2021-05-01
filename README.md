# Dotfiles

This repository holds my dotfiles. This setup is only testes on Arch Linux.

This setup uses GNU's [stow](https://www.gnu.org/software/stow/) for managing
the symlinks. 

If you need only the `nvim` setup:

```bash
stow nvim
```

## Nvim

I am using a mixture of vimscript and lua for this setup. The aim to have a fast
startup time and provide the functionalities I need for day-to-day tasks. 

## Tinyvim

Tinyvim is supposed to be tiny vim setup. I need to find a better name for it, 
but for now it serves the purpose. 

There is an alias in the `.zaliases` file to isolate the setup from the main 
nvim setup.
