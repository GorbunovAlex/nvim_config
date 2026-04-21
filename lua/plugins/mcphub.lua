return {
  "ravitemer/mcphub.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  -- Remove the build command to stop it from trying to compile locally
  -- build = "npm install ...",

  config = function()
    require("mcphub").setup({
      -- Set this to false (or remove the line entirely) to use the global installation
      use_bundled_binary = false,
    })
  end,
}
