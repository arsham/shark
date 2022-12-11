local neotest = require("neotest")

local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local message =
        diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
      return message
    end,
  },
}, neotest_ns)

neotest.setup({
  log_level = vim.log.levels.WARN,
  diagnostic = {
    enabled = true,
  },
  status = {
    virtual_text = true,
    signs = true,
  },
  strategies = {
    integrated = {
      width = 180,
    },
  },
  icons = {
    running_animated = {
      "",
      "🞅",
      "🞈",
      "🞉",
      "",
      "",
      "🞉",
      "🞈",
      "🞅",
      "",
    },
  },
  adapters = {
    require("neotest-go"),
    require("neotest-rust"),
  },
})

local group = vim.api.nvim_create_augroup("NEOTEST_MAPPINGS", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "go", "rust" },
  callback = function()
    -- vim.keymap.set("n", "[n", function()
    --   neotest.jump.prev({})
    -- end, { buffer = true, desc = "jump to the previous test" })
    --
    -- vim.keymap.set("n", "]n", function()
    --   neotest.jump.next({})
    -- end, { buffer = true, desc = "jump to the next test" })

    vim.keymap.set("n", "<localleader>tu", function()
      neotest.run.run()
    end, { buffer = true, desc = "run nearest test" })

    vim.keymap.set("n", "<localleader>ta", function()
      neotest.run.attach()
    end, { buffer = true, desc = "attach to the nearest test" })

    vim.keymap.set("n", "<localleader>tU", function()
      neotest.run.stop()
    end, { buffer = true, desc = "stop the nearest test" })

    vim.keymap.set("n", "<localleader>tf", function()
      neotest.run.run(vim.fn.expand("%"))
    end, { buffer = true, desc = "run test for current file" })

    vim.keymap.set("n", "<localleader>tF", function()
      neotest.run.run(vim.fn.expand("%:p:h:h"))
    end, { buffer = true, desc = "run test for entire test folder" })

    vim.keymap.set("n", "<localleader>tr", function()
      neotest.run.run_last()
    end, { buffer = true, desc = "rerun last test" })

    vim.keymap.set("n", "<localleader>to", function()
      neotest.output.open({ enter = true })
    end, { buffer = true, desc = "show test output window" })

    vim.keymap.set("n", "<localleader>ts", function()
      neotest.summary.toggle()
    end, { buffer = true, desc = "show test summary tree" })
  end,
})

-- Doesn't work!
-- vim.keymap.set("n", "<localleader>td", function()
--   neotest.run.run({ strategy = "dap" })
-- end, { buffer = true, desc = "debug the nearest test" })
-- vim.api.nvim_create_autocmd("FileType", {
--   group = group,
--   pattern = "neotest-output",
--   callback = function()
--     vim.keymap.set("n", "q", function()
--       neotest.output_panel.close()
--     end, { buffer = true, desc = "close the test output" })
--     vim.keymap.set("n", "", function()
--       neotest.output_panel.close()
--     end, { buffer = true, desc = "close the test output" })
--   end,
--   desc = "quick neotest output with q",
-- })
