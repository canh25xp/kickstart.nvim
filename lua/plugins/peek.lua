return {
  "toppair/peek.nvim", -- markdown preview
  build = function()
    if not require("common.utils").executable("deno") then
      vim.notify("No deno executable found skip peek,vim build", vim.log.levels.ERROR)
      return
    end
    print("Building peek.nvim")
    os.execute("deno task --quiet build:fast")
    print("Done build peek.nvim")
  end,
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
