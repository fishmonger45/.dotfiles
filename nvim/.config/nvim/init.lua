vim.o.number=true
vim.o.lazyredraw=true
vim.o.showcmd=true
vim.o.hidden=true
vim.o.history=100
vim.o.autoindent=true
vim.o.updatetime=750
vim.o.scrolloff=4
vim.o.laststatus=2
vim.o.ruler=true
vim.o.incsearch=true
vim.o.showmatch=true
vim.o.hlsearch=true
vim.o.foldenable=true
vim.o.shiftwidth=4
vim.g.mapleader=","
vim.cmd.colorscheme("torte")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

