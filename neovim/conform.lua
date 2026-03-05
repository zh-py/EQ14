require("conform").setup({
	formatters_by_ft = {
		markdown = { "prettier" },
		python = { "ruff_format" },
		nix = { "nixfmt" },
		lua = { "stylua" },
		json = { "prettier" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
	},
	formatters = {
		shfmt = {
			-- -i 2: Indent with 2 spaces
			-- -bn: Binary next line (for clean logic breaks)
			-- -ci: Indent switch cases
			prepend_args = { "-i", "2", "-bn", "-ci" },
		},
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
})
