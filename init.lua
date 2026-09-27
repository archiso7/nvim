-- Entry point.
--
-- Load order is significant: options.lua sets `mapleader`, which must happen
-- before lazy.nvim resolves plugin `keys` specs.
--
-- Layout:
--   lua/config/   editor settings that do not depend on plugins
--   lua/lsp/      language-server data and attach behaviour
--   lua/plugins/  one file per concern, each owning a keymap namespace
--
-- Keymap reference: see KEYMAPS.md

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
