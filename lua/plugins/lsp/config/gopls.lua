return {
  settings = {
    -- more settings: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    gopls = {
      analyses = {
        unusedparams = true,
        nillness = true,
        unusedwrites = true,
        useany = true,
        unusedvariable = true,
      },
      completeUnimported = true,
      staticcheck = true,
      buildFlags = { "-tags=integration,e2e,mage" },
      linksInHover = true,
      codelenses = {
        generate = true,
        gc_details = true,
        test = true,
        tidy = true,
        run_govulncheck = true,
        upgrade_dependency = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      usePlaceholders = true,
      directoryFilters = {
        "-**/node_modules",
        "-/tmp",
        "-.git",
      },
      completionDocumentation = true,
      deepCompletion = true,
      semanticTokens = true,
      verboseOutput = false, -- useful for debugging when true.
      matcher = "Fuzzy", -- default
      diagnosticsDelay = "500ms",
      symbolMatcher = "Fuzzy", -- default is FastFuzzy
    },
  },

  capabilities = {
    textDocument = {
      completion = {
        completionItem = {},
        contextSupport = true,
        dynamicRegistration = true,
      },
    },
  },

  server_capabilities = {
    semanticTokensProvider = {
      range = true,
    },
  },
}

-- vim: fdm=marker fdl=0
