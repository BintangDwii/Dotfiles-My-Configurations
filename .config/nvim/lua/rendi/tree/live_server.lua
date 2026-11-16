local M = {}

local servers = {}

local function root_for(node)
  local path = node.type == "directory" and node.absolute_path or vim.fs.dirname(node.absolute_path)
  return vim.fs.root(path, { ".git", "package.json", "index.html", "Cargo.toml" }) or path
end

local function free_port(preferred)
  for port = preferred, preferred + 20 do
    local ok, tcp = pcall(vim.uv.new_tcp)
    if ok and tcp then
      local bound = pcall(function() tcp:bind("127.0.0.1", port) end)
      if bound then
        local _, address = tcp:getsockname()
        tcp:close()
        if address and address.port == port then
          return port
        end
      end
    end
  end

  return preferred
end

local function fallback_open(path)
  if vim.fn.executable("xdg-open") == 1 then
    vim.fn.jobstart({ "xdg-open", path }, { detach = true })
  else
    vim.notify("No opener available for " .. path, vim.log.levels.WARN)
  end
end

function M.open_direct(node)
  if vim.ui.open then
    local ok = pcall(vim.ui.open, node.absolute_path)
    if ok then
      return
    end
  end

  fallback_open(node.absolute_path)
end

local function relative_url(node, root)
  local relative = vim.fs.relpath(root, node.absolute_path) or vim.fs.basename(node.absolute_path)
  relative = relative:gsub("\\", "/")
  if node.type == "directory" and not relative:match("/$") then
    relative = relative .. "/"
  end
  return (vim.uri_encode(relative):gsub("%%2[Ff]", "/"))
end

local function start(node, root)
  local port = free_port(5500)
  local job = vim.fn.jobstart({
    "python3",
    "-m",
    "http.server",
    tostring(port),
    "--bind",
    "127.0.0.1",
    "--directory",
    root,
  }, {
    detach = false,
    on_exit = function()
      if servers[root] and servers[root].port == port then
        servers[root] = nil
      end
    end,
  })

  if job <= 0 then
    vim.notify("Failed to start Live Server", vim.log.levels.ERROR)
    return
  end

  servers[root] = { job = job, port = port, root = root }
  return servers[root]
end

function M.is_running(node)
  return servers[root_for(node)] ~= nil
end

function M.label(node)
  return M.is_running(node) and "Stop Live Server" or "Start Live Server"
end

function M.toggle(node)
  local root = root_for(node)
  local server = servers[root]

  if server then
    vim.fn.jobstop(server.job)
    servers[root] = nil
    vim.notify("Live Server stopped: " .. root)
    return
  end

  server = start(node, root)
  if not server then
    return
  end

  local url = "http://127.0.0.1:" .. server.port .. "/" .. relative_url(node, root)
  if vim.ui.open then
    pcall(vim.ui.open, url)
  else
    vim.notify(url, vim.log.levels.INFO)
  end
  vim.notify("Live Server: " .. url)
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    for _, server in pairs(servers) do
      vim.fn.jobstop(server.job)
    end
  end,
})

return M
