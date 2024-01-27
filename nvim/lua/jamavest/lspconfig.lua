local M = {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{
			"folke/neodev.nvim",
		},
	},
}

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(bufnr, "n", "<leader>K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap(bufnr, "n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	keymap(bufnr, "n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  keymap(bufnr, "n", "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap(bufnr, "n", "<leader>]", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	keymap(bufnr, "n", "<leader>[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	keymap(bufnr, "n", "<leader>gf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
	keymap(bufnr, "n", "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)

	-- if client.supports_method("textDocument/inlayHint") then
	-- 	vim.lsp.inlay_hint.enable(bufnr, true)
	-- end
end

function M.common_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	return capabilities
end

-- M.toggle_inlay_hints = function()
-- 	local bufnr = vim.api.nvim_get_current_buf()
-- 	vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
-- end

function M.config()
	local lspconfig = require("lspconfig")
	local icons = require("jamavest.icons")

	local servers = {
		"lua_ls",
		"cssls",
		"html",
		"tsserver",
		"eslint",
		"tsserver",
		"pyright",
		"bashls",
		"jsonls",
		"yamlls",
	}

	local default_diagnostic_config = {
		signs = {
			active = true,
			values = {
				{ name = "DiagnosticSignError", text = icons.diagnostics.Error },
				{ name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
				{ name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
				{ name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
			},
		},
		virtual_text = true,
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(default_diagnostic_config)

	for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
	end

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] =
		vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
	require("lspconfig.ui.windows").default_options.border = "rounded"

	for _, server in pairs(servers) do
		local opts = {
			on_attach = M.on_attach,
			capabilities = M.common_capabilities(),
      inlay_hints = {enabled = true}
		}

		local require_ok, settings = pcall(require, "jamavest.lspsettings." .. server)
		if require_ok then
			opts = vim.tbl_deep_extend("force", settings, opts)
		end

		if server == "lua_ls" then
			require("neodev").setup({})
		end

		lspconfig[server].setup(opts)
	end
end

return M
