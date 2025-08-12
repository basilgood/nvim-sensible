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

local function get_autocmds()
  return {
    {
      event = 'TextYankPost',
      pattern = '*',
      callback = function()
        vim.highlight.on_yank({ higroup = 'Search', timeout = 200 })
      end,
      desc = 'highlight yanked text',
    },
    {
      event = 'BufWritePre',
      pattern = '*',
      callback = function()
        local dir = vim.fn.expand('<afile>:p:h')
        if vim.fn.isdirectory(dir) == 0 then
          vim.fn.mkdir(dir, 'p')
        end
      end,
      desc = 'auto-create directories when saving files',
    },
    {
      event = 'BufReadPost',
      pattern = '*',
      callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
          pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
      end,
      desc = 'jump to last cursor position',
    },
    {
      event = 'FileType',
      pattern = { 'help', 'qf' },
      callback = function()
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true })
      end,
      desc = 'close with q',
    },
    {
      event = 'BufWinEnter',
      pattern = '*',
      callback = function()
        vim.opt.formatoptions = 'cqrnj'
      end,
      desc = 'no comments when o',
    },
    {
      event = 'InsertEnter',
      pattern = '*',
      callback = function()
        vim.schedule(function()
          vim.cmd('nohlsearch')
        end)
      end,
      desc = 'no hlsearch in insert mode',
    },
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

local function apply_autocmds(autocmds)
  local group = vim.api.nvim_create_augroup('SensibleAutocmds', { clear = true })
  for _, autocmd in ipairs(autocmds) do
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = group,
      pattern = autocmd.pattern,
      callback = autocmd.callback,
      desc = autocmd.desc,
    })
  end
end

function M.setup(addopts)
  local opts = vim.tbl_deep_extend('force', {
    options = get_options(),
    global = get_globals(),
    autocmds = get_autocmds(),
  }, addopts or {})

  apply_global_opts(opts.global)
  apply_local_opts(opts.options)
  apply_autocmds(opts.autocmds)
end

return M
