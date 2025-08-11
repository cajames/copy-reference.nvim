if vim.g.loaded_copy_reference then
	return
end
vim.g.loaded_copy_reference = true

vim.api.nvim_create_user_command("CopyReference", function()
	require("copy-reference").copy_reference()
end, { range = true })
