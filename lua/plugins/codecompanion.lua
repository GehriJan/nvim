return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- Optional: For autocompletion
      { "stevearc/dressing.nvim", opts = {} }, -- Optional: beautiful vim.ui.select box
    },
    config = function()
      -- Compatibility alias for latest CodeCompanion
      package.preload["codecompanion.utils.adapters"] = function()
        return require("codecompanion.adapters.utils")
      end

      require("codecompanion").setup({
        -- Support both strategies (v18 and below) and interactions (v19 and above)
        strategies = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
          cli = {
            adapter = "copilot",
          },
        },
        interactions = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
          cmd = {
            adapter = "copilot",
          },
          shared = {
            keymaps = {
              accept_change = {
                callback = "keymaps.accept_change",
                modes = { n = "ga" },
              },
              reject_change = {
                callback = "keymaps.reject_change",
                modes = { n = "gr" },
              },
            },
          },
        },
        adapters = {
          http = {
            copilot = function()
              return require("codecompanion.adapters").extend("copilot", {
                schema = {
                  model = {
                    default = "claude-sonnet-5",
                  },
                },
              })
            end,
          },
        },
        display = {
          action_palette = {
            provider = "telescope",
          },
          chat = {
            show_settings = false,
            window = {
              layout = "vertical",
              width = 0.4,
            },
          },
        },
        opts = {
          log_level = "ERROR",
          send_code = true,
        },
      })

      -- Keymaps
      local map = vim.keymap.set

      -- Open the Action Palette
      map({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })

      -- Toggle Chat Buffer
      map({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle CodeCompanion Chat" })

      -- Inline Assistant
      map({ "n", "v" }, "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "CodeCompanion Inline" })

      -- Add visually selected code to the active chat buffer
      map("v", "<leader>ay", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add Selection to Chat" })

      -- Expand 'cc' to 'CodeCompanion' in the command line
      vim.cmd([[cabbrev cc CodeCompanion]])
    end,
  },
}
