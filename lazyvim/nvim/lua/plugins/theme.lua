return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      no_italic = true, -- Force no italic
      custom_highlights = function(colors)
        return {
          WinSeparator = { fg = colors.flamingo },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-macchiato",
    },
  },
}
