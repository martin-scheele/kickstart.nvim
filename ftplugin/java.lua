-- local workspace_path = vim.fn.expand '~/.local/share/nvim/jdtls-workspace/'
-- local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
-- local workspace_dir = workspace_path .. project_name
--
-- local jdtls_install = vim.fn.expand '~/.local/share/nvim/mason/packages/jdtls'

local workspace_path = ''
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local jdtls_install = ''
local config_path = ''

local getOS = require 'custom.plugins.getOS'

if getOS.getName() == 'Windows' then
  workspace_path = vim.fn.expand '~/AppData/Local/nvim-data/jdtls-workspace/'
  jdtls_install = vim.fn.expand '~/.local/share/nvim/mason/packages/jdtls'
  config_path = jdtls_install .. '/config_linux'
elseif getOS.getName() == 'Linux' then
  workspace_path = vim.fn.expand '~/.local/share/nvim/jdtls-workspace/'
  jdtls_install = vim.fn.expand '~/AppData/Local/nvim-data/mason/packages/jdtls'
  config_path = jdtls_install .. '/config_win'
end

local workspace_dir = workspace_path .. project_name

-- https://github.com/exosyphon/nvim/blob/main/ftplugin/java.lua
-- local status, jdtls = pcall(require, 'jdtls')
-- if not status then
--   return
-- end
local jdtls = require 'jdtls'
local extendedClientCapabilities = jdtls.extendedClientCapabilities

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    'java',

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',

    '-jar',
    jdtls_install .. '/plugins/org.eclipse.equinox.launcher_1.6.800.v20240330-1250.jar',

    '-configuration',
    config_path,

    '-data',
    workspace_dir,
  },

  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  --
  -- vim.fs.root requires Neovim 0.10.
  -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
  -- root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },
  root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew', 'pom.xml' }),
  -- root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      -- inlay_hints = {
      --   parameterNames = {
      --     enabled = 'all',
      --   },
      -- },
      format = { enabled = false },
      maven = { downloadSources = true },
      references = { includeDecompiledSources = true },
      signatureHelp = { enabled = true },
    },
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    extendedClientCapabilities = extendedClientCapabilities,
    bundles = {},
  },
  -- capabilities = {
  --   textDocument = {
  --     completion = {
  --       completionItem = {
  --         snippetSupport = true,
  --       },
  --     },
  --   },
  -- },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)

-- local getOS = require 'custom.plugins.getOS'
-- local config = {}
-- local jdtls_path = ''
--
-- if getOS.getName() == 'Windows' then
--   jdtls_path = vim.fn.expand '~/AppData/Local/nvim-data/mason/bin/jdtls.cmd'
-- elseif getOS.getName() == 'Linux' then
--   jdtls_path = vim.fn.expand '~/.local/share/nvim/mason/bin/jdtls'
-- end
--
-- config = {
--   cmd = { jdtls_path },
--   root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
-- }
--
-- require('jdtls').start_or_attach(config)
