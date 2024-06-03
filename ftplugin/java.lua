local getOS = require('custom.plugins.getOS')
local config = {}
local jdtls_path = ""

if getOS.getName() == "Windows" then
    jdtls_path = vim.fn.expand "~/AppData/Local/nvim-data/mason/bin/jdtls.cmd"
elseif getOS.getName() == "Linux" then
    jdtls_path = vim.fn.expand "~/.local/share/nvim/mason/bin/jdtls"
end

config = {
  cmd = { jdtls_path },
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
}

require('jdtls').start_or_attach(config)
