# Keymaps

Leader is `<Space>`. Press `<leader>?` in nvim for the live, always-correct
version (which-key reads the real keymap table; this file can drift).

## Namespace ownership

Each prefix has exactly one owning file. If you add a keymap, put it in the file
that owns the prefix — that is what keeps this navigable.

| Prefix | Meaning | Owning file |
| --- | --- | --- |
| `<leader>f` | find / pickers | `lua/plugins/snacks.lua` |
| `<leader>g` | git | `lua/plugins/git.lua` |
| `<leader>h` | git hunks | `lua/plugins/git.lua` |
| `<leader>c` | code / LSP | `lua/lsp/attach.lua`, `lua/plugins/format.lua` |
| `<leader>x` | diagnostic lists | `lua/plugins/ui.lua` |
| `<leader>t` | toggles | `lua/config/keymaps.lua`, `lua/plugins/git.lua` |
| `<leader>r` | run tests | `lua/plugins/work.lua` |
| `<leader>b` | buffers | `lua/config/keymaps.lua` |
| `<leader>1`–`4`, `<leader>m` | harpoon | `lua/plugins/navigation.lua` |
| `<C-hjkl>` / `<A-hjkl>` | split + tmux pane nav / resize | `lua/plugins/navigation.lua` |
| bare `g*`, `K`, `]d` `[d` | LSP navigation | `lua/lsp/attach.lua` |

## Find — `<leader>f`

One picker: `snacks.picker`. Needs `ripgrep` and `fd` on PATH.

| Key | Action |
| --- | --- |
| `<leader><leader>` | smart find (buffers + recent + files) |
| `<leader>ff` | find files |
| `<leader>fg` | live grep |
| `<leader>fw` | grep word under cursor (also works on a visual selection) |
| `<leader>fb` | buffers |
| `<leader>fr` | recent files |
| `<leader>fl` | lines in current buffer |
| `<leader>fd` | diagnostics, workspace |
| `<leader>fs` | document symbols |
| `<leader>fS` | workspace symbols |
| `<leader>fh` | help tags |
| `<leader>fk` | keymaps |
| `<leader>fq` | quickfix list |
| `<leader>fR` | resume last picker |
| `<leader>fc` | find inside the nvim config |
| `<leader>e` | file explorer |
| `<leader>.` | scratch buffer |

## Code / LSP

Buffer-local — these only exist where a language server is attached, so `K` and
`gd` keep their built-in behaviour everywhere else.

| Key | Action |
| --- | --- |
| `K` | hover docs |
| `gd` | definition |
| `gr` | references |
| `gi` | implementation |
| `gy` | type definition |
| `gD` | declaration |
| `<leader>ca` | code action (normal + visual) |
| `<leader>cr` | rename symbol |
| `<leader>cd` | line diagnostics float |
| `<leader>cf` | format buffer |
| `]d` / `[d` | next / previous diagnostic |
| `<leader>th` | toggle inlay hints |
| `<leader>td` | toggle diagnostic virtual text |

## Diagnostic lists — `<leader>x`

| Key | Action |
| --- | --- |
| `<leader>xx` | diagnostics, workspace |
| `<leader>xb` | diagnostics, current buffer |
| `<leader>xs` | symbols outline |
| `<leader>xl` | LSP definitions / references |
| `<leader>xq` | quickfix list |
| `<leader>xL` | location list |

## Git — `<leader>g`

| Key | Action |
| --- | --- |
| `<leader>gg` | lazygit |
| `<leader>gs` | git status (fugitive) |
| `<leader>gc` | git commit |
| `<leader>gP` | git push |
| `<leader>gb` | blame current line |
| `<leader>gl` | git log |
| `<leader>gf` | git log for current file |
| `<leader>gd` | git diff (hunk picker) |
| `<leader>gB` | open current line on GitHub (normal + visual) |

## Git hunks — `<leader>h`

| Key | Action |
| --- | --- |
| `]h` / `[h` | next / previous hunk |
| `<leader>hs` | stage hunk (visual: stage selection) |
| `<leader>hr` | reset hunk (visual: reset selection) |
| `<leader>hS` | stage whole buffer |
| `<leader>hR` | reset whole buffer |
| `<leader>hu` | undo stage hunk |
| `<leader>hp` | preview hunk |
| `<leader>hd` | diff against index |
| `<leader>hD` | diff against last commit |
| `<leader>tb` | toggle inline blame |
| `ih` | hunk text object (e.g. `dih`, `vih`) |

Merge conflicts (git-conflict.nvim): `co` ours, `ct` theirs, `cb` both, `c0`
none, `]x` / `[x` navigate conflicts.

## Navigation

`<C-hjkl>` moves between nvim splits *and* tmux panes — the standard binding.
It requires the matching root-table bindings in `~/.config/tmux/tmux.conf`.

| Key | Action |
| --- | --- |
| `<C-h/j/k/l>` | move to split or tmux pane left/down/up/right |
| `<A-h/j/k/l>` | resize split |
| `<leader>m` | harpoon: mark current file |
| `<C-e>` / `<leader>M` | harpoon: menu |
| `<leader>1`–`<leader>4` | harpoon: jump to marked file |
| `]b` / `[b` | next / previous buffer |
| `<leader>bd` | delete buffer |
| `]q` / `[q` | next / previous quickfix item |

## Completion (insert mode)

blink.cmp, `enter` preset.

| Key | Action |
| --- | --- |
| `<CR>` | accept |
| `<Tab>` / `<S-Tab>` | jump forward / back in a snippet, else falls through to indent |
| `<C-n>` / `<C-p>`, `<Down>` / `<Up>` | select next / previous |
| `<C-space>` | show menu, then toggle documentation |
| `<C-k>` | toggle signature help |
| `<C-e>` | cancel |
| `<C-b>` / `<C-f>` | scroll documentation |

## Editing

| Key | Action |
| --- | --- |
| `<Esc>` | clear search highlight |
| `<leader>y` / `<leader>Y` | yank to system clipboard |
| `<leader>d` | delete without touching the register |
| `<leader>p` (visual) | paste over selection, keep register |
| `J` / `K` (visual) | move selection down / up and reindent |
| `<` / `>` (visual) | indent, keep selection |
| `<leader>o` / `<leader>O` | blank line below / above, cursor stays |
| `<leader>u` | undo tree |
| `gx` | open URL / issue / package under cursor |
| `<C-space>` (normal) | treesitter incremental selection |
| `<A-e>` (insert) | warp next closing pair past the cursor |
| `<leader>tw` / `<leader>ts` | toggle wrap / spell |

## Run tests — `<leader>r`

| Key | Action |
| --- | --- |
| `<leader>rf` | nearest test |
| `<leader>rb` | tests in file |
| `<leader>ra` | full suite |
| `<leader>rl` | re-run last |
| `<leader>rv` | visit last test file |

## Commands worth knowing

| Command | Action |
| --- | --- |
| `:Lazy` | plugin manager |
| `:Mason` | LSP / tool installer |
| `:ConformInfo` | which formatter applies to this buffer |
| `:FormatToggle` | toggle autoformat globally (`:FormatToggle!` for this buffer) |
| `:checkhealth` | diagnose a broken setup |
| `:A` | jump implementation ↔ test (work machines, Ruby) |
