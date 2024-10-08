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
map("n", [[<leader>dp]], [["_diwp]], { desc = '[D]elete to void, [P]aste from buffer' } )
map("n", [[<leader>dP]], [["_diwP]], { desc = '[D]elete to void, [P]aste from buffer' } )
-- replace word under cursor
map("n", [[<leader>rw]], [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[R]ename [W]ord under cursor' })
vim.keymap.set('n', '<leader>cf', vim.diagnostic.open_float, { desc = 'Show floating warning' })
vim.keymap.set('n', '<leader>cd', function()
    local config = vim.diagnostic.config
    local vt = config().virtual_text
    config {
        virtual_text = not vt,
        underline = not vt,
        signs = not vt,
    }
end, { desc = "toggle diagnostic" })

-- change to _
map("n", [[c_]], [[ct_]])

-- Copy to clipboard
map("v", [[<leader>y]], [["+y]])
map("n", [[<leader>Y]], [["+yg_]])
map("v", [[<leader>y]], [["+y]])
map("n", [[<leader>yy]], [["+yy]])
map("n", [[<leader>yiw]], [["+yiw]])
map("n", [[<leader>yw]], [["+yw]])

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
vim.keymap.set({"n", "v", "o"}, "ø", "^")
vim.keymap.set({"n", "v", "o"}, "æ", "$")

map("n", [[<leader>|]], [[:vsplit<Cr>]])
map("n", [[<leader>-]], [[:split<Cr>]])
