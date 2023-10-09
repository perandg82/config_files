require("nvim-tmux-navigation").setup({
	tmux_navigator_save_on_switch = 'update',
	keybindings = {
		left = "<C-h>",
		down = "<C-j>",
		up = "<C-k>",
		right = "<C-l>",
		last_active = "<C-\\>",
	},
})
vim.keymap.set('n', '<C-h>', ":NvimTmuxNavigateLeft<CR>", { desc = 'Navigate Left' })
vim.keymap.set('n', '<C-l>', ":NvimTmuxNavigateRight<CR>", { desc = 'Navigate Right' })
vim.keymap.set('n', '<C-j>', ":NvimTmuxNavigateDown<CR>", { desc = 'Navigate Down' })
vim.keymap.set('n', '<C-k>', ":NvimTmuxNavigateUp<CR>", { desc = 'Navigate Up' })
vim.keymap.set('n', '<C-\\>', ":NvimTmuxNavigateLastActive<CR>", { desc = 'Navigate Up' })

