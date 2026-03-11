local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
vim.lsp.set_log_level("error")
vim.lsp.config("*", {
	capabilities = capabilities,
})

-- Define all servers and their custom settings
local servers = {
	pyright = {
		cmd = { "pyright-langserver", "--stdio" },
		filetypes = { "python" },
		single_file_support = true,
		root_markers = {
			"pyrightconfig.json",
			"pyproject.toml",
			"setup.py",
			"setup.cfg",
			"requirements.txt",
			"Pipfile",
			".git",
		},
		before_init = function(params, config)
			if not config.root_dir then
				config.root_dir = vim.fn.expand("%:p:h")
			end
		end,

		settings = {
			pyright = {
				autoImportCompletion = true,
			},
			python = {
				analysis = {
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "openFilesOnly", -- safer for single files
					typeCheckingMode = "basic",
				},
			},
		},

		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false

			vim.keymap.set("n", "<F4>", function()
				require("dap").continue()
			end, { buffer = bufnr })
			vim.keymap.set("n", "<F6>", function()
				require("dap").restart()
			end, { buffer = bufnr })
			vim.keymap.set("n", "<F3>", function()
				require("dap").step_over()
			end, { buffer = bufnr })
			vim.keymap.set("n", "<F1>", function()
				require("dap").step_into()
			end, { buffer = bufnr })
			vim.keymap.set("n", "<F2>", function()
				require("dap").step_out()
			end, { buffer = bufnr })
			vim.keymap.set("n", "<leader>s", function()
				require("dap").terminate()
			end, { buffer = bufnr })
			vim.keymap.set("n", "<F8>", function()
				require("dap").toggle_breakpoint()
			end, { buffer = bufnr })
			vim.keymap.set("n", "<F9>", function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { buffer = bufnr })

			vim.keymap.set("n", "<leader>dp", function()
				require("dap").pause()
			end, { buffer = bufnr })
			vim.keymap.set("n", "<Leader>lp", function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, { buffer = bufnr })
			vim.keymap.set("n", "<leader>lb", function()
				require("dap").list_breakpoints()
			end, { buffer = bufnr })
			vim.keymap.set("n", "<leader>cb", function()
				require("dap").clear_breakpoints()
			end, { buffer = bufnr })
			vim.keymap.set("n", "<Leader>dr", function()
				require("dap").repl.toggle()
			end, { buffer = bufnr })
			vim.keymap.set("n", "<leader>du", function()
				require("dapui").toggle()
			end, { buffer = bufnr })
			vim.keymap.set("n", "<Leader>dl", function()
				require("dap").run_last()
			end, { buffer = bufnr })
			vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
				require("dap.ui.widgets").hover()
			end, { buffer = bufnr })
			vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
				require("dap.ui.widgets").preview()
			end, { buffer = bufnr })
			vim.keymap.set({ "n", "v" }, "<Leader>de", function()
				require("dapui").eval()
			end, { buffer = bufnr })
			vim.keymap.set("n", "<Leader>df", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.frames)
			end, { buffer = bufnr })
			vim.keymap.set("n", "<Leader>ds", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end, { buffer = bufnr })
		end,
	},

	pylsp = {
		cmd = { "pylsp" },
		filetypes = { "python" },
		single_file_support = true,
		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = true
			client.server_capabilities.documentRangeFormattingProvider = true
		end,
		settings = {
			pylsp = {
				plugins = {
					ruff = {
						enabled = true,
						formatEnabled = true,
						executable = "ruff",
						--config = "<path_to_custom_ruff_toml>",
						extendSelect = { "I" },
						extendIgnore = { "C90" },
						format = { "I" },
						severities = { ["D212"] = "I" },
						unsafeFixes = false,
						lineLength = 88,
						exclude = { "__about__.py" },
						select = { "F" },
						ignore = { "D210" },
						perFileIgnores = { ["__init__.py"] = "CPY001" },
						preview = false,
						targetVersion = "py310",
					},
				},
			},
		},
	},

	lua_ls = {
		cmd = { "lua-language-server" },

		filetypes = { "lua" },
		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = true
			client.server_capabilities.documentRangeFormattingProvider = true
		end,
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				format = {
					enable = true,
					defaultConfig = {
						indent_style = "space",
						indent_size = "8",
					},
				},
			},
		},
	},

	nil_ls = {
		cmd = { "nil" },
		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = true
			client.server_capabilities.documentRangeFormattingProvider = true
		end,
		filetypes = { "nix" },
		settings = {
			["nil"] = {
				formatting = { command = { "nixfmt" } },
			},
		},
	},

	jsonls = {
		cmd = { "vscode-json-languageserver", "--stdio" },
		filetypes = { "json", "jsonc" },
		root_markers = { "package.json", ".git" },
		single_file_support = true,
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},

	bashls = {
		cmd = { "bash-language-server", "start" },
		filetypes = { "sh", "bash", "zsh" },
		-- Native API keys (optional but good for consistency)
		root_markers = { ".git" },
		single_file_support = true,
	},

	marksman = {
		cmd = { "marksman" },
		filetypes = { "markdown" },
	},

	texlab = {
		cmd = { "texlab" },
		filetypes = { "tex", "plaintex" },
	},

	yamlls = {
		cmd = { "yaml-language-server", "--stdio" },
		filetypes = { "yaml", "yml" },
		root_markers = { ".git", ".yaml-cpp.json" },
		settings = {
			yaml = {
				validate = true,
				format = { tabWidth = 2 },
				schemaStore = {
					enable = true,
					url = "https://www.schemastore.org/api/json/catalog.json",
				},
			},
		},
	},

	harper_ls = {
		cmd = { "harper-ls", "--stdio" }, -- Native API prefers explicit stdio
		filetypes = {
			"markdown",
			"python",
			"rust",
			"javascript",
			"typescript",
			"go",
			"json",
			"toml",
			"lua",
			"tex",
			"plaintex",
		},
		root_markers = { ".git" },
		root_dir = vim.fn.getcwd(),
		settings = {
			["harper-ls"] = {
				userDictPath = "", -- Ensure this is a string, not nil
				ignoredLintsPath = "",
				linters = {
					SpellCheck = true,
					SpelledNumbers = false,
					SentenceCapitalization = true,
				},
			},
		},
	},
}

