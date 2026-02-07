-- lua/config/terminal.lua

local M = {}

-- Track a "main" terminal plus any extra terminals you open
local state = {
  main_buf = nil,
  main_win = nil,
  bufs = {}, -- list of terminal buffers created via <leader>ta
}

local function is_valid_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

local function is_valid_win(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function focus_buf(buf)
  if not is_valid_buf(buf) then return false end
  local wins = vim.fn.win_findbuf(buf)
  if wins and #wins > 0 then
    vim.api.nvim_set_current_win(wins[1])
    return true
  end
  return false
end

local function open_term_split()
  vim.cmd("botright split")
  vim.cmd("resize 15")
  vim.cmd("terminal")
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  vim.cmd("startinsert")
  return buf, win
end

function M.open_main()
  -- Focus existing main terminal if it is visible
  if focus_buf(state.main_buf) then
    vim.cmd("startinsert")
    return
  end

  -- Otherwise create it
  local buf, win = open_term_split()
  state.main_buf = buf
  state.main_win = win
end

function M.close_main()
  if not is_valid_buf(state.main_buf) then
    state.main_buf = nil
    state.main_win = nil
    return
  end

  -- Close its window if open
  local wins = vim.fn.win_findbuf(state.main_buf)
  if wins and #wins > 0 then
    pcall(vim.api.nvim_win_close, wins[1], true)
  end

  -- Optionally wipe the buffer too
  pcall(vim.api.nvim_buf_delete, state.main_buf, { force = true })

  state.main_buf = nil
  state.main_win = nil
end

function M.add_term()
  local buf, _ = open_term_split()
  table.insert(state.bufs, buf)
end

function M.close_current_term()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype ~= "terminal" then
    return
  end

  -- Close the current window first
  local win = vim.api.nvim_get_current_win()
  pcall(vim.api.nvim_win_close, win, true)

  -- Then wipe the terminal buffer
  pcall(vim.api.nvim_buf_delete, buf, { force = true })

  -- Remove from tracked list if present
  for i = #state.bufs, 1, -1 do
    if state.bufs[i] == buf then
      table.remove(state.bufs, i)
      break
    end
  end

  -- If you closed the main terminal, clear it
  if state.main_buf == buf then
    state.main_buf = nil
    state.main_win = nil
  end
end

return M

