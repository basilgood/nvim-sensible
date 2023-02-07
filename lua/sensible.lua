local M = {}

local defaults = {
  path = '.,**',
  swapfile = false,
  undofile = true,
  autowrite = true,
  autowriteall = true,
  gdefault = true,
  virtualedit = 'onemore',
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
  complete = '.,w,b,u,i',
  list = true,
  listchars = { tab = '🢝 ', lead = '·', trail = '·', nbsp = '␣', eol = '¬' },
  sessionoptions = 'buffers,curdir,tabpages,folds,winpos,winsize',
  wildignore = { '*/node_modules/*,*/.git/*' },
  wildmode = 'longest:full,full',
  pumheight = 5,
  grepprg = 'rg --vimgrep',
  grepformat = '%f:%l:%c:%m',
  statusline = ' %{mode()} | %t %m %r %= %c,%l/%L    %y',
}

function M.setup(addopts)
  local opts = vim.tbl_deep_extend('force', defaults, addopts)
  for set, value in pairs(opts) do
    vim.opt[set] = value
  end
end

return M
