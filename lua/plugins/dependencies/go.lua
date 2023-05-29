return {
  {
    "itchyny/gojq",
    build = "go install github.com/itchyny/gojq/cmd/gojq@latest",
    cond = false,
  },

  {
    "mvdan/gofumpt",
    name = "Go Fumpt",
    build = "go install mvdan.cc/gofumpt@latest",
    cond = false,
  },

  {
    "junegunn/fzf",
    name = "FZF Binary",
    build = "go install github.com/junegunn/fzf@latest",
  },
}
