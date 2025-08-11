local M = {}

M.config = {
	-- Default options
	default_register = "+",
	relative_path = true,
	show_notification = true,
	-- Keymap configuration
	keymaps = {
		copy = "<leader>yr", -- Set to false to disable
	},
}

-- Forward declare for reference in setup
local setup_keymaps

-- Setup first for clarity
function M.setup(opts)
	M._setup_called = true
	M.config = vim.tbl_extend("force", M.config, opts or {})
	setup_keymaps()
end

local function get_path()
	local p
	if M.config.relative_path then
		p = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
	else
		p = vim.fn.expand("%:p")
	end
	return p
end

--- Copy a file reference
--- @param range table|nil Optional table { start = number, finish = number }
function M.copy_reference(range)
	local path = get_path()
	if not path or path == "" then
		if M.config.show_notification then
			vim.notify("No file associated with current buffer", vim.log.levels.WARN)
		end
		return
	end

	local start_line, end_line
	local mode = vim.fn.mode()
	local was_visual = mode:match("^[vV\022]") ~= nil
	if range and range.start and range.finish then
		start_line, end_line = range.start, range.finish
	else
		if was_visual then
			-- Visual mode selection
			local l1 = vim.fn.line("v")
			local l2 = vim.fn.line(".")
			start_line = math.min(l1, l2)
			end_line = math.max(l1, l2)
		else
			-- Normal mode: current line
			start_line = vim.fn.line(".")
			end_line = start_line
		end
	end

	local reference
	if start_line == end_line then
		reference = path .. ":" .. start_line
	else
		reference = path .. ":" .. start_line .. "-" .. end_line
	end

	vim.fn.setreg(M.config.default_register, reference)

	if M.config.show_notification then
		vim.notify("Copied: " .. reference, vim.log.levels.INFO)
	end

	-- Exit visual mode after copying, to mimic normal yank behavior
	if was_visual then
		local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
		vim.api.nvim_feedkeys(esc, "n", false)
	end
end

setup_keymaps = function()
	if M.config.keymaps.copy then
		vim.keymap.set({ "n", "v" }, M.config.keymaps.copy, function()
			M.copy_reference()
		end, { desc = "Copy file line reference", silent = true, nowait = true })
	end
end

-- Auto-setup with defaults if user doesn't call setup
vim.defer_fn(function()
	if not M._setup_called then
		M.setup({})
	end
end, 0)

return M
