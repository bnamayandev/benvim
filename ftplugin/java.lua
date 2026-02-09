local jdtls = require("jdtls")

-- ================================
-- PROJECT ROOT (SPRING BOOT SAFE)
-- ================================
local root_dir = require("jdtls.setup").find_root({
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "settings.gradle",
  "mvnw",
  "gradlew",
  ".git",
})

if not root_dir then
  return
end

-- ================================
-- WORKSPACE (UNIQUE PER PROJECT)
-- ================================
local project_name = vim.fn.fnamemodify(root_dir, ":p:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name
local jdtls_cmd = vim.fn.stdpath("data") .. "/mason/bin/jdtls"

-- ================================
-- CAPABILITIES (CRITICAL)
-- ================================
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.codeAction = {
  dynamicRegistration = false,
  codeActionLiteralSupport = {
    codeActionKind = {
      valueSet = {
        "",
        "quickfix",
        "refactor",
        "refactor.extract",
        "refactor.inline",
        "refactor.rewrite",
        "source",
        "source.organizeImports",
        "source.generate",
      },
    },
  },
}

-- ================================
-- ON ATTACH (THIS WAS MISSING)
-- ================================
local on_attach = function(_, bufnr)
  local map = function(lhs, rhs)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true })
  end

  -- THIS MAKES <leader>ca WORK
  map("<leader>ca", vim.lsp.buf.code_action)

  -- JAVA-SPECIFIC
  map("<leader>jo", jdtls.organize_imports)

  map("<leader>jg", function()
    jdtls.code_action({ "source.generate" })
  end)

  map("<leader>jc", function()
    jdtls.code_action({ "source.generate.constructors" })
  end)

  map("<leader>jt", function()
    jdtls.code_action({ "source.generate.toString" })
  end)
end

-- ================================
-- START JDTLS
-- ================================
jdtls.start_or_attach({
  cmd = { jdtls_cmd, "-data", workspace_dir },
  root_dir = root_dir,
  capabilities = capabilities,
  on_attach = on_attach,
  init_options = {
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },
})

require("jdtls.setup").add_commands()

-- ================================
-- AUTO ORGANIZE IMPORTS ON SAVE
-- ================================
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    pcall(jdtls.organize_imports)
  end,
})

-- ================================
-- MANUAL JAVA BOILERPLATE COMMAND
-- ================================
local function java_package_from_path(filepath)
  local p = filepath:gsub("\\", "/")
  local src_root =
    p:match("(.*/src/main/java/)")
    or p:match("(.*/src/test/java/)")

  if not src_root then return nil end

  local rel = p:sub(#src_root + 1)
  local dir = rel:match("(.+)/[^/]+%.java$")
  if not dir then return nil end

  return dir:gsub("/", ".")
end

local function generate_java_boilerplate()
  local filename = vim.api.nvim_buf_get_name(0)
  if filename == "" then return end

  local class_name = vim.fn.fnamemodify(filename, ":t:r")
  local pkg = java_package_from_path(filename)

  -- only generate if buffer is empty
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  if #lines > 1 or (lines[1] and lines[1] ~= "") then
    vim.notify("Buffer not empty", vim.log.levels.WARN)
    return
  end

  local out = {}

  if pkg then
    table.insert(out, "package " .. pkg .. ";")
    table.insert(out, "")
  end

  table.insert(out, "public class " .. class_name .. " {")
  table.insert(out, "")
  table.insert(out, "}")

  vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
  vim.api.nvim_win_set_cursor(0, { #out - 1, 2 })
end

-- keybinding: generate boilerplate manually
vim.keymap.set("n", "<leader>jb", generate_java_boilerplate, { buffer = 0, desc = "Java boilerplate" })
