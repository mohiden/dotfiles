local M = {
  "numToStr/Comment.nvim",
  lazy = false,
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "VeryLazy",
    },
  },
}

function M.config()
  -- Normal mode keybinding
  vim.api.nvim_set_keymap(
    "n",
    "<leader>/",
    "<Plug>(comment_toggle_linewise_current)",
    { noremap = true, silent = true }
  )

  -- Visual mode keybinding
  vim.api.nvim_set_keymap(
    "x",
    "<leader>/",
    "<Plug>(comment_toggle_linewise_visual)",
    { noremap = true, silent = true }
  )

  vim.g.skip_ts_context_commentstring_module = true

---@diagnostic disable-next-line: missing-fields
  require("ts_context_commentstring").setup {
    enable_autocmd = false,
  }

---@diagnostic disable-next-line: missing-fields
  require("Comment").setup {
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  }
end

return M

