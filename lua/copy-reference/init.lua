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

function M.copy_reference()
	local path
	if M.config.relative_path then
		path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
	else
		path = vim.fn.expand("%:p")
	end

	local line1 = vim.fn.line("v")
	local line2 = vim.fn.line(".")

	local reference
	if line1 == line2 then
		reference = path .. ":" .. line1
	else
		local start = math.min(line1, line2)
		local finish = math.max(line1, line2)
		reference = path .. ":" .. start .. "-" .. finish
	end

	vim.fn.setreg(M.config.default_register, reference)

	if M.config.show_notification then
		vim.notify("Copied: " .. reference, vim.log.levels.INFO)
	end
end

local function setup_keymaps()
	if M.config.keymaps.copy then
		vim.keymap.set({ "n", "v" }, M.config.keymaps.copy, function()
			M.copy_reference()
		end, { desc = "Copy file reference", silent = true })
	end
end

-- Auto-setup with defaults if user doesn't call setup
vim.defer_fn(function()
	if not M._setup_called then
		M.setup({})
	end
end, 0)

function M.setup(opts)
	M._setup_called = true
	M.config = vim.tbl_extend("force", M.config, opts or {})
	setup_keymaps()
end

return M
