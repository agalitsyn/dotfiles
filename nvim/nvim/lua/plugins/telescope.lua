return {
  {
    "nvim-telescope/telescope.nvim",

    -- this will be merged with defaults
    keys = {
      { "<leader>sc", "<cmd>Telescope git_status<CR>", desc = "[S]earch [C]hanged Files" },
    },

    opts = {
      defaults = {
        file_ignore_patterns = {
          ".git/",
          "node_modules/",
          "vendor/",
        },
      },
    },
  },
}
