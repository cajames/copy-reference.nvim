if vim.g.loaded_copy_reference then
	return
end
vim.g.loaded_copy_reference = true

vim.api.nvim_create_user_command("CopyReference", function(opts)
	local range
	if opts.range == 2 and opts.line1 and opts.line2 then
		range = { start = opts.line1, finish = opts.line2 }
	end
	require("copy-reference").copy_reference(range)
end, { range = true })
