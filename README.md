# copy-reference.nvim

A lightweight Neovim plugin to copy file references with line numbers to your clipboard. Perfect for sharing code locations in documentation, issues, or chat or with AI code agents.

Note: this project is a work in progress and made just for fun.

## ✨ Features

- 📋 **Copy file references** with line numbers (e.g., `lua/config.lua:42`)
- 🎯 **Visual mode support** for ranges (e.g., `src/main.rs:10-25`)
- 🔧 **Zero config required** - works out of the box
- ⚙️ **Fully customizable** - paths, keymaps, and behavior
- 📦 **Lightweight** - minimal dependencies, pure Lua
- 🚀 **LazyVim ready** - first-class lazy loading support

## 📦 Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

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

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'cajames/copy-reference.nvim',
  config = function()
    require('copy-reference').setup()
  end
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'cajames/copy-reference.nvim'

" Then somewhere in your config:
lua require('copy-reference').setup()
```

## 🚀 Usage

### Default Keybindings

- **Normal mode**: `<leader>yr` - Copy current line reference
- **Visual mode**: Select lines, then `<leader>yr` - Copy range reference

### Commands

- `:CopyReference` - Copy reference for current line or selection

### Examples

1. Place cursor on line 42 in `lua/plugins/init.lua`, press `<leader>yr`
   - Copies: `lua/plugins/init.lua:42`

2. Visual select lines 10-25 in `src/main.rs`, press `<leader>yr`
   - Copies: `src/main.rs:10-25`

## ⚙️ Configuration

### Default Options

```lua
require('copy-reference').setup({
  -- Clipboard register ('+' for system clipboard)
  default_register = "+",
  
  -- Use relative path from project root
  relative_path = true,
  
  -- Show notification when copying
  show_notification = true,
  
  -- Keybindings (set to false to disable)
  keymaps = {
    copy = "<leader>yr",
  },
})
```

### Configuration Examples

#### Change keybinding

```lua
{
  "cajames/copy-reference.nvim",
  lazy = false,
  opts = {
    keymaps = {
      copy = "<leader>cp",  -- Use <leader>cp instead
    },
  },
}
```

#### Use absolute paths

```lua
{
  "cajames/copy-reference.nvim",
  lazy = false,
  opts = {
    relative_path = false,  -- Use full absolute paths
  },
}
```

#### Disable default keymaps (set your own)

```lua
{
  "cajames/copy-reference.nvim",
  opts = {
    keymaps = {
      copy = false,  -- Don't create default keymaps
    },
  },
  keys = {
    -- Define your own keymaps
    { "<C-y>", "<cmd>lua require('copy-reference').copy_reference()<cr>", 
      mode = { "n", "v" }, desc = "Copy reference" },
  },
}
```

#### Use different register

```lua
{
  "cajames/copy-reference.nvim",
  lazy = false,
  opts = {
    default_register = '"',  -- Use unnamed register instead of clipboard
  },
}
```

#### Silent mode (no notifications)

```lua
{
  "cajames/copy-reference.nvim",
  lazy = false,
  opts = {
    show_notification = false,  -- Don't show "Copied: ..." message
  },
}
```

## 🔧 API

You can also use the plugin programmatically:

```lua
-- Copy reference for current line/selection
require('copy-reference').copy_reference()

-- With temporary options override
local copy_ref = require('copy-reference')
local original_config = vim.deepcopy(copy_ref.config)
copy_ref.config.relative_path = false
copy_ref.copy_reference()
copy_ref.config = original_config
```

## 🤝 Integration with Other Plugins

### [which-key.nvim](https://github.com/folke/which-key.nvim)

```lua
require('which-key').register({
  ["<leader>y"] = {
    name = "Yank/Copy",
    r = { "<cmd>lua require('copy-reference').copy_reference()<cr>", "Copy Reference" },
  },
})
```

### [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) Integration

You can create a custom picker to copy references from search results:

```lua
vim.keymap.set("n", "<leader>fr", function()
  require('telescope.builtin').live_grep({
    attach_mappings = function(_, map)
      map("i", "<C-y>", function(prompt_bufnr)
        local entry = require("telescope.actions.state").get_selected_entry()
        local reference = entry.filename .. ":" .. entry.lnum
        vim.fn.setreg("+", reference)
        vim.notify("Copied: " .. reference)
      end)
      return true
    end,
  })
end, { desc = "Find and copy reference" })
```

## 🎯 Use Cases

- **Code Reviews**: Share exact file locations in PR comments
- **Documentation**: Reference specific code in your docs
- **Issue Reports**: Point to exact problem locations
- **Team Communication**: Share code locations in Slack/Discord
- **Note Taking**: Save code references in your notes

## 📝 Requirements

- Neovim >= 0.7.0
- Clipboard support (optional, for system clipboard integration)

## 🐛 Troubleshooting

### Clipboard not working?

Make sure you have clipboard support:

```vim
:checkhealth provider
```

For system clipboard support, you might need:

- **Linux**: `xclip` or `xsel`
- **macOS**: `pbcopy` (built-in)
- **Windows**: Built-in
- **WSL**: `win32yank` or `clip.exe`

### Relative paths not working as expected?

The plugin uses Neovim's path resolution. Make sure you're in the project root or set up your working directory correctly:

```lua
-- In your config
vim.cmd('cd ' .. vim.fn.getcwd())
```

## 🤝 Contributing

Contributions are welcome! Feel free to:

- 🐛 Report bugs
- 💡 Suggest new features
- 🔧 Submit pull requests

## 📄 License

MIT License - See [LICENSE](LICENSE) for details

## 🙏 Acknowledgments

- Inspired by VSCode's "Copy Relative Path" feature
- Built with the Neovim Lua API

## 📮 Support

If you find this plugin useful, consider:

- ⭐ Starring the repository
- 🐛 Reporting issues
- 💬 Sharing with others

---

Made with ❤️ for the Neovim community
