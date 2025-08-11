# copy-reference.nvim

A lightweight Neovim plugin to copy file references with line numbers to your clipboard. Great for sharing exact code locations with AI agents.

## Features

- Copy current line reference (e.g., `lua/config.lua:42`)
- Visual selection support for ranges (e.g., `src/main.rs:10-25`)
- Supports command ranges (e.g., `:10,20CopyReference`)
- Zero-config defaults with simple customizatiok

## Installation

### lazy.nvim

```lua
-- Minimal setup (uses defaults)
{
  "cajames/copy-reference.nvim",
  lazy = false,
}

-- Or with custom options
{
  "cajames/copy-reference.nvim",
  lazy = false,
  opts = {
    -- your custom options here
  },
}
```

### packer.nvim

```lua
use {
  'cajames/copy-reference.nvim',
  config = function()
    require('copy-reference').setup()
  end
}
```

## Usage

- Normal mode: `<leader>yr` — copy reference for the current line
- Visual mode: select lines, then `<leader>yr` — copy range reference
- Command: `:CopyReference` — respects visual selection if active
- Command with explicit range: `:10,20CopyReference` — copies `…:10-20`

The copied value goes to the configured register (default `+` for system clipboard). By default, a notification is shown after copying.

## Configuration

Default options:

```lua
require('copy-reference').setup({
  -- Clipboard register ('+' for system clipboard)
  default_register = "+",

  -- Use relative path from project root / cwd
  relative_path = true,

  -- Show notification when copying
  show_notification = true,

  -- Keybindings (set to false to disable)
  keymaps = {
    copy = "<leader>yr",
  },
})
```

Notes:

- If the current buffer has no associated file, the plugin will warn and do nothing.
- For absolute paths, set `relative_path = false`.

## Requirements

- Neovim >= 0.7.0
- Clipboard provider if using the system clipboard (e.g., `xclip`/`xsel` on Linux, `pbcopy` on macOS).

## Troubleshooting

- Clipboard not working? Check `:checkhealth provider` and ensure a clipboard provider is available on your system.

## License

MIT — see LICENSE.
