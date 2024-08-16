---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
  end
  return config
end

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio", -- Required dependency for nvim-dap-ui
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  -- stylua: ignore
  keys = {
    { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
    { "<F5>",       function() require("dap").continue() end, desc = "Debug: Start/Continue" },
    { "<F10>",      function() require("dap").step_over() end, desc = "Debug: Step Over" },
    { "<F11>",      function() require("dap").step_into() end, desc = "Debug: Step In" },
    { "<F12>",      function() require("dap").step_out() end, desc = "Debug: Step Out" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug: Set Breakpoint", },
    { "<leader>dc", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Debug: Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Debug: Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Debug: Go to Line (No Execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Debug: Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Debug: Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Debug: Step Over" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Debug: Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Debug: Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Debug: Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Debug: Widgets" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle Dapui" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        "python",
        "cppdbg",
      },
    })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup({
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
  end,
}
