return {
  { "nvim-tree/nvim-web-devicons", opts = {} },
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
    keys = {
      {
        "<leader>d",
        function()
          require("dap").toggle_breakpoint()
        end,
      },
      {
        "<leader>c",
        function()
          require("dap").continue()
        end,
      },
    },
    config = function()
      require("dapui").setup()
    end,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mxsdev/nvim-dap-vscode-js",
      {
        "microsoft/vscode-js-debug",
        version = "1.x",
        build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
      },
      "leoluz/nvim-dap-go",
    },
    keys = {
      {
        "<leader>d",
        function()
          require("dap").toggle_breakpoint()
        end,
      },
      {
        "<leader>c",
        function()
          require("dap").continue()
        end,
      },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      require("dapui").setup()
      require("dap-go").setup()

      table.insert(dap.configurations.go, {
        {
          type = "go",
          name = "attach",
          mode = "local",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      })

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "🚨", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )

      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })

      local mason_registry = require("mason-registry")
      local js_debug_path = mason_registry.get_package("js-debug-adapter"):get_install_path()

      for _, adapter in ipairs({
        "pwa-node",
        "pwa-chrome",
        "pwa-msedge",
        "pwa-extensionHost",
      }) do
        dap.adapters[adapter] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              js_debug_path .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end

      for _, language in ipairs({ "typescript", "javascript", "vue" }) do
        require("dap").configurations[language] = {
          {
            -- use nvim-dap-vscode-js's pwa-chrome debug adapter
            type = "pwa-chrome",
            request = "launch",
            -- name of the debug action
            name = "client: chrome",
            -- default vite dev server url
            url = "http://localhost:3000",
            -- for TypeScript/Svelte
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
            protocol = "inspector",
            port = 44837,
          },
        }
      end
    end,
  },
}
