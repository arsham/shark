return {
  settings = {
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
      buildFlags = { "-tags=integration,e2e" },
      linksInHover = true,
      codelenses = {
        generate = true,
        gc_details = true,
        test = true,
        tidy = true,
        run_vulncheck_exp = true,
        upgrade_dependency = true,
      },
      usePlaceholders = true,
      directoryFilters = {
        "-**/node_modules",
        "-/tmp",
      },
      completionDocumentation = true,
      deepCompletion = true,
      semanticTokens = true,
      verboseOutput = false, -- useful for debugging when true.
    },
  },

  capabilities = function(capabilities)
    capabilities.textDocument.completion.completionItem.snippetSupport = false
  end,

  pre_attach = function(client)
    local semantic = client.config.capabilities.textDocument.semanticTokens
    client.server_capabilities.semanticTokensProvider = {
      full = true,
      legend = {
        tokenModifiers = semantic.tokenModifiers,
        tokenTypes = semantic.tokenTypes,
      },
    }
  end,
}

-- vim: fdm=marker fdl=0
