local M = {}

local function get_options()
  return {
    autowrite = true,
    autowriteall = true,
    breakindent = true,
    complete = '.,w,b,u,i',
    completeopt = 'menuone,noselect,popup',
    cursorline = true,
    cursorlineopt = 'number',
    diffopt = 'internal,filler,closeoff,context:3,indent-heuristic,algorithm:histogram,linematch:40',
    expandtab = true,
    fillchars = {
      eob = ' ',
      diff = '╱',
      foldopen = '',
      foldclose = '',
      fold = ' ',
      foldsep = ' ',
      msgsep = '─',
    },
    gdefault = true,
    iskeyword = '@,48-57,_,192-255,-',
    jumpoptions = 'view',
    linebreak = true,
    list = true,
    listchars = 'trail:⋅,tab:⁚⁚,nbsp:␣,extends:»,precedes:«',
    number = true,
    numberwidth = 1,
    ruler = true,
    rulerformat = '%y %-4.(%2c:%l/%L%)',
    pumborder = 'solid',
    pumheight = 5,
    shiftwidth = 2,
    shortmess = 'tonfFOxTcsiIl',
    showmode = false,
    signcolumn = 'yes',
    splitbelow = true,
    splitkeep = 'screen',
    splitright = true,
    statuscolumn = '%l%s',
    swapfile = false,
    tabstop = 2,
    timeoutlen = 2500,
    undofile = true,
    updatetime = 300,
    wildmode = 'longest:full,full',
    winborder = 'single',
    wrap = false,
  }
end

local function get_globals()
  return {
    netrw_banner = 0,
    netrw_list_hide = [[^\.\/$,^\.\.\/$]],
    netrw_alto = 0,
    netrw_preview = 1,
    netrw_localcopydircmd = 'cp -r',
    netrw_use_errorwindow = 0,
  }
end

local function get_autocmds()
  return {
    {
      event = 'TextYankPost',
      callback = function()
        vim.highlight.on_yank({ higroup = 'Visual' })
      end,
    },
    {
      event = 'BufWritePre',
      callback = function()
        local dir = vim.fn.expand('<afile>:p:h')
        if vim.fn.isdirectory(dir) == 0 then
          vim.fn.mkdir(dir, 'p')
        end
      end,
    },
    {
      event = 'BufReadPost',
      callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
          pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
      end,
    },
    {
      event = 'FileType',
      pattern = { 'help', 'qf', 'git' },
      callback = function()
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true })
      end,
    },
    {
      event = 'BufWinEnter',
      callback = function()
        vim.opt.formatoptions = 'cqrnj'
      end,
    },
    {
      event = 'InsertEnter',
      callback = function()
        vim.schedule(function()
          vim.cmd('nohlsearch')
        end)
      end,
    },
    {
      event = 'LspAttach',
      callback = function(args)
        local bufnr = args.buf
        local buffer_map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        buffer_map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        buffer_map('<c-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
        buffer_map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local hover_or_open_diagnostic_float = function()
          local lineNumber = vim.fn.line('.') - 1
          local diag = vim.diagnostic.get(0, { lnum = lineNumber })
          local has_diagnostics = #diag > 0
          if has_diagnostics then
            vim.diagnostic.open_float()
          else
            vim.lsp.buf.hover()
          end
        end

        buffer_map('K', hover_or_open_diagnostic_float, 'Hover Documentation')

        vim.notify('LSP integration enabled.', vim.log.levels.DEBUG)
      end,
    },
  }
end

local function apply_options(options)
  for k, v in pairs(options) do
    if type(v) == 'table' and (v.append or v.prepend or v.remove) then
      -- Handle operation tables
      if v.append then
        vim.opt[k]:append(v.append)
      end
      if v.prepend then
        vim.opt[k]:prepend(v.prepend)
      end
      if v.remove then
        vim.opt[k]:remove(v.remove)
      end
    else
      -- Normal value assignment
      vim.opt[k] = v
    end
  end
end

local function apply_globals(globals)
  for k, v in pairs(globals) do
    vim.g[k] = v
  end
end

local function apply_autocmds(autocmds)
  local group = vim.api.nvim_create_augroup('SensibleAutocmds', { clear = true })
  for _, autocmd in ipairs(autocmds) do
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = group,
      pattern = autocmd.pattern,
      callback = autocmd.callback,
    })
  end
end

function M.setup(opts)
  opts = opts or {}

  local options = vim.tbl_deep_extend('force', get_options(), opts.options or {})
  local globals = vim.tbl_deep_extend('force', get_globals(), opts.globals or {})
  local autocmds = opts.autocmds or get_autocmds()

  apply_globals(globals)
  apply_options(options)
  apply_autocmds(autocmds)
end

return M
