vim.opt.path = '.,**'
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.opt.gdefault = true
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 200
vim.opt.diffopt:append('context:3,indent-heuristic,algorithm:patience')
vim.opt.shortmess:append('scI')
vim.opt.showmode = false
vim.opt.completeopt = 'menuone,noselect'
vim.opt.list = true
vim.opt.listchars = { tab = '🢝 ', lead = '·', trail = '·', nbsp = '␣' }
vim.opt.sessionoptions = 'buffers,curdir,tabpages,folds,winpos,winsize'
vim.opt.wildignore = { '*/node_modules/*,*/.git/*' }
vim.opt.wildmode = 'longest:full,full'
vim.opt.pumheight = 5
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.laststatus = 2
vim.opt.statusline = [[%{expand('%:p:h:t')}/%t%h%r%#error#%m%*%=[%{strlen(&ft)?&ft:'none'}]%*%4c:%l/%L]]
