local M = {}

M.config = {
  register = "+",
  use_git_root = true,
}

function M.setup(opts)
  M.config = vim.tbl_extend("force", M.config, opts or {})
  
  -- Create command with subcommands
  vim.api.nvim_create_user_command("CopyReference", function(args)
    local subcommand = args.args:lower()
    if subcommand == "file" then
      M.copy(false)
    elseif subcommand == "line" or subcommand == "" then
      M.copy(true)
    else
      vim.notify("Invalid subcommand. Use 'line' or 'file'", vim.log.levels.ERROR)
    end
  end, {
    nargs = "?",
    complete = function(ArgLead, CmdLine, CursorPos)
      return { "line", "file" }
    end,
    desc = "Copy file reference with optional subcommand (line/file)"
  })
end

local function get_path()
  local path = vim.fn.expand("%:p")
  if path == "" then return nil end
  
  if M.config.use_git_root then
    local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
    if git_root ~= "" and vim.v.shell_error == 0 then
      -- Make path relative to git root
      if path:sub(1, #git_root) == git_root then
        path = path:sub(#git_root + 2)  -- Remove git root + slash
      end
    end
  else
    -- Make relative to cwd
    path = vim.fn.fnamemodify(path, ":.")
  end
  
  return path
end

function M.copy(include_lines)
  local path = get_path()
  if not path then
    vim.notify("No file to copy", vim.log.levels.WARN)
    return
  end
  
  local reference = path
  if include_lines ~= false then
    -- Check if in visual mode for range
    local mode = vim.api.nvim_get_mode().mode
    if mode:match("^[vV\022]") then
      local l1 = vim.fn.line("v")
      local l2 = vim.fn.line(".")
      local start_line = math.min(l1, l2)
      local end_line = math.max(l1, l2)
      reference = start_line == end_line 
        and (path .. ":" .. start_line)
        or (path .. ":" .. start_line .. "-" .. end_line)
      -- Exit visual mode
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    else
      reference = reference .. ":" .. vim.fn.line(".")
    end
  end
  
  vim.fn.setreg(M.config.register, reference)
  vim.notify("Copied: " .. reference)
end

return M