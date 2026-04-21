local lspconfig = require("lspconfig")

-- bootstrap lazy.nvim, LazyVim and your plugins

require("config.lazy")
require("lazydev").setup()

-------------------------------------------------
-- Python
-------------------------------------------------

-- 1. Configure Pyright (Strictly for Type Checking)
lspconfig.pyright.setup({
  settings = {
    pyright = {
      -- Use Ruff's import organizer instead
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Let Ruff handle these
        ignore = { "*" },
        typeCheckingMode = "standard", -- or "basic"
      },
    },
  },
})
-- 2. Configure Ruff (For Linting, Formatting, and Code Actions)
lspconfig.ruff.setup({
  init_options = {
    settings = {
      -- Any specific Ruff settings go here
      -- e.g., lint = { select = {"E", "F", "I"} }
    },
  },
})

-------------------------------------------------

require("flutter-tools").setup({})

lspconfig.clangd.setup({
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders=true", -- FIX: Added '=true'
    "--fallback-style=llvm",
  },
  settings = {
    clangd = {
      inlayHints = {
        -- FIX: Disable all inlay hints to prevent crashes
        enabled = false,
      },
    },
  },
})

vim.opt.termguicolors = true
-- vim.cmd([[colorscheme arctic-abyssal]]

local env_util = require("utils.env_util")
local env_vars = env_util.load_env_file()
local gemini_api_key = env_vars["GEMINI_API_KEY"]
require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "gemini",
    },
    inline = {
      -- adapter = "ollama",
      adapter = "gemini",
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
    local_gemma3_4b = function()
      return require("codecompanion.adapters").extend("ollama", {
        name = "gemma3:4b",
        schema = {
          model = {
            default = "gemma3:4b-it-qat",
          },
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
  extensions = {
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        show_result_in_chat = true,
        make_vars = true,
        make_slash_commands = true,
      },
    },
  },
})
