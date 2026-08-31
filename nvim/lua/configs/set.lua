-- [[ Setting options ]]
-- See `:help vim.o`

-- Make line numbers default
vim.o.number = true

-- Enable cursorline
vim.o.cursorline = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Save undo history
vim.opt.undofile = true

-- Undo persistent after close file
vim.opt.undodir = os.getenv("HOME") .. "/.vimUndoFiles"
vim.opt.undolevels = 5000

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 1000

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noselect"

-- diff split vertical
vim.o.diffopt = "vertical"

-- Switch files without need to save
vim.o.hidden = true

-- Not touch the borders of the screen on scroll
vim.o.scrolloff = 1

-- Tabs config
vim.opt.expandtab = true -- spaces not tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.list = true
vim.opt.listchars = "tab:┆ " -- alert if I use tabs!! : retab to fix

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Dash should not split a word
vim.opt.iskeyword:append("-")

-- Configure how new splits should be opened
vim.opt.splitright = false -- new window at the right?
vim.opt.splitbelow = true -- new window at the bottom?

-- Not break lines
vim.opt.wrap = false

-- Set highlight on search
vim.o.hlsearch = true

-- column selection no limit width
vim.o.virtualedit = "block"

-- automatically rebalance windows on vim resize
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
  pattern = "*",
})

-- Set cursor
vim.opt.guicursor = "n-v-sm:block-Cursor,i-ci-ve:ver35-Cursor,c:ver100-Cursor,r-cr-o:hor20-Cursor,t:ver35-Cursor"
