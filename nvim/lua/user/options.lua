vim.opt.backup = false                          -- creates a backup file
vim.opt.swapfile = false                        -- creates a swapfile
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

vim.opt.mouse = "a"                             -- allow the mouse to be used in neovim
vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file

vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.smartcase = true                        -- smart case
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.cursorline = false                       -- highlight the current line
vim.opt.number = true                           -- set numbered lines
vim.opt.relativenumber = true                  -- set relative numbered lines
vim.opt.wrap = false                            -- display lines as one long line
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window

vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.shiftwidth = 4                          -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4                             -- insert 2 spaces for a tab
vim.opt.numberwidth = 4                         -- set number column width to 2 {default 4}

vim.cmd [[set iskeyword+=-]]                    -- treat foo-bar as a single keyword

