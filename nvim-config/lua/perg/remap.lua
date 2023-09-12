-- Functional wrapper for mapping custom keybindings
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = " "

-- Half page jumps
map("n", [[<C-d>]], [[<C-d>zz]])
map("n", [[<C-u>]], [[<C-u>zz]])
-- Keep search terms in middle of screen
map("n", [[n]], [[nzzzv]])
map("n", [[N]], [[Nzzzv]])
-- delete to void buffer, paste from buffer
map("x", [[<leader>r]], [["_dP]])
-- replace word under cursor
map("n", [[<leader>s]], [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Copy to clipboard
map("v", [[<leader>y]], [["+y]])
map("n", [[<leader>Y]], [["+yg_]])
map("v", [[<leader>y]], [["+y]])
map("n", [[<leader>yy]], [["+yy]])

-- Paste from clipboard
map("n", [[<leader>p]], [["+p]])
map("n", [[<leader>P]], [["+P]])
map("v", [[<leader>p]], [["+p]])
map("v", [[<leader>P]], [["+P]])

map("n", [[<F2>]], [[:tabprev<Cr>]])
map("n", [[<F3>]], [[:tabnext<Cr>]])
map("n", [[<F4>]], [[:tabnew<Cr>]])

map("n", [[<F1>]], [[<Esc>]])
map("i", [[<F1>]], [[<Esc>]])
