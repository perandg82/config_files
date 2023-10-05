local function getWords()
  return tostring(vim.fn.wordcount().words)
end

require('lualine').setup {
	options = {
		section_separators = '',
		component_separators = '|',
		icons_enabled = false,
		theme = 'onedark',
	},
	sections = {
		lualine_a = {
			{
				'filename',
				path = 1,
			}
		},
		lualine_c = {},
		lualine_z = {
			{ getWords }
		},
	},
	inactive_sections = {
		lualine_c = {''},
	},
}
