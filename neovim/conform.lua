require("conform").setup({
	formatters_by_ft = {
		markdown = { "prettier" },
		python = { "ruff_format" },
		nix = { "nixfmt" },
		lua = { "stylua" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
})
