require("dapui").setup()
local dap = require("dap")
local dapui = require("dapui")
local widgets = require("dap.ui.widgets")

local function opt(msg)
  return { desc = "DAP: " .. msg, silent = true }
end

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opt("breakpoint"))
vim.keymap.set("n", "<F2>", dap.continue, opt("continue"))
vim.keymap.set("n", "<F3>", dap.step_into, opt("step into"))
vim.keymap.set("n", "<F4>", dap.step_over, opt("step over"))
vim.keymap.set("n", "<F5>", dap.step_out, opt("step out"))

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.after.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.after.event_exited["dapui_config"] = function()
  dapui.close()
end

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    host = function()
      local value = vim.fn.input("Host [127.0.0.1]: ")
      if value ~= "" then
        return value
      end
      return "127.0.0.1"
    end,
    port = function()
      local val = tonumber(vim.fn.input("Port: "))
      assert(val, "Please provide a port number")
      return val
    end,
  },
}

require("nvim-dap-virtual-text").setup()

dap.listeners.after["event_initialized"]["my_mappings"] = function()
  vim.opt.mouse = "nvi"
  local function o(bufnr, msg)
    return { desc = "DAP: " .. msg, silent = true, buffer = bufnr }
  end
  for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
    vim.keymap.set("n", "<localleader>dc", dap.continue, opt("continue"))
    vim.keymap.set("n", "<localleader>di", dap.step_into, o(bufnr, "step into"))
    vim.keymap.set("n", "<localleader>do", dap.step_over, o(bufnr, "step over"))
    vim.keymap.set("n", "<localleader>dO", dap.step_out, o(bufnr, "step out"))
    vim.keymap.set("n", "<localleader>dT", dap.terminate, o(bufnr, "terminate"))
    vim.keymap.set("n", "<localleader>du", dapui.toggle, o(bufnr, "toggle ui"))
    vim.keymap.set("n", "<localleader>dh", widgets.hover, o(bufnr, "hover"))
    vim.keymap.set("n", "<localleader>df", function()
      widgets.centered_float(widgets.scopes)
    end, o(bufnr, "float view"))
    vim.keymap.set("n", "<localleader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, o(bufnr, "contitional breakpoint"))
    vim.keymap.set("n", "<localleader>dl", function()
      dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end, o(bufnr, "log point message"))
  end
end

dap.listeners.after["event_terminated"]["my_mappings"] = function()
  vim.opt.mouse = nil
end

-- vim: fdm=marker
