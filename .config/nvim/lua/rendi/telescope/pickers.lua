local M = {}

local function builtin(name, opts)
  return function()
    require("telescope.builtin")[name](opts or {})
  end
end

local regex_magic = {
  ["\\"] = true,
  ["."] = true,
  ["^"] = true,
  ["$"] = true,
  ["|"] = true,
  ["?"] = true,
  ["*"] = true,
  ["+"] = true,
  ["("] = true,
  [")"] = true,
  ["["] = true,
  ["]"] = true,
  ["{"] = true,
  ["}"] = true,
}

local fd_args = {
  "--type",
  "f",
  "--hidden",
  "--color",
  "never",
  "--exclude",
  ".git",
  "--exclude",
  "node_modules",
  "--exclude",
  "target",
  "--exclude",
  "dist",
  "--exclude",
  "build",
  "--exclude",
  ".cache",
}

-- Convert "src auth" into an fd-compatible fuzzy regex such as
-- "s.*r.*c.*a.*u.*t.*h". Filtering happens in fd before Telescope sees data.
local function fd_fuzzy_pattern(prompt)
  local parts = {}

  for _, char in ipairs(vim.fn.split(prompt or "", [[\zs]])) do
    if not char:match("%s") then
      if regex_magic[char] then
        char = "\\" .. char
      end
      parts[#parts + 1] = char
    end
  end

  if #parts == 0 then
    return nil
  end

  return table.concat(parts, ".*")
end

-- Query-driven file picker:
--   * starts empty, so opening it does not enumerate the repository
--   * cancels/restarts fd whenever the prompt changes
--   * externally prefilters and caps results before they enter Telescope
local function progressive_files(opts)
  opts = vim.tbl_deep_extend("force", {
    cwd = vim.uv.cwd(),
    max_results = 800,
    prompt_title = "Find Files",
    disable_devicons = false,
  }, opts or {})

  local fd = vim.fn.exepath("fd")
  if fd == "" then
    vim.notify("progressive_files requires fd; using Telescope find_files", vim.log.levels.WARN)
    require("telescope.builtin").find_files({
      cwd = opts.cwd,
      hidden = true,
      follow = false,
      disable_devicons = false,
    })
    return
  end

  local finders = require("telescope.finders")
  local make_entry = require("telescope.make_entry")
  local pickers = require("telescope.pickers")
  local conf = require("telescope.config").values

  pickers
    .new(opts, {
      prompt_title = opts.prompt_title,
      finder = finders.new_job(function(prompt)
        local pattern = fd_fuzzy_pattern(prompt)
        if not pattern then
          return nil
        end

        local args = vim.deepcopy(fd_args)
        table.insert(args, 4, "--full-path")

        local command = { fd }
        vim.list_extend(command, args)
        vim.list_extend(command, {
          "--max-results",
          tostring(opts.max_results),
          pattern,
          ".",
        })

        return command
      end, opts.entry_maker or make_entry.gen_from_file(opts), opts.max_results, opts.cwd),
      sorter = conf.file_sorter(opts),
      previewer = conf.file_previewer(opts),
    })
    :find()
end

-- Complete repository search for the rare case where the bounded progressive
-- picker does not find what you need. git ls-files is fastest inside Git repos.
local function complete_files()
  local cwd = vim.uv.cwd()
  local git_root = vim.fs.root(cwd, ".git")
  local telescope_builtin = require("telescope.builtin")

  if git_root then
    telescope_builtin.git_files({
      cwd = git_root,
      show_untracked = true,
      recurse_submodules = false,
      disable_devicons = false,
    })
    return
  end

  telescope_builtin.find_files({
    cwd = cwd,
    hidden = true,
    follow = false,
    disable_devicons = false,
  })
end

M.builtin = builtin
M.progressive_files = progressive_files
M.complete_files = complete_files
M.fd_args = fd_args

return M
