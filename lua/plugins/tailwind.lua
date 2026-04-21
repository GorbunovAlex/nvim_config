return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          -- This safely bypasses the broken 'root_markers_with_field' function
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(
              "tailwind.config.js",
              "tailwind.config.cjs",
              "tailwind.config.mjs",
              "tailwind.config.ts",
              "postcss.config.js",
              "postcss.config.ts",
              "package.json",
              ".git"
            )(fname)
          end,
        },
      },
    },
  },
}
