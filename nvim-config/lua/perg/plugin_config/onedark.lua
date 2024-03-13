local cfg = vim.g.onedark_config
require('onedark').setup {
    style = 'deep',
    colors = {
	grey = "#6c7d9c",
    },
    highlights = {
	MatchParen = {fg = "#ffffff", bg = "#6c7d9c"},
    },
}
require('onedark').load()
