# copy-reference.nvim

A simple Neovim plugin to copy file references with optional line numbers to your clipboard.

## Features

- Copy file path with line number (`file.lua:42`)
- Copy just the file path (`file.lua`)
- Smart path detection (relative to git root or cwd)
- Visual mode support for line ranges (`file.lua:10-25`)

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "cajames/copy-reference.nvim",
  opts = {}, -- optional configuration
  keys = {
    { "yr", "<cmd>CopyFileReference<cr>", mode = { "n", "v" }, desc = "Copy file path" },
    { "yrr", "<cmd>CopyReference<cr>", mode = { "n", "v" }, desc = "Copy file:line reference" },
  },
}
```

## Configuration

The plugin works out of the box with sensible defaults:

```lua
{
  register = "+",        -- Clipboard register (+ for system clipboard)
  use_git_root = true,   -- Use git root for relative paths when in a git repo
}
```

## Usage

- `yr` - Copy the current file path
- `yrr` - Copy the current file path with line number
- Visual mode + `yrr` - Copy file path with line range

## Commands

- `:CopyReference` - Copy file:line reference
- `:CopyFileReference` - Copy file path only

## License

MIT