local M = {}

M.lua_terminal_window = nil
M.lua_terminal_buffer = nil
M.lua_terminal_job_id = nil

function M.Open()
  if vim.fn.bufexists(M.lua_terminal_buffer) == 0 then
    vim.api.nvim_command("new lua_terminal")
    vim.api.nvim_command("wincmd J")
    M.lua_terminal_job_id = vim.fn.termopen(os.getenv("SHELL"), {
      detach = 1,
    })
    vim.api.nvim_command("silent file Terminal 1")
    M.lua_terminal_window = vim.fn.win_getid()
    M.lua_terminal_buffer = vim.fn.bufnr("%")
    vim.opt.buflisted = false
  else
    if vim.fn.win_gotoid(M.lua_terminal_window) == 0 then
      vim.api.nvim_command("sp")
      vim.api.nvim_command("wincmd J")
      vim.api.nvim_command("buffer Terminal 1")
      M.lua_terminal_window = vim.fn.win_getid()
    end
  end
  vim.cmd("startinsert")
end

function M.Close()
  if vim.fn.win_gotoid(M.lua_terminal_window) == 1 then
    vim.api.nvim_command("hide")
  end
end

function M.Toggle()
  if vim.fn.win_gotoid(M.lua_terminal_window) == 1 then
    M.Close()
  else
    M.Open()
  end
end

---@diagnostic disable-next-line: unused-local, unused-function
function M.Exec(cmd)
  if vim.fn.win_gotoid(M.lua_terminal_window) == 0 then
    M.Open()
  end
  vim.fn.chansend(M.lua_terminal_job_id, "clear\n")
  vim.fn.chansend(M.lua_terminal_job_id, cmd .. "\n")
  vim.api.nvim_command("normal! G")
  vim.api.nvim_command("wincmd p")
end

return M
