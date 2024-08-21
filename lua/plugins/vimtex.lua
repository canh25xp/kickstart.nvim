return {
  "lervag/vimtex",
  lazy = false,
  -- tag = "v2.15",
  config = function()
    vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
    vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
    vim.g.vimtex_compiler_latexmk = {
      continuous = 1,
    }
    -- vim.g.tex_conceal = "abdmgs"
    vim.g.vimtex_quickfix_mode = 0
    -- vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1
    -- vim.g.vimtex_compiler_latexmk_engines = { ["_"] = "-lualatex" }
    vim.g.vimtex_view_enabled = 1
    vim.g.vimtex_view_automatic = 1
    vim.g.vimtex_doc_confirm_single = 0
    vim.g.vimtex_doc_handlers = { "vimtex#doc#handlers#texdoc" }
    vim.g.vimtex_view_method = "sioyek"
    if vim.fn.has("wsl") == 1 then
      vim.g.vimtex_view_sioyek_exe = "sioyek.exe"
      vim.g.vimtex_callback_progpath = "wsl nvim"
    end
    -- vim.g.vimtex_view_sioyek_options = "--reuse-window"

    -- vim.g.vimtex_callback_progpath = "pwsh"
    -- if vim.fn.has("win32") or (vim.fn.has("unix") and vim.fn.exists("$WSLENV")) then
    --   if vim.fn.executable("sioyek.exe") then
    --     vim.g.vimtex_view_method = "sioyek"
    --     vim.g.vimtex_view_sioyek_exe = "sioyek.exe"
    --     vim.g.vimtex_callback_progpath = "wsl nvim"
    --   elseif vim.fn.executable("mupdf.exe") then
    --     vim.g.vimtex_view_general_viewer = "mupdf.exe"
    --   elseif vim.fn.executable("SumatraPDF.exe") then
    --     vim.g.vimtex_view_general_viewer = "SumatraPDF.exe"
    --     vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
    --   end
    -- end
  end,
}
