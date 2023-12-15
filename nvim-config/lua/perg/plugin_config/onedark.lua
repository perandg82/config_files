local cfg = vim.g.onedark_config
require('onedark').setup {
    style = 'deep',
	highlights = {
		["@comment"] = {fg = "#6c7d9c"},
	}
}
require('onedark').load()
