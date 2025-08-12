local M = {}

local function get_options()
  return {
    autowrite = true,
    autowriteall = true,
    breakindent = true,
    complete = '.,w,b,u,i',
    completeopt = 'menuone,noselect,noinsert',
    cursorline = true,
    cursorlineopt = 'number',
    diffopt = 'internal,filler,closeoff,context:3,indent-heuristic,algorithm:patience,linematch:60',
    expandtab = true,
    fillchars = 'eob: ,diff: ',
    gdefault = true,
    grepformat = '%f:%l:%c:%m',
    grepprg = 'rg --color=never --vimgrep',
    list = false,
    listchars = 'lead:⋅,trail:⋅,tab:⁚⁚,nbsp:␣,extends:»,precedes:«',
    number = true,
    numberwidth = 3,
    path = '.,**',
    pumheight = 5,
    sessionoptions = 'buffers,curdir,tabpages,folds,winpos,winsize',
    shiftwidth = 2,
    shortmess = 'tonfFOxTcsiIl',
    showmode = false,
    signcolumn = 'yes',
    softtabstop = 2,
    splitbelow = true,
    splitkeep = 'screen',
    splitright = true,
    statuscolumn = '%l%s',
    statusline = ' %{expand("%:p:h:t")}/%t %{&modified?" ":""} %r %= %c:%l/%L    %y',
    swapfile = false,
    tabstop = 2,
    undofile = true,
    updatetime = 300,
    wildmode = 'longest:full,full',
    winborder = 'single',
    wrap = false,
  }
end

local function get_globals()
  return {
    netrw_alto = 'spr',
    netrw_banner = 0,
    netrw_bufsettings = 'noma nomod nonu nobl nowrap ro nornu nocul scl=no',
    netrw_list_hide = [[^\.\/$,^\.\.\/$]],
    netrw_localcopydircmd = 'cp -r',
    netrw_localrmdir = 'rm -r',
    netrw_preview = 1,
    netrw_special_syntax = 1,
    netrw_use_errorwindow = 0,
  }
end

local function apply_global_opts(global_opts)
  for key, value in pairs(global_opts) do
    if value ~= nil then
      vim.g[key] = value
    end
  end
end

local function apply_local_opts(local_opts)
  for key, value in pairs(local_opts) do
    if value ~= nil then
      vim.opt[key] = value
    end
  end
end

function M.setup(addopts)
  local opts = vim.tbl_deep_extend('force', { options = get_options(), global = get_globals() }, addopts or {})
  apply_global_opts(opts.global)
  apply_local_opts(opts.options)
end

return M
