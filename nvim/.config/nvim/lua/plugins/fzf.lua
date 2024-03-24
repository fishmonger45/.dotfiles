return {
  "ibhagwan/fzf-lua",
  config = function()
    -- calling `setup` is optional for customization
    local fzf = require("fzf-lua")
    fzf.setup({})
    vim.keymap.set("n", "<C-f>", fzf.live_grep_native)
    vim.keymap.set("n", "<leader>ff", fzf.git_commits, {})
    vim.keymap.set("n", "<leader>fb", fzf.git_branches, {})
  end
}
