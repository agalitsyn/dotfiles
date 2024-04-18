return {
  "nvimdev/dashboard-nvim",
  opts = {
    config = {
      header = vim.split(string.rep("\n", 5) .. vim.fn.execute("version") .. "\n", "\n"),
    },
  },
}
