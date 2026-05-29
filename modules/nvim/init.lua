-- vim: foldmethod=marker foldlevel=0

-- Options {{{
---@diagnostic disable: undefined-global
vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.have_nerd_font = true
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.inccommand = "split"
vim.opt.winborder = "rounded"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.showtabline = 2
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.foldmethod = "indent"
vim.opt.foldtext = ""
vim.opt.foldnestmax = 4
vim.opt.foldlevel = 99
vim.loader.enable() -- Lua bytecode cache for faster startup
-- }}}

-- Theme {{{
require("ayu").setup({
	mirage = false,
	terminal = true,
	overrides = {},
})
vim.cmd.colorscheme("ayu-dark")
-- Make line numbers more visable
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5c6773" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff8f40", bold = true })

require("lualine").setup()
-- }}}

-- Window management {{{
local win_keybinds = {
	["<C-h>"] = "<C-w>h",
	["<C-j>"] = "<C-w>j",
	["<C-k>"] = "<C-w>k",
	["<C-l>"] = "<C-w>l",
}
for key, cmd in pairs(win_keybinds) do
	vim.keymap.set({ "v", "n" }, key, cmd, { noremap = true, silent = true })
	vim.keymap.set("t", key, "<C-\\><C-n>" .. cmd, { noremap = true, silent = true })
end
vim.keymap.set(
	"n",
	"<C-w>y",
	":windo setlocal scrollbind! cursorbind!<CR>",
	{ desc = "S[y]nc cursor and scroll of splits in a window" }
)
-- }}}

-- Harpoon & Tabline {{{
local harpoon = require("harpoon")
harpoon:setup()

function Harpoon_tabline()
	local contents = {}
	local list = harpoon:list()
	local current_file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")

	for index = 1, list:length() do
		local file = list:get(index)
		if file then
			local harpoon_path = file.value
			-- Grab just the file name (tail) instead of the full path
			local file_name = harpoon_path == "" and "(empty)" or vim.fn.fnamemodify(harpoon_path, ":t")
			-- Highlight the tab if it matches the current active buffer
			if current_file_path == harpoon_path then
				contents[index] = string.format(" %%#TabLineSel# %d. %s ", index, file_name)
			else
				contents[index] = string.format(" %%#TabLine# %d. %s ", index, file_name)
			end
		end
	end
	return table.concat(contents) .. "%#TabLineFill#"
end
vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "User" }, {
	callback = function()
		vim.o.tabline = Harpoon_tabline()
	end,
})

vim.keymap.set({ "t", "n" }, "<M-a>", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<C-w>m", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)
vim.keymap.set({ "t", "n" }, "<M-1>", function()
	harpoon:list():select(1)
end)
vim.keymap.set({ "t", "n" }, "<M-2>", function()
	harpoon:list():select(2)
end)
vim.keymap.set({ "t", "n" }, "<M-3>", function()
	harpoon:list():select(3)
end)
vim.keymap.set({ "t", "n" }, "<M-4>", function()
	harpoon:list():select(4)
end)
-- }}}

