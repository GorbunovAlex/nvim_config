return {
  {
    "numToStr/Comment.nvim",
  },
  { "nvim-tree/nvim-web-devicons", opts = {} },

  -- Consolidated nvim-dap definition
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
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
        "<C-t>",
        function()
          require("dapui").toggle()
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

      -- Setup Python
      -- Ensure this path points to a valid python with debugpy installed.
      -- If using mason, it is usually: vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")

      require("dapui").setup()
      require("dap-go").setup()

      -- Go Configuration
      table.insert(dap.configurations.go, {
        {
          type = "go",
          name = "attach",
          mode = "local",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      })

      -- Python Configuration
      table.insert(require("dap").configurations.python, {
        type = "python",
        request = "attach",
        name = "Python Attach docker",
        connect = function()
          local host = vim.fn.input("Host [0.0.0.0]: ")
          host = host ~= "" and host or "0.0.0.0"
          local port = tonumber(vim.fn.input("Port [9200]: ")) or 9200
          return { host = host, port = port }
        end,
        pathMappings = {
          { localRoot = "${workspaceFolder}", remoteRoot = "/src" },
        },
        justMyCode = false,
      })

      table.insert(require("dap").configurations.python, {
        type = "python",
        request = "attach",
        name = "Python Attach local",
        connect = { port = 9200, host = "127.0.0.1" },
        subProcess = true,
      })

      -- Dap UI Listeners
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

      -- Signs
      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "🚨", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )

      -- VSCode JS Setup
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })

      -- FIX: Replaced broken Mason call with standard path
      local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"

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
            type = "pwa-chrome",
            request = "launch",
            name = "client: chrome",
            url = "http://localhost:3000",
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
