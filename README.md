# nvim-sensible

Better defaults for Neovim.

```lua
require('sensible').setup({
  options = {
    -- Regular assignment
    laststatus = 3,
    number = false,

    -- Append/prepend/remove operations
    diffopt = { append = 'algorithm:patience' },
    formatoptions = { remove = 'o' },
    shortmess = { append = 'I', remove = 'c' },
  },

  -- Globals are applied first (before options and autocmds)
  globals = {
    mapleader = ' ',
    maplocalleader = '\\',
  },
})
```
