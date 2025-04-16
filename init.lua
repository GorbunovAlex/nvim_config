-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("lazydev").setup()
require("lspconfig").pyright.setup({})
require("flutter-tools").setup({})

local env_util = require("utils.env_util")
local env_vars = env_util.load_env_file()
local gemini_api_key = env_vars["GEMINI_API_KEY"]
require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "gemini",
    },
    inline = {
      adapter = "ollama",
    },
  },
  adapters = {
    gemini = function()
      return require("codecompanion.adapters").extend("gemini", {
        env = {
          url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent",
          api_key = gemini_api_key,
        },
      })
    end,
    qwen = function()
      return require("codecompanion.adapters").extend("ollama", {
        name = "qwen",
        schema = {
          model = {
            default = "qwen2.5-coder:1.5b",
          },
        },
      })
    end,
  },
})
