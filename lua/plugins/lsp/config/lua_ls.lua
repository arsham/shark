local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
table.insert(runtime_path, "?.lua")
table.insert(runtime_path, "?/init.lua")

return {
  settings = {
    Lua = {
      runtime = {
        special = {
          req = "require",
        },
        version = "LuaJIT",
        path = runtime_path,
      },
      diagnostics = {
        globals = {
          "vim",
          "require",
          "rocks",
        },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        ignoreDir = "tmp/",
        useGitIgnore = false,
        maxPreload = 100000000,
        preloadFileSize = 500000,
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },

  server_capabilities = {
    definition = true,
    typeDefinition = true,
  },
}
