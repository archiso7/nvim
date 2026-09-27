-- Buffer-local LSP keymaps, applied on LspAttach.
--
-- These used to be global, which meant `K` and `gd` were hijacked in every
-- buffer — including ones with no language server, where they shadowed the
-- built-in keywordprg lookup and local-declaration jump.
--
-- Namespace: <leader>c for code actions, bare g* for navigation.

local M = {}

-- snacks.picker gives a chooser when a symbol has several results; fall back to
-- the built-in handler when snacks is unavailable.
local function goto_with_picker(picker, builtin)
  return function()
    if package.loaded["snacks"] and Snacks.picker then
      Snacks.picker[picker]()
    else
      builtin()
    end
  end
end

function M.setup()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("cfg_lsp_attach", { clear = true }),
    callback = function(event)
      local buf = event.buf
      local client = vim.lsp.get_client_by_id(event.data.client_id)

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = "LSP: " .. desc })
      end

      map("n", "K", vim.lsp.buf.hover, "Hover docs")
      map("n", "gd", goto_with_picker("lsp_definitions", vim.lsp.buf.definition), "Definition")
      map("n", "gr", goto_with_picker("lsp_references", vim.lsp.buf.references), "References")
      map("n", "gi", goto_with_picker("lsp_implementations", vim.lsp.buf.implementation), "Implementation")
      map("n", "gy", goto_with_picker("lsp_type_definitions", vim.lsp.buf.type_definition), "Type definition")
      map("n", "gD", vim.lsp.buf.declaration, "Declaration")

      map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
      map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
      map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")

      -- ] is forward and [ is backward, per vim convention. The previous
      -- config had these two swapped.
      map("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, "Next diagnostic")
      map("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, "Prev diagnostic")

      if client and client:supports_method("textDocument/documentHighlight") then
        local hl_group = vim.api.nvim_create_augroup("cfg_lsp_highlight_" .. buf, { clear = true })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = buf,
          group = hl_group,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = buf,
          group = hl_group,
          callback = vim.lsp.buf.clear_references,
        })
      end

      if client and client:supports_method("textDocument/inlayHint") then
        map("n", "<leader>th", function()
          local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
          vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
        end, "Toggle inlay hints")
      end
    end,
  })

  vim.api.nvim_create_autocmd("LspDetach", {
    group = vim.api.nvim_create_augroup("cfg_lsp_detach", { clear = true }),
    callback = function(event)
      pcall(vim.api.nvim_del_augroup_by_name, "cfg_lsp_highlight_" .. event.buf)
    end,
  })
end

return M
