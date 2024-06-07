local M = {}

local defaults = {
  options = {
    path = '.,**',
    swapfile = false,
    undofile = true,
    autowrite = true,
    autowriteall = true,
    gdefault = true,
    number = true,
    tabstop = 2,
    softtabstop = 2,
    shiftwidth = 2,
    expandtab = true,
    wrap = false,
    splitbelow = true,
    splitright = true,
    splitkeep = 'screen',
    signcolumn = 'yes',
    numberwidth = 3,
    statuscolumn = '%s%=%{v:lnum} ',
    cursorlineopt = 'number',
    updatetime = 300,
    diffopt = 'internal,filler,closeoff,context:3,indent-heuristic,algorithm:patience,linematch:60',
    shortmess = 'tonfFOxTcsiIl',
    showmode = false,
    cursorline = true,
    completeopt = 'menuone,noselect,noinsert',
    complete = '.,w,b,u,i',
    list = true,
    listchars = { lead = '⋅', trail = '⋅', tab = '▏ ', nbsp = '␣', precedes = '◀', extends = '▶' },
    fillchars = { eob = ' ', diff = ' ' },
    sessionoptions = 'buffers,curdir,tabpages,folds,winpos,winsize',
    wildmode = 'longest:full,full',
    pumheight = 5,
    grepprg = 'rg --color=never --vimgrep',
    grepformat = '%f:%l:%c:%m',
    statusline = ' %{mode()} | %t %m %r %= %c:%l/%L    %y',
  },

  global = {
    netrw_list_hide = '^./$,^../$',
    netrw_bufsettings = 'noma nomod nonu nobl nowrap ro nornu nocul scl=no',
    netrw_banner = 0,
    netrw_preview = 1,
    netrw_alto = 'spr',
    netrw_use_errorwindow = 0,
    netrw_special_syntax = 1,
    netrw_localcopydircmd = 'cp -r',
    netrw_localrmdir = 'rm -r',
  },
}

M.addopts = {}

function M.setup(addopts)
  M.addopts = vim.tbl_deep_extend('force', defaults, addopts or {})
  for set, value in pairs(M.addopts.global) do
    vim.g[set] = value
  end

  for set, value in pairs(M.addopts.options) do
    vim.opt[set] = value
  end
end

return M
