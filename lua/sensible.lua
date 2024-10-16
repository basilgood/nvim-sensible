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
    breakindent = true,
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
    listchars = 'lead:⋅,trail:⋅,tab:‣ ,nbsp:␣,extends:»,precedes:«',
    fillchars = 'eob: ,diff: ',
    sessionoptions = 'buffers,curdir,tabpages,folds,winpos,winsize',
    wildmode = 'longest:full,full',
    pumheight = 5,
    grepprg = 'rg --color=never --vimgrep',
    grepformat = '%f:%l:%c:%m',
    statusline = ' %{mode()} | %t %m %r %= %c:%l/%L    %y',
  },

  global = {
    netrw_list_hide = [[^\.\/$,^\.\.\/$]],
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

function M.setup(addopts)
  local opts = vim.tbl_deep_extend('force', defaults, addopts or {})
  M._apply_global_opts(opts.global)
  M._apply_local_opts(opts.options)
end

function M._apply_global_opts(global_opts)
  for key, value in pairs(global_opts) do
    vim.g[key] = value
  end
end

function M._apply_local_opts(local_opts)
  for key, value in pairs(local_opts) do
    vim.opt[key] = value
  end
end

return M
