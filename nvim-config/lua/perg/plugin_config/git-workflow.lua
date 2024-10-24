require('git-worktree').setup()
require('telescope').load_extension('git_worktree')

vim.keymap.set("n", "<leader>sw", "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", { desc = 'See all worktrees' })
vim.keymap.set("n", "<leader>sW", "<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", { desc = 'Create a worktree' })

