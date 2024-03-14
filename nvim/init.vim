let mapleader = " "
let maplocalleader = ","

syntax on
set encoding=utf-8
set clipboard=unnamedplus
set mouse=a

if exists("$VSCODE_NEOVIM") && $VSCODE_NEOVIM == "1"
    " Your VSCode-specific configurations go here
lua << EOF

local keymap = vim.api.nvim_set_keymap
local function notify(cmd)
    return string.format("<cmd>call VSCodeNotify('%s')<CR>", cmd)
end

local function v_notify(cmd)
    return string.format("<cmd>call VSCodeNotifyVisual('%s', 1)<CR>", cmd)
end

keymap('n', '<Leader>xr', notify 'references-view.findReferences', { silent = true }) -- language references
keymap('n', '<Leader>xd', notify 'workbench.actions.view.problems', { silent = true }) -- language diagnostics
keymap('n', 'gr', notify 'editor.action.goToReferences', { silent = true })
keymap('n', '<Leader>rn', notify 'editor.action.rename', { silent = true })
keymap('n', '<Leader>fm', notify 'editor.action.formatDocument', { silent = true })
keymap('n', '<Leader>ca', notify 'editor.action.refactor', { silent = true }) -- language code actions

keymap('n', '<Leader>rg', notify 'workbench.action.findInFiles', { silent = true }) -- use ripgrep to search files
keymap('n', '<Leader>ts', notify 'workbench.action.toggleSidebarVisibility', { silent = true })
keymap('n', '<Leader>th', notify 'workbench.action.toggleAuxiliaryBar', { silent = true }) -- toggle docview (help page)
keymap('n', '<Leader>tp', notify 'workbench.action.togglePanel', { silent = true })
keymap('n', '<Leader>fc', notify 'workbench.action.showCommands', { silent = true }) -- find commands
keymap('n', '<Leader>ff', notify 'workbench.action.quickOpen', { silent = true }) -- find files
keymap('n', '<Leader>tw', notify 'workbench.action.terminal.toggleTerminal', { silent = true }) -- terminal window

keymap('v', '<Leader>fm', v_notify 'editor.action.formatSelection', { silent = true })
keymap('v', '<Leader>ca', v_notify 'editor.action.refactor', { silent = true })
keymap('v', '<Leader>fc', v_notify 'workbench.action.showCommands', { silent = true })

EOF

else
    " Your terminal-specific configurations go here
    
let g:loaded_netrw=1
let g:loaded_netrwPlugin=1

call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'lervag/vimtex'

" Plug 'echasnovski/mini.move'
Plug 'matze/vim-move'

Plug 'folke/which-key.nvim'

Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'

" Formatter
"Plug 'mhartington/formatter.nvim'
Plug 'stevearc/conform.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

Plug 'nvim-tree/nvim-web-devicons' " optional
Plug 'nvim-tree/nvim-tree.lua'

"  Uncomment the two plugins below if you want to manage the language servers from neovim
 Plug 'williamboman/mason.nvim'
 Plug 'williamboman/mason-lspconfig.nvim'

" LSP Support
Plug 'neovim/nvim-lspconfig'
" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'

Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v3.x'}

Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
"Plug 'rmehri01/onenord.nvim', { 'branch': 'main' }
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

call plug#end()


set encoding=utf-8
set termguicolors
set relativenumber
set number

let g:tex_flavor='latex'
let g:vimtex_view_method='sioyek'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
let g:tex_comment_nospell=1
set tabstop=4
set shiftwidth=4
set expandtab
"set autoindent
"set smartindent
set textwidth=80
let g:move_key_modifier = 'C'
let g:move_key_modifier_visualmode = 'S'

autocmd FileType html,javascript,javascriptreact,typescript,typescriptreact setlocal tabstop=2 shiftwidth=2
autocmd FileType markdown setlocal formatoptions+=a




lua << EOF

-- Colors
require("catppuccin").setup({ 
    flavour = "latte",
})

-- Autoclose setup
require("nvim-autopairs").setup {}
require'nvim-treesitter.configs'.setup {}

require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "python", "go", "latex" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },

    autotag = {
        enable = true,
    },
}

-- LSP setup
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
-- "csharp_ls" "csharp_ls"
require('mason-lspconfig').setup({
  ensure_installed = {"cssls", "eslint", "gopls", "html", "jsonls", "tsserver", "lua_ls", "autotools_ls", "pylsp", "ruff_lsp", "svelte", "tailwindcss", "vimls"},
  handlers = {
    lsp_zero.default_setup,
   
    require('lspconfig').pylsp.setup({
      settings = { pylsp = {
        plugins = {
          pycodestyle = {
            enabled = true,
            --ignore = {'E501'},
            maxLineLength = 100,
          },
        },
      }},
    }),
  },
})

-- Formatting
require('conform').setup({
  formatters_by_ft = {
      javascript = {'prettierd'},
      typescript = {'prettierd'},
      javascriptreact = {'prettierd'},
      typescriptreact = {'prettierd'},
      html = {'prettierd'},
      css = {'prettierd'},
      python = {'ruff format'},
  },
  format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
  },
})

vim.keymap.set({ "n", "v" }, "<leader>fm", function()
  require('conform').format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  })
  print('formatting')
  end, { desc = "Format file or range (in visual mode)" })
  
-- Autocomplete setup
local cmp = require('cmp')

cmp.setup({
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  mapping = cmp.mapping.preset.insert({
    ['<TAB>'] = cmp.mapping.confirm({select = false}),
  }),
})

vim.o.timeout = true
vim.o.timeoutlen = 300
require('which-key').setup({})

-- NvimTree center layout
local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then return end

local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.5  -- You can change this too

nvimtree.setup({
  disable_netrw = true,
  hijack_netrw = true,
  respect_buf_cwd = true,
  sync_root_with_cwd = true,
  view = {
    relativenumber = true,
    float = {
      enable = true,
      open_win_config = function()
        local screen_w = vim.opt.columns:get()
        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
        local window_w = screen_w * WIDTH_RATIO
        local window_h = screen_h * HEIGHT_RATIO
        local window_w_int = math.floor(window_w)
        local window_h_int = math.floor(window_h)
        local center_x = (screen_w - window_w) / 2
        local center_y = ((vim.opt.lines:get() - window_h) / 2)
                         - vim.opt.cmdheight:get()
        return {
          border = "rounded",
          relative = "editor",
          row = center_y,
          col = center_x,
          width = window_w_int,
          height = window_h_int,
        }
        end,
    },
    width = function()
      return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
    end,
  },
  -- filters = {
  --   custom = { "^.git$" },
  -- },
  -- renderer = {
  --   indent_width = 1,
  -- },
})

EOF


colorscheme catppuccin-frappe


" Nvim Tree mappings
nnoremap <leader>tt :NvimTreeToggle<CR>

" Telescope mappings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

endif
