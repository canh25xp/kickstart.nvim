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
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
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
      { "<leader>dd", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
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
    },
    config = function()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(require("common.ui").icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define("Dap" .. name, { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] })
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          commented = false, -- prefix virtual text with comment string
          virt_text_pos = "eol",
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Debug: Toggle Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Debug: Eval", mode = {"n", "v"} },
    },
    opts = {
      floating = {
        border = "single",
        mappings = {
          close = { "qq", "<Esc>" },
        },
      },
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.4 },
            { id = "watches", size = 0.4 },
            { id = "breakpoints", size = 0.1 },
            { id = "stacks", size = 0.1 },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            { id = "console", size = 1.0 },
            -- { id = "repl", size = 0.5 },
          },
          position = "bottom",
          size = 10,
        },
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      -- stylua: ignore start
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close({}) end
      -- stylua: ignore stop
    end,
  },
}