for name, config in pairs(servers) do
	vim.lsp.config(name, config)
end

-- Enable all servers
for name, _ in pairs(servers) do
	vim.lsp.enable(name)
end

--for name, opts in pairs(servers) do
--vim.api.nvim_create_autocmd("FileType", {
--pattern = opts.filetypes,
--callback = function(ev)
---- make sure cmd is defined!
--local cfg = vim.tbl_extend("force", {
--capabilities = lsp_capabilities,
--}, opts)

--if not cfg.cmd then
---- try to infer from system path if possible
--local bin = name
--if vim.fn.executable(bin) == 1 then
--cfg.cmd = { bin }
--else
--vim.notify("No LSP cmd found for " .. name, vim.log.levels.ERROR)
--return
--end
--end

--vim.lsp.start(cfg, { bufnr = ev.buf })
--end,
--})
--end

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", function()
	require("fzf-lua").diagnostics_document()
end)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", function()
			require("fzf-lua").lsp_declarations()
		end, opts)
		vim.keymap.set("n", "gd", function()
			require("fzf-lua").lsp_definitions()
		end, opts)
		vim.keymap.set("n", "K", function()
			local winid = vim.diagnostic.open_float(nil, { scope = "cursor", focus = false })
			if not winid then
				vim.lsp.buf.hover()
			end
		end, opts)
		vim.keymap.set("n", "gi", function()
			require("fzf-lua").lsp_implementations()
		end, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", function()
			require("fzf-lua").lsp_typedefs()
		end, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<space>ca", function()
			require("fzf-lua").lsp_code_actions()
		end, opts)
		vim.keymap.set("n", "gr", function()
			require("fzf-lua").lsp_references()
		end, opts)
	end,
})

vim.keymap.set("n", "<space>f", function()
	require("conform").format({
		lsp_fallback = true, -- If no conform formatter, try LSP
		async = true,
	})
end, { desc = "Format buffer (Conform/LSP)" })

require("lspkind").init({
	-- DEPRECATED (use mode instead): enables text annotations
	--
	-- default: true
	-- with_text = true,

	-- defines how annotations are shown
	-- default: symbol
	-- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
	mode = "symbol_text",

	-- default symbol map
	-- can be either 'default' (requires nerd-fonts font) or
	-- 'codicons' for codicon preset (requires vscode-codicons font)
	--
	-- default: 'default'
	preset = "codicons",

	-- override preset symbols
	--
	-- default: {}
	symbol_map = {
		Text = "󰉿",
		Method = "󰆧",
		Function = "󰊕",
		Constructor = "",
		Field = "󰜢",
		Variable = "󰀫",
		Class = "󰠱",
		Interface = "",
		Module = "",
		Property = "󰜢",
		Unit = "󰑭",
		Value = "󰎠",
		Enum = "",
		Keyword = "󰌋",
		Snippet = "",
		Color = "󰏘",
		File = "󰈙",
		Reference = "󰈇",
		Folder = "󰉋",
		EnumMember = "",
		Constant = "󰏿",
		Struct = "󰙅",
		Event = "",
		Operator = "󰆕",
		TypeParameter = "",
	},
})
