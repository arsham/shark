return {
  settings = {
    ["rust-analyzer"] = {
      imports = {
        ["granularity.group"] = "module",
        prefix = "self",
      },
      cargo = {
        ["buildScripts.enable"] = true,
      },
      procMacro = {
        enable = true,
      },
      files = {
        excludeDirs = { "target" },
      },
      ["lru.capacity"] = 2048,
      workspace = {
        symbol = {
          ["search.limit"] = 2048,
        },
      },
      diagnostics = {
        enable = true,
        enableExperimental = true,
        experimental = {
          enable = true,
        },
      },

      ["updates.channel"] = "nightly",
      rustfmt = {
        extraArgs = { "--all", "--", "--check" },
      },
      checkOnSave = {
        command = "clippy",
        allFeatures = true,
        features = "all",
        overrideCommand = {
          "cargo",
          "clippy",
          "--workspace",
          "--message-format=json",
          "--all-targets",
          "--all-features",
          "--",
          "-W",
          "correctness",
          "-W",
          "keyword_idents",
          "-W",
          "rust_2021_prelude_collisions",
          "-W",
          "trivial_casts",
          "-W",
          "trivial_numeric_casts",
          "-W",
          "unused_lifetimes",
          "-W",
          "unwrap_used",
        },
      },
    },
  },

  server_capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          -- enable auto-import
          resolveSupport = {
            properties = { "documentation", "detail", "additionalTextEdits" },
          },
          snippetSupport = true,
        },
      },
    },
    experimental = {
      commands = {
        commands = {
          "rust-analyzer.runSingle",
          "rust-analyzer.debugSingle",
          "rust-analyzer.showReferences",
          "rust-analyzer.gotoLocation",
          "editor.action.triggerParameterHints",
        },
      },
      hoverActions = true,
      hoverRange = true,
      serverStatusNotification = true,
      snippetTextEdit = true,
      codeActionGroup = true,
      ssr = true,
    },
  },
}

-- vim: fdm=marker fdl=0
