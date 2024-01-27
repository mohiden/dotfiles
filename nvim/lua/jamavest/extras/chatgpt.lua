local M = {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
}
function M.config()
  local api_key_cmd = "gpg --decrypt " .. "/Users/mohiden/api-key.txt.gpg"
  require("chatgpt").setup {
    api_key_cmd = api_key_cmd,
  }
end

return M
