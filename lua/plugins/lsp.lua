return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          -- This prevents pyright from running too early
          -- and forces it to fetch the path when the server initializes
          before_init = function(_, config)
            local function get_python_path()
              -- 1. Check if a virtual/conda env is explicitly active in the terminal
              if vim.env.VIRTUAL_ENV then
                return vim.env.VIRTUAL_ENV .. "/bin/python"
              elseif vim.env.CONDA_PREFIX then
                return vim.env.CONDA_PREFIX .. "/bin/python"
              end
              -- 2. Fallback to active terminal python path
              return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
            end

            config.settings.python.pythonPath = get_python_path()
          end,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
        ["*"] = {
          keys = {
            -- Disable the default Insert-mode signature help on <C-k>
            { "<C-k>", false, mode = "i" },
          },
        },
      },
      diagnostics = {
        virtual_text = false, -- Disables virtual text for diagnostics, as we are using tiny-inline-diagnostic.nvim for inline diagnostics
      },
    },
  },
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = { "rafamadriz/friendly-snippets" },

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<Esc>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },

        -- Select options using C-j and C-k
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },

        -- Use Tab to select (accept) or fallback to jumping forward in snippets
        ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        -- Scroll documentation windows
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      },
      completion = {
        list = {
          selection = {
            preselect = false, -- Prevents Enter from auto-selecting if you haven't navigated[...](asc_slot://start-slot-14)
            auto_insert = false, -- Won't insert text until you explicitly select
          },
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "modern",
        options = {
          -- Set to false so warnings/hints do not show on non-cursor lines.
          -- When false, only severities defined under multilines.severity will be always visible.
          show_only_when_cursor = false,
          overflow = { mode = "wrap" },
          multilines = {
            enabled = true,
            always_show = true,
            -- Only severities listed here will remain permanently visible on all lines
            severity = {
              vim.diagnostic.severity.ERROR,
            },
          },
          -- This ensures that when your cursor lands on a line,
          -- it shows all other diagnostics (warnings, hints, info) for that line.
          show_all_diags_on_cursorline = true,
        },
      })

      -- Disable Neovim's default virtual text to avoid duplicate diagnostic rendering
      vim.diagnostic.config({
        virtual_text = false,
      })
    end,
  },
}
