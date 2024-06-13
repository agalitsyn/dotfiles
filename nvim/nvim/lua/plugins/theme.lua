return {
  -- list of themes
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

  { "ellisonleao/gruvbox.nvim" },

  { "sainnhe/everforest" },

  { "folke/tokyonight.nvim" },

  -- set theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },
}
