return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        -- capabilities from nvim-cmp
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- common on_attach for all servers
        local on_attach = function(_, bufnr)
            local map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end

            map("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
            map("n", "K", vim.lsp.buf.hover, "Hover")
            map("n", "gr", vim.lsp.buf.references, "[G]oto [R]eferences")
            map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
            map("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

            map("n", "<leader>f", function()
                vim.lsp.buf.format({ async = false })
            end, "[F]ormat file")
        end

        -- apply defaults to ALL servers
        vim.lsp.config("*", {
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- list of servers you want enabled
        local servers = {
            "ts_ls", -- JS / TS
            "pyright", -- Python
            "lua_ls", -- Lua
            "clangd", -- C / C++
            "jdtls", -- Java
            "rust_analyzer", -- Rust
            "omnisharp", -- C#
        }

        -- enable each server (mason-lspconfig will ensure they exist)
        for _, server in ipairs(servers) do
            vim.lsp.enable(server)
        end

        -- format on save using any attached LSP
        local augroup = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            callback = function(event)
                local clients = vim.lsp.get_clients({ bufnr = event.buf })
                if #clients > 0 then
                    vim.lsp.buf.format({ bufnr = event.buf })
                end
            end,
        })
    end,
}
