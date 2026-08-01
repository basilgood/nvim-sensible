local M = {}

local function get_options()
  return {
    autowrite = true,
    autowriteall = true,
    breakindent = true,
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
    loaded_netrwPlugin = 1,
  }
end

local function get_autocmds()
  return {
    {
      event = 'TextYankPost',
      callback = function()
        vim.hl.hl_op({ higroup='Visual', timeout=300 })
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
      pattern = { 'help', 'qf', 'git', 'fugitive', 'nvim-pack' },
      callback = function()
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true })
      end,
    },
    {
      event = 'FileType',
      pattern = 'directory',
      callback = function()
        vim.opt_local.bufhidden = 'delete'
        vim.opt_local.winbar = '[dir] %f'

        local function reload()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(nvim-dir-reload)', true, false, true), 'n', false)
        end

        local function run(cmd)
          local result = vim.fn.system(cmd)
          if vim.v.shell_error ~= 0 then
            vim.notify(result:gsub('%s+$', ''), vim.log.levels.ERROR)
            return false
          end
          return true
        end

        vim.keymap.set('n', '%', function()
          vim.fn.feedkeys(':edit ' .. vim.fn.expand('%:p:h') .. '/', 'n')
        end, { buffer = true, desc = 'Edit file' })

        vim.keymap.set('n', 'q', function()
          local buf = vim.api.nvim_get_current_buf()
          local alt = vim.fn.bufnr('#')
          if alt > 0 and alt ~= buf and vim.fn.buflisted(alt) == 1 then
            vim.api.nvim_set_current_buf(alt)
          else
            vim.cmd.enew()
          end
        end, { buffer = true, desc = 'Close directory buffer' })

        vim.keymap.set('n', 'r', function()
          local name = vim.fn.expand('<cfile>')
          if name == '' then return end
          local source = vim.fn.expand('%:p:h') .. '/' .. name
          local ok, target = pcall(vim.fn.input, 'Move ' .. name .. ' to: ', source)
          if not ok or target == '' or target == source then return end
          if run('mv ' .. vim.fn.shellescape(source) .. ' ' .. vim.fn.shellescape(target)) then
            reload()
          end
        end, { buffer = true, desc = 'Move / Rename' })

        vim.keymap.set('n', 'd', function()
          local ok, dir_name = pcall(vim.fn.input, 'Directory name: ')
          if not ok or dir_name == '' then return end
          local full_path = vim.fn.expand('%:p:h') .. '/' .. dir_name
          if run('mkdir ' .. vim.fn.shellescape(full_path)) then
            reload()
          end
        end, { buffer = true, nowait = true, desc = 'New folder' })

        vim.keymap.set('n', 'D', function()
          local name = vim.fn.expand('<cfile>')
          if name == '' then return end
          local full_path = vim.fn.expand('%:p:h') .. '/' .. name
          local is_dir = vim.fn.isdirectory(full_path) == 1
          local cmd = (is_dir and 'rm -rd ' or 'rm ') .. vim.fn.shellescape(full_path)
          local ok, confirm = pcall(vim.fn.input, 'Delete ' .. name .. ' ? [' .. cmd .. '] [y/N] ')
          if not ok or confirm:lower() ~= 'y' then return end
          if not is_dir then
            local bufnr = vim.fn.bufnr(full_path)
            if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) then
              vim.cmd.bdelete({ args = { tostring(bufnr) }, bang = true })
            end
          end
          if run(cmd) then
            reload()
          end
        end, { buffer = true, nowait = true, desc = 'Delete file / folder' })
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
