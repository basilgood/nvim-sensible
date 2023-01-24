local M = {}

local defaults = {
  path = '.,**',
  swapfile = false,
  undofile = true,
  autowrite = true,
  autowriteall = true,
  gdefault = true,
  number = true,
  termguicolors = true,
  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  wrap = false,
  splitbelow = true,
  splitright = true,
  signcolumn = 'yes',
  updatetime = 200,
  diffopt = 'internal,filler,closeoff,context:3,indent-heuristic,algorithm:patience',
  shortmess = 'tonfFOxTcsiIl',
  showmode = false,
  completeopt = 'menuone,noselect',
  list = true,
  listchars = { tab = '🢝 ', lead = '·', trail = '·', nbsp = '␣' },
  sessionoptions = 'buffers,curdir,tabpages,folds,winpos,winsize',
  wildignore = { '*/node_modules/*,*/.git/*' },
  wildmode = 'longest:full,full',
  pumheight = 5,
  grepprg = 'rg --vimgrep',
  grepformat = '%f:%l:%c:%m',
  laststatus = 2,
  statusline = [[%{expand('%:p:h:t')}/%t%h%r%#error#%m%*%=[%{strlen(&ft)?&ft:'none'}]%*%4c:%l/%L]],
}

function M.setup(opts)
  local all = vim.tbl_deep_extend('force', defaults, opts)
  for set, value in pairs(all) do
    vim.opt[set] = value
  end
end

return M
