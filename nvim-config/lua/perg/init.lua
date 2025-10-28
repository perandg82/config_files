-- autocommands
--- This function is taken from https://github.com/norcalli/nvim_utils
local function nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        vim.api.nvim_command('augroup '..group_name)
        vim.api.nvim_command('autocmd!')
        for _, def in ipairs(definition) do
            -- local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
            local command = table.concat(vim.iter({'autocmd', def}):flatten():totable(), ' ')
            vim.api.nvim_command(command)
        end
        vim.api.nvim_command('augroup END')
    end
end

local autocmds = {
    --change_header = {
        --{"BufWritePre", "?*", "lua changeheader()"}
    --};
    --packer = {
        --{ "BufWritePost", "plugins.lua", "PackerCompile" };
    --};
    terminal_job = {
        { "TermOpen", "*", [[tnoremap <buffer> <Esc> <c-\><c-n>]] };
        { "TermOpen", "*", "startinsert" };
        { "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" };
    };
    restore_cursor = {
        { 'BufRead', '*', [[call setpos(".", getpos("'\""))]] };
    };
    save_shada = {
        {"VimLeave", "*", "wshada!"};
    };
    resize_windows_proportionally = {
        { "VimResized", "*", ":wincmd =" };
    };
    toggle_search_highlighting = {
        { "InsertEnter", "*", "setlocal nohlsearch" };
    };
    -- lua_highlight = {
    --     { "TextYankPost", "*", [[silent! lua vim.highlight.on_yank() {higroup="IncSearch", timeout=400}]] };
    -- };
	--ansi_esc_log = {
	--{ "BufEnter", "*.log", ":AnsiEsc" };
	--};
}

nvim_create_augroups(autocmds)
-- autocommands END

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  desc = 'Hightlight selection on yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 400 }
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  group = vim.api.nvim_create_augroup("enable_active_cursorline", { clear = true }),
  callback = function()
    vim.wo.cursorline = true
  end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  group = vim.api.nvim_create_augroup("disable_inactive_cursorline", { clear = true }),
  callback = function()
    vim.wo.cursorline = false
  end,
})

require("perg.set")
require("perg.remap")
require("perg.lazyplugins")
require("perg.plugin_config")

