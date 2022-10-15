local M = {}

local success_lspconfig, lspconfig = pcall(require, "lspconfig")
if not success_lspconfig then
  return
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true, buffer=bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  -- vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

local on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
end

local success, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not success then
  return
end

local capabilities = cmp_nvim_lsp.default_capabilities()

local success_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if not success_mason_lspconfig then
  return
end

M.setup = function ()
  local signs = {
    Error = "",
    Warn = "",
    Hint = "",
    Info = "",
  }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  local config = {
    virtual_text = false,
    -- update_in_insert = true,
    severity_sort = true,
    signs = true,
    underline = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }
  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  mason_lspconfig.setup()
  mason_lspconfig.setup_handlers({
    function (server_name) -- default handler
      lspconfig[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }
    end,
    ["sumneko_lua"] = function ()
      lspconfig.sumneko_lua.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = require("user.lsp.settings.sumneko_lua")
      }
    end
  })
end

return M
