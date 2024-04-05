return {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    keys = {
        {
            "<leader>r",
            function()
                require("neo-tree.command").execute({
                    toggle = true,
                    source = "filesystem",
                    position = "left",
                })
            end,
            desc = "Filesystem (root dir)",
        },
    },
    config = function()
        require("neo-tree").setup({})
    end,
}
