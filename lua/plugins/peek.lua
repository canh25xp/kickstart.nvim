-- markdown preview
return {
  "toppair/peek.nvim",
  cond = function() return vim.fn.executable("deno") == 1 end,
  build = "deno task --quiet build:fast",
  keys = {
    {
      "<leader>cp",
      ft = "markdown",
      function()
        local peek = require("peek")
        if peek.is_open() then
          peek.close()
        else
          peek.open()
        end
      end,
      desc = "Peek (Markdown Preview)",
    },
  },
  opts = {
    theme = "dark",
    app = "browser",
    close_on_bdelete = true,
  },
}
