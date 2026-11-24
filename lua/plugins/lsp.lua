return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          -- Automatically resolve python path for pyright:
          -- Prioritizes local project virtual environments (uv, poetry, venv),
          -- then active virtual/conda environments, and finally system python.
          before_init = function(_, config)
            local is_win = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
            local py_binary = is_win and "Scripts/python.exe" or "bin/python"

            local function find_py(dir)
              if not dir or dir == "" then
                return nil
              end
              local py = vim.fs.joinpath(dir, py_binary)
              if vim.fn.executable(py) == 1 then
                return py
              end
              return nil
            end

            local function get_python_path()
              -- 1. Check workspace root and current buffer for a local virtual environment (.venv)
              -- Native uv, poetry, etc. store the environment in .venv at project root
              local root = config and config.root_dir or vim.fn.getcwd()
              local bufname = vim.api.nvim_buf_get_name(0)
              local search_start = (bufname ~= "" and vim.fs.dirname(bufname)) or root

              local venv_dirs = vim.fs.find(
                { ".venv", "venv" },
                { path = search_start, upward = true, type = "directory" }
              )
              for _, venv in ipairs(venv_dirs) do
                local py = find_py(venv)
                if py then
                  -- Synchronize Neovim environment variables so terminals, formatters, and ruff pick it up
                  vim.env.VIRTUAL_ENV = venv
                  local bin_dir = vim.fs.joinpath(venv, is_win and "Scripts" or "bin")
                  if not (vim.env.PATH or ""):find(bin_dir, 1, true) then
                    vim.env.PATH = bin_dir .. ":" .. (vim.env.PATH or "")
                  end
                  return py, venv
                end
              end

              -- 2. Check if a virtual env is explicitly active in the terminal / session
              if vim.env.VIRTUAL_ENV then
                local py = find_py(vim.env.VIRTUAL_ENV)
                if py then
                  return py, vim.env.VIRTUAL_ENV
                end
              end

              -- 3. Check if a conda env is explicitly active
              if vim.env.CONDA_PREFIX then
                local py = find_py(vim.env.CONDA_PREFIX)
                if py then
                  return py, nil
                end
              end

              -- 4. Fallback to active terminal python path
              return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python", nil
            end

            local python_path, venv_dir = get_python_path()
            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}
            config.settings.python.pythonPath = python_path
            if venv_dir then
              config.settings.python.venvPath = vim.fs.dirname(venv_dir)
              config.settings.python.venv = vim.fs.basename(venv_dir)
            end
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
            preselect = true, -- Prevents Enter from auto-selecting if you haven't navigated
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
