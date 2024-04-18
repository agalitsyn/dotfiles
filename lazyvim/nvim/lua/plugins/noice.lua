return {
  "folke/noice.nvim",
  opts = function(_, opts)
    table.insert(opts.routes, {
      filter = {
        event = "msg_show",
        kind = "echo", -- or `kind = ""`
      },
      opts = {
        skip = true,
      },
    })
  end,
}
