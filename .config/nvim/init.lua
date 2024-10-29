-- Setup leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Make line numbers default
vim.opt.number = true

-- Move lines
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")
-- vim.keymap.set("n", "J", ":m .+1<CR>==")
-- vim.keymap.set("n", "K", ":m .-2<CR>==")
-- vim.keymap.set("i", "J", ":m .+1<CR>==gi")
-- vim.keymap.set("i", "K", ":m .-2<CR>==gi")

vim.g.python3_host_prog = "/usr/bin/python3"

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = "unnamedplus"

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Disable default status line
vim.opt.showmode = false

-- Tab width
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.tabstop = 4

-- Sets how neovim will display certain whitespace in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Toggle neotree
vim.keymap.set("n", "<C-n>", "<cmd>Neotree toggle<CR>")
-- -- Reload config on save
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = "**/lua/shxfee/config/*.lua",
--   callback = function()
--     local filepath = vim.fn.expand("%")
--
--     dofile(filepath)
--     vim.notify("Configuration reloaded \n" .. filepath, nil, {
--       title = "autocmds.lua",
--     })
--   end,
--   group = mygroup,
--   desc = "Reload config on save",
-- })

-- Map <leader>f to format the current file with Verible Verilog Formatter
vim.api.nvim_set_keymap('n', '<leader>f', ':!verible-verilog-format --inplace %<CR>',
	{ noremap = true, silent = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Setup Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Setup Lazy plugins
require("lazy").setup("plugins")
