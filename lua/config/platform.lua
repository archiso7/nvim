-- Platform detection and the per-platform wiring that has to happen before
-- plugins load.
--
-- Required from init.lua and consumed by lua/lsp/servers.lua and
-- lua/plugins/work.lua, so platform checks are expressed once.

local uname = vim.uv.os_uname()

local M = {
  is_mac = uname.sysname == "Darwin",
  is_windows = uname.sysname:find("Windows") ~= nil,
  is_linux = uname.sysname == "Linux",
  is_wsl = false,
}

-- WSL reports sysname Linux; the kernel release carries the marker.
if M.is_linux then
  M.is_wsl = uname.release:lower():find("microsoft") ~= nil
    or vim.env.WSL_DISTRO_NAME ~= nil
end

M.is_tmux = vim.env.TMUX ~= nil

function M.setup()
  if M.is_wsl then
    -- The Linux clipboard tools are not connected to Windows'. win32yank
    -- handles both directions; clip.exe plus a PowerShell read is the
    -- no-install fallback.
    if vim.fn.executable("win32yank.exe") == 1 then
      vim.g.clipboard = {
        name = "win32yank",
        copy = {
          ["+"] = "win32yank.exe -i --crlf",
          ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
          ["+"] = "win32yank.exe -o --lf",
          ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = false,
      }
    elseif vim.fn.executable("clip.exe") == 1 then
      vim.g.clipboard = {
        name = "wsl-clip",
        copy = { ["+"] = "clip.exe", ["*"] = "clip.exe" },
        paste = {
          -- Strips the CR that PowerShell appends to every line.
          ["+"] = 'powershell.exe -NoProfile -Command Get-Clipboard | sed -e "s/\\r$//"',
          ["*"] = 'powershell.exe -NoProfile -Command Get-Clipboard | sed -e "s/\\r$//"',
        },
        cache_enabled = true,
      }
    end
  end

  if M.is_windows then
    -- cmd.exe cannot run the shell commands plugins expect. Prefer pwsh 7,
    -- fall back to the bundled PowerShell 5.
    local shell = vim.fn.executable("pwsh") == 1 and "pwsh"
      or (vim.fn.executable("powershell") == 1 and "powershell" or nil)
    if shell then
      vim.o.shell = shell
      vim.o.shellcmdflag =
        "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
      vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File -Encoding UTF8 %s; exit $LastExitCode'
      vim.o.shellpipe = '2>&1 | %%{ "$_" } | Out-File -Encoding UTF8 %s; exit $LastExitCode'
      vim.o.shellquote = ""
      vim.o.shellxquote = ""
    end

    -- Windows has no reliable equivalent and the default is a fork bomb risk
    -- on some setups.
    vim.o.shellslash = true
  end
end

return M
