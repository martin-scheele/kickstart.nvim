return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    -- char = '',
    -- context_char = '▏',
    -- show_current_context = false,
    -- show_current_context_start = false,
    -- max_indent_increase = 1,
    -- show_trailing_blankline_indent = false,
    config = function()
      local opts = {
        indent = {
          char = '▏',
        },
        -- whitespace = {
        --   highlight = 'IblWhitespace',
        --   remove_blankline_trail = false,
        -- },
        scope = {
          enabled = false,
          show_start = false,
          show_end = false,
        },
      }
      local hooks = require 'ibl.hooks'
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
      require('ibl').setup(opts)
    end,
  },
}
