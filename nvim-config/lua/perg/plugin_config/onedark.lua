local cfg = vim.g.onedark_config
require('onedark').setup {
    style = 'deep',
    colors = {
	grey = "#6c7d9c",
    },
    highlights = {
		CursorLine = {bg = "#304050"},
		MatchParen = {fg = "#ffffff", bg = "#6c7d9c"},
    },
}
require('onedark').load()
