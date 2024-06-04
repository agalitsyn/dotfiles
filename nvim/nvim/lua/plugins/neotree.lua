return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      position = "float",
    },
    filesystem = {
      filtered_items = {
        visible = true,
        show_hidden_count = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          ".venv",
          ".DS_Store",
          "thumbs.db",
        },
        never_show = {},
      },
    },
  },
  keys = {
    {
      "<leader>e",
      "<cmd>Neotree reveal<cr>",
      desc = "Explorer Neotree (reveal)",
    },
  },
}
