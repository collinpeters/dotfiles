local function register_language_server(pattern, callback)
    vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = pattern,
        callback = callback,
        desc = "Start language server: " .. pattern
    })
end

-- JAVA
--local jdtls = require("lsp.configs.jdtls")
--register_language_server('java', jdtls.start)
