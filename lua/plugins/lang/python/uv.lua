return {
  "benomahony/uv.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  opts = {
    picker_integration = true,
    auto_activate_venv = true,
  },
  config = function(_, opts)
    local uv = require("uv")
    uv.setup(opts)

    local is_win = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
    local py_binary = is_win and "Scripts/python.exe" or "bin/python"

    local function notify_lsp(venv_path)
      local py = vim.fs.joinpath(venv_path, py_binary)
      if vim.fn.executable(py) ~= 1 then
        return
      end

      -- Update any active pyright / basedpyright LSP clients
      for _, server_name in ipairs({ "pyright", "basedpyright" }) do
        local clients = vim.lsp.get_clients({ name = server_name })
        for _, client in ipairs(clients) do
          if client.settings then
            client.settings.python = vim.tbl_deep_extend("force", client.settings.python or {}, {
              pythonPath = py,
              venvPath = vim.fs.dirname(venv_path),
              venv = vim.fs.basename(venv_path),
            })
          else
            client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, {
              python = {
                pythonPath = py,
                venvPath = vim.fs.dirname(venv_path),
                venv = vim.fs.basename(venv_path),
              },
            })
          end
          client:notify("workspace/didChangeConfiguration", { settings = nil })
        end
      end
    end

    -- Hook into activate_venv so that running LSP clients are re-notified whenever an env is activated
    local orig_activate = uv.activate_venv
    uv.activate_venv = function(venv_path)
      local res = orig_activate(venv_path)
      notify_lsp(venv_path)
      return res
    end

    -- Auto-activate when opening a python buffer whose project has a .venv (supports monorepos & files opened outside root)
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      pattern = "*.py",
      callback = function(args)
        local bufpath = vim.api.nvim_buf_get_name(args.buf)
        if bufpath == "" then
          return
        end
        local bufdir = vim.fs.dirname(bufpath)
        local venv = vim.fs.find(".venv", { path = bufdir, upward = true, type = "directory" })[1]
        if venv and venv ~= vim.env.VIRTUAL_ENV and vim.fn.executable(vim.fs.joinpath(venv, py_binary)) == 1 then
          uv.activate_venv(venv)
        end
      end,
    })
  end,
}
