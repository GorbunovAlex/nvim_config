-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("lazydev").setup()
require("lspconfig").pyright.setup({})
