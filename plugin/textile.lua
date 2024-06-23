-- filetype
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.tt",
	callback = function()
		vim.bo.filetype = "textile"
	end,
})

-- highlight
vim.api.nvim_create_augroup("textile-highlight", {})
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter" }, {
	group = "textile-highlight",
	pattern = { "*" },
	command = [[
	call matchadd('TextileHeader', 'h\d\+\. .\+')
	call matchadd('TextileParagraph', 'p.\. .\+')
	call matchadd('TextileList', '^*\+ ')
	]],
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	group = "textile-highlight",
	pattern = { "*" },
	command = [[
	highlight default TextileHeader ctermfg=11 guifg=orange
	highlight default TextileParagraph ctermfg=11 guifg=orange
	highlight default TextileList ctermfg=4 guifg=skyblue
	]],
})

-- lsp
local handle = io.popen("command -v textilels")
local result = handle:read("*a")
handle:close()

if result == "" then
	-- print("textilels is not installed")
	return
end

local lspconfig = require("lspconfig")
if not lspconfig then
	-- print("nvim-lspconfig is not installed")
	return
end
local configs = require("lspconfig.configs")

if not configs.textilels then
	configs.textilels = {
		default_config = {
			-- cmd = { "nargo", "lsp" },
			cmd = { "textilels" },
			-- cmd = { "python", "/home/arakkk/Downloads/lsp-textile/pygls/lsp-textile.py" },
			root_dir = lspconfig.util.root_pattern("*"),
			-- root_dir = vim.fn.getcwd(), -- Use PWD as project root dir.
			filetypes = { "textile" },
		},
	}
end
lspconfig.textilels.setup({})
