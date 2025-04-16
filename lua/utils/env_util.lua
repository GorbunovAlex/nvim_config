local M = {}

-- Function to load environment variables from .env file
function M.load_env_file()
  local path = vim.fn.expand("~/.config/nvim/lua/utils/env.yml")
  local file = assert(io.open(path, "r"))

  local env_vars = {}
  for line in file:lines() do
    -- Skip comments and empty lines
    if not line:match("^%s*#") and line:match("%S") then
      local key, value = line:match("^%s*(.-)%s*=%s*(.-)%s*$")
      if key and value then
        -- Remove quotes if present
        value = value:gsub("^[\"'](.-)[\"']$", "%1")
        env_vars[key] = value
      end
    end
  end

  file:close()
  return env_vars
end

return M