-- Quality of Life {{{
vim.cmd([[
  ca Q q
  ca Qa qa
  ca W w
  ca Wa wa
  ca Wq wq
  nnoremap q: <nop>
]])
vim.keymap.set({ "v", "n" }, "<leader>y", [["+y]])
vim.keymap.set({ "v", "n" }, "<leader>p", [["+p]])
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("v", "<", "<gv", { silent = true, desc = "Dedent and stay in visual mode" })
vim.keymap.set("v", ">", ">gv", { silent = true, desc = "Indent and stay in visual mode" })
vim.keymap.set("n", "s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "[s]earch and replace" })

vim.keymap.set("n", "gy", function()
	vim.fn.setreg("a", "")
	vim.cmd([[silent! %s//\=setreg('a', submatch(0) . "\n", 'a')/gn]])
	vim.fn.setreg("+", vim.fn.getreg("a"))
end, { desc = "Yank search matches to clipboard" })

vim.keymap.set("n", "<leader>=", function()
	local buf = vim.api.nvim_get_current_buf()
	local view = vim.fn.winsaveview()

	local steps = {
		[[keepjumps sil! %s/\r//ge]],
		[[keepjumps sil! %s/[{}]/\r\0\r/ge]],
		[[keepjumps sil! %s/;/\0\r/ge]],
		[[keepjumps sil! %s/\s\+$//e]],
		[[keepjumps sil! %s/\n\{3,}/\r\r/e]],
	}
	vim.api.nvim_buf_call(buf, function()
		for _, step in ipairs(steps) do
			vim.api.nvim_exec2(step, { output = false })
		end
		vim.cmd("normal! gg=G")
	end)

	vim.fn.winrestview(view)
	vim.notify("Formatted", vim.log.levels.INFO)
end, { desc = "Format any file without LSP" })
-- }}}

-- Auto commands {{{
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "Highlight when copying text",
})
-- Markdown settings
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.breakindent = true
		vim.opt_local.showbreak = "↳ "
		vim.opt_local.smoothscroll = true
		vim.opt_local.signcolumn = "no"
		vim.opt_local.foldcolumn = "0"
		vim.opt_local.cursorline = false
		vim.opt_local.relativenumber = false

		local opts = { buffer = true, silent = true }
		vim.keymap.set({ "n", "v" }, "j", "gj", opts)
		vim.keymap.set({ "n", "v" }, "k", "gk", opts)
		vim.keymap.set({ "n", "v" }, "H", "g^", opts)
		vim.keymap.set({ "n", "v" }, "L", "g$", opts)
	end,
})
-- }}}

-- Git signs {{{
require("gitsigns").setup({
	current_line_blame = true,
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")
		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end
		-- Navigation
		map({ "v", "n" }, "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map({ "v", "n" }, "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)

		-- Actions
		map("n", "<leader>gc", gitsigns.preview_hunk_inline)
		map("n", "<leader>gr", gitsigns.reset_hunk)

		-- Text object
		map({ "o", "x" }, "ih", gitsigns.select_hunk)
		map({ "o", "x" }, "ah", gitsigns.select_hunk)
	end,
})
-- }}}

-- File explorer {{{
require("mini.files").setup({
	mappings = {
		close = "<esc>",
		synchronize = "s",
		go_in_plus = "<CR>",
	},
	windows = {
		preview = true,
		width_preview = 50,
	},
})
vim.keymap.set("n", "<leader>e", function()
	require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
end)
vim.keymap.set("n", "<leader>o", ":Open .<CR>")
-- }}}

-- Snacks {{{
-- Make picker preview wider
local layouts = require("snacks.picker.config.layouts")
layouts["wider_preview"] = vim.tbl_deep_extend("force", layouts["default"], {
	layout = {
		box = "horizontal",
		width = 0.9,
		height = 0.8,
		{ win = "list", width = 0.3 },
		{ win = "preview", width = 0.7 },
	},
})
require("snacks").setup({
	input = { enabled = true },
	bigfile = { enabled = true },
	quickfile = { enabled = true },
	picker = {
		enabled = true,
		layout = { preset = "wider_preview" },
		sources = {
			explorer = {
				layout = {
					preset = "sidebar",
					layout = {
						position = "left",
						width = 25,
					},
				},
			},
		},
	},
	terminal = {
		win = {
			style = "terminal",
			wo = {
				winbar = "",
			},
			keys = {
				term_normal = false,
			},
		},
	},
	notifier = { enabled = true },
	scope = { enabled = true },
	words = { enabled = true },
	indent = { enabled = true },
	scroll = { enabled = true },
	zen = {
		win = { backdrop = { transparent = false, blend = 0 } },
		toggles = { dim = false },
		show = { statusline = true },
	},
	styles = { snacks_image = { relative = "editor", col = -1 } },
	image = { enabled = true, doc = { inline = false } },
})
-- Pickers
vim.keymap.set("n", "<leader>/", function()
	Snacks.picker.grep()
end)
-- File fuzzy find
vim.keymap.set("n", "<leader><leader>", function()
	Snacks.picker.git_files()
end)
vim.keymap.set("n", "<leader>b", function()
	Snacks.picker.buffers()
end)
vim.keymap.set("n", "<leader>t", function()
	Snacks.explorer()
end)
-- All pickers
vim.keymap.set("n", "<C-p>", function()
	Snacks.picker.pickers()
end)
-- Undo history
vim.keymap.set("n", "<leader>u", function()
	Snacks.picker.undo()
end)
-- Git
vim.keymap.set("n", "<leader>gd", function()
	Snacks.picker.git_diff()
end)
-- Open current file in GitHub
vim.keymap.set("n", "<leader>gh", function()
	Snacks.gitbrowse()
end)
-- Open temp buffer
vim.keymap.set("n", "<C-w>t", function()
	Snacks.scratch.open()
end)
-- Zen mode toggles {{{
-- Dim
Snacks.toggle.dim():map("<leader>zd", { desc = "Zen (Dim)" })

-- Zoom
Snacks.toggle
	.new({
		id = "zen_zoom",
		name = "Zen (Zoom)",
		get = function()
			return Snacks.zen.win and Snacks.zen.win:valid()
		end,
		set = function()
			Snacks.zen.zoom()
		end,
	})
	:map("<leader>zz", { desc = "Zen (Zoom)" })

-- Center
Snacks.toggle
	.new({
		id = "zen_center",
		name = "Zen (Center)",
		get = function()
			return Snacks.zen.win and Snacks.zen.win:valid()
		end,
		set = function()
			Snacks.zen({
				toggles = { dim = false, diagnostics = false, git_signs = false },
			})
		end,
	})
	:map("<leader>zm", { desc = "Zen (Center)" })

-- Zen All Features
Snacks.toggle
	.new({
		id = "zen_all",
		name = "Zen (All)",
		get = function()
			return Snacks.zen.win and Snacks.zen.win:valid()
		end,
		set = function()
			Snacks.zen({
				toggles = { dim = true, git_signs = true, diagnostics = true },
			})
		end,
	})
	:map("<leader>za", { desc = "Zen (All)" })
-- Diagnostics toggle
Snacks.toggle.diagnostics():map("<leader>h")
-- }}}
-- }}}

-- Terminal {{{
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])
-- Always insert
vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter", "BufEnter" }, {
	pattern = "term://*",
	callback = function()
		vim.cmd("startinsert")
	end,
})

-- Set runner command
vim.api.nvim_create_user_command("SetRunner", function()
	Snacks.input({
		prompt = "Set Code Runner Command: ",
		default = vim.g.CodeRunner or ("./" .. vim.fn.expand("%")),
	}, function(value)
		if value and value ~= "" then
			vim.g.CodeRunner = value
			vim.notify("Code Runner set to: " .. value)
		end
	end)
end, { desc = "Set Code Runner command" })

-- Run runner command
vim.keymap.set("n", "<c-w><CR>", function()
	if not vim.g.CodeRunner or vim.g.CodeRunner == "" then
		vim.cmd("SetRunner")
	else
		Snacks.terminal(vim.g.CodeRunner, { interactive = false })
	end
end, { desc = "Run Code!" })

vim.keymap.set("n", "<c-w>c", function()
	local term = Snacks.terminal.toggle("opencode -c", {
		id = "opencode",
		win = { position = "right", width = 0.4 },
	})
	-- Rename the buffer
	if term and term.buf then
		pcall(vim.api.nvim_buf_set_name, term.buf, "opencode")
	end
end, { desc = "Open Code!" })

vim.keymap.set({ "t", "n" }, "<C-Space>", function()
	Snacks.terminal.toggle(nil, {
		id = "quick_term",
		win = {
			style = "float",
			width = 0.8,
			height = 0.8,
			border = "rounded",
		},
	})
end, { desc = "Quick floating terminal" })
-- }}}

-- LSP setup {{{
vim.lsp.config("*", {
	root_markers = { ".git" },
})

local caps = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config["nil_ls"] = {
	cmd = { "nil" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", "shell.nix", ".git" },
	capabilities = caps,
}

vim.lsp.config["pyright"] = {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", ".git" },
	capabilities = caps,
}

vim.lsp.config["gopls"] = {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.mod", "go.work", ".git" },
	capabilities = caps,
}

vim.lsp.config["html"] = {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "templ" },
	root_markers = { "package.json", ".git" },
	capabilities = caps,
}

vim.lsp.config["jsonls"] = {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	root_markers = { "package.json", ".git" },
	capabilities = caps,
}

vim.lsp.config["ts_ls"] = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
	capabilities = caps,
}

for name, _ in pairs(vim.lsp.config._configs) do
	if name ~= "*" then
		vim.lsp.enable(name)
	end
end
-- }}}

-- Completion {{{
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<c-space>"] = cmp.mapping.complete(),
		["<tab>"] = cmp.mapping.confirm({ select = true }),
		["<c-n>"] = cmp.mapping.select_next_item(),
		["<c-p>"] = cmp.mapping.select_prev_item(),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
	}),
})
-- }}}

-- Tree-sitter setup {{{
require("treesitter-context").setup()
require("nvim-treesitter.install").prefer_git = true
require("nvim-treesitter.install").compilers = { "zig", "gcc" }
require("nvim-treesitter").setup({
	parser_install_dir = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/",
	auto_install = false,
	highlight = {
		enable = true,
	},
	indent = { enable = true },
})
local group = vim.api.nvim_create_augroup("ThePrimeagenTreesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function()
		if vim.bo.buftype ~= "" then
			return
		end
		if vim.fn.getfsize(vim.fn.bufname()) > 1000000 then
			return
		end
		local success = pcall(vim.treesitter.start, 0)
		if success then
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		end
	end,
})
-- Syntax highlight for todo.txt files
vim.filetype.add({
	pattern = {
		["todo.txt"] = "todotxt",
	},
})
-- }}}

-- Conform {{{
require("conform").setup({
	notify_on_error = false,
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		go = { "gopls" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
})
vim.keymap.set("n", "<leader>l", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end)
-- }}}
