local M = {
  "szw/vim-maximizer",
  event = "VeryLazy",
}

function M.config()
  keymap = vim.keymap.set
  keymap("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximizationd
end

return M
