-- place this in one of your configuration file(s)
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('n', '<leader>f', function()
  hop.hint_words()
end, { desc = '[F]ind any word in current buffer' })
