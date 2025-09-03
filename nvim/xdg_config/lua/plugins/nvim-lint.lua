return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        markdownlint = {
          args = { "--config", "~/.markdownlint.json", "--" },
        },
        ["markdownlint-cli2"] = {
          args = { "--config", "~/.markdownlint.json", "--" },
        },
      },
    },
  },
}
