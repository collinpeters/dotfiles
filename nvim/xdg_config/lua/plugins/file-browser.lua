return {
  "nvim-telescope/telescope-file-browser.nvim",
  keys = {
    -- add a keymap to browse plugin files
    {
      "<leader>sB",
      ":Telescope file_browser path=%:p:h=%:p:h<cr>",
      desc = "Find Plugin File",
    },
  },
  config = function()
    require("telescope").load_extension("file_browser")
  end,
}
