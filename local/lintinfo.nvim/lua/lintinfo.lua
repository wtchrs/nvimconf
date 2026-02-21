-- lua/utils/lintinfo.lua
--
-- Inspect nvim-lint configuration in a LazyVim-friendly way.
-- This module focuses on:
--   1) Current-buffer "active" linters (LazyVim-style condition filtering).
--   2) Union of all linters referenced in lint.linters_by_ft (entire config).
--   3) Binary availability checks (configured but missing executable is reported).
--
-- Notes:
-- - nvim-lint itself does not know about `linter.condition(ctx)`. LazyVim (and user configs)
--   may add this field and filter before calling lint.try_lint().
-- - nvim-lint evaluates `cmd` / `args` functions with *no arguments* and inside the linter cwd.
--   This module mimics that when building the "effective" commandline preview.

local M = {}

-- ---------------------------------------------------------------------------
-- Small helpers
-- ---------------------------------------------------------------------------

local function normalize_bufnr(bufnr)
  if bufnr == nil or bufnr == 0 then
    return vim.api.nvim_get_current_buf()
  end
  return bufnr
end

local function dedupe_keep_order(list)
  local out, seen = {}, {}
  for _, v in ipairs(list or {}) do
    if v and v ~= "" and not seen[v] then
      seen[v] = true
      table.insert(out, v)
    end
  end
  return out
end

local function sorted_unique(list)
  local uniq = dedupe_keep_order(list)
  table.sort(uniq)
  return uniq
end

local function split_lines(s)
  return vim.split(s or "", "\n", { plain = true, trimempty = false })
end

local function append_inspect_block(lines, title, obj)
  table.insert(lines, "### " .. title)
  table.insert(lines, "```lua")
  vim.list_extend(lines, split_lines(vim.inspect(obj)))
  table.insert(lines, "```")
  table.insert(lines, "")
end

local function make_ctx(bufnr)
  bufnr = normalize_bufnr(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  return {
    bufnr = bufnr,
    filename = filename,
    dirname = vim.fn.fnamemodify(filename, ":h"),
  }
end

local function is_win()
  return vim.fn.has("win32") == 1
end

-- ---------------------------------------------------------------------------
-- Lazy-loading nvim-lint (LazyVim / lazy.nvim friendly)
-- ---------------------------------------------------------------------------

local function try_require_lint()
  local ok, lint = pcall(require, "lint")
  if ok then
    return lint
  end

  -- If lazy.nvim is available, try to load the plugin by name.
  local ok_lazy, lazy = pcall(require, "lazy")
  if ok_lazy and type(lazy.load) == "function" then
    pcall(lazy.load, { plugins = { "nvim-lint" } })
  end

  ok, lint = pcall(require, "lint")
  if ok then
    return lint
  end

  return nil
end

-- ---------------------------------------------------------------------------
-- Evaluate linter fields like nvim-lint does (no args; inside linter cwd)
-- ---------------------------------------------------------------------------

local function with_cwd(cwd, fn, ...)
  local cur = vim.fn.getcwd()
  local target = cwd
  local changed = target and target ~= "" and cur ~= target
  local mods = { noautocmd = true }

  if changed then
    vim.cmd.cd({ target, mods = mods })
  end

  local results = { pcall(fn, ...) }

  if changed then
    vim.cmd.cd({ cur, mods = mods })
  end

  local ok = table.remove(results, 1)
  return ok, table.unpack(results)
end

local function eval_noargs(value, cwd)
  if type(value) == "function" then
    local ok, res = with_cwd(cwd, value)
    if ok then
      return res, nil
    end
    return nil, tostring(res)
  end
  return value, nil
end

local function get_linter_cwd(linter)
  if not linter then
    return vim.fn.getcwd()
  end
  local cwd = linter.cwd
  if type(cwd) == "function" then
    local val, err = eval_noargs(cwd, vim.fn.getcwd())
    if err == nil and type(val) == "string" and val ~= "" then
      return val
    end
    return vim.fn.getcwd()
  end
  if type(cwd) == "string" and cwd ~= "" then
    return cwd
  end
  return vim.fn.getcwd()
end

local function cmd_to_bin(cmd_val)
  if type(cmd_val) == "string" then
    return cmd_val
  end
  if type(cmd_val) == "table" and type(cmd_val[1]) == "string" then
    return cmd_val[1]
  end
  return nil
end

-- ---------------------------------------------------------------------------
-- Linter resolution
-- ---------------------------------------------------------------------------

local function resolve_linter(lint, name)
  local l = lint.linters[name]
  if not l then
    return nil, "not_found"
  end

  -- nvim-lint supports linter factory functions (called with no args).
  if type(l) == "function" then
    local ok, res = pcall(l)
    if not ok then
      return nil, "factory_error: " .. tostring(res)
    end
    l = res
  end

  if type(l) ~= "table" then
    return nil, "invalid_type: " .. type(l)
  end

  return l, nil
end

local function resolve_names_for_ft(lint, ft)
  local names = {}

  -- Prefer the internal resolver when available.
  if type(lint._resolve_linter_by_ft) == "function" then
    local resolved = lint._resolve_linter_by_ft(ft)
    if type(resolved) == "table" then
      -- IMPORTANT: Copy the list to avoid mutating lint.linters_by_ft[ft].
      names = vim.list_extend({}, resolved)
    end
  else
    local byft = lint.linters_by_ft or {}
    local spec = byft[ft]
    if type(spec) == "table" then
      names = vim.list_extend({}, spec)
    elseif type(spec) == "string" then
      names = { spec }
    end
  end

  -- "_" is a fallback only when no other linters are configured for the filetype.
  if #names == 0 then
    local fallback = (lint.linters_by_ft or {})["_"]
    if type(fallback) == "table" then
      vim.list_extend(names, fallback)
    elseif type(fallback) == "string" then
      table.insert(names, fallback)
    end
  end

  -- "*" runs on all filetypes.
  do
    local global = (lint.linters_by_ft or {})["*"]
    if type(global) == "table" then
      vim.list_extend(names, global)
    elseif type(global) == "string" then
      table.insert(names, global)
    end
  end

  return dedupe_keep_order(names)
end

-- ---------------------------------------------------------------------------
-- Binary availability
-- ---------------------------------------------------------------------------

local function binary_status(linter)
  local cwd = get_linter_cwd(linter)
  local cmd_val, cmd_err = eval_noargs(linter.cmd, cwd)
  if cmd_err ~= nil then
    return {
      kind = "cmd_error",
      bin = nil,
      exepath = nil,
      cmd = nil,
      error = cmd_err,
    }
  end

  local bin = cmd_to_bin(cmd_val)
  if not bin then
    return {
      kind = "unknown",
      bin = nil,
      exepath = nil,
      cmd = cmd_val,
      error = nil,
    }
  end

  local exec_ok = (vim.fn.executable(bin) == 1)
  return {
    kind = exec_ok and "ok" or "missing",
    bin = bin,
    exepath = exec_ok and vim.fn.exepath(bin) or nil,
    cmd = cmd_val,
    error = nil,
  }
end

local function format_binary_status(st)
  if not st then
    return "UNKNOWN"
  end
  if st.kind == "ok" then
    return ("OK (%s)"):format(st.exepath or st.bin or "?")
  end
  if st.kind == "missing" then
    return ("MISSING (%s)"):format(st.bin or "?")
  end
  if st.kind == "cmd_error" then
    return ("UNKNOWN (cmd eval error: %s)"):format(st.error or "?")
  end
  return "UNKNOWN"
end

-- ---------------------------------------------------------------------------
-- Effective commandline preview (mirrors nvim-lint evaluation behavior)
-- ---------------------------------------------------------------------------

local function flatten_args(value, out)
  if value == nil then
    return out
  end
  if type(value) == "table" then
    for _, v in ipairs(value) do
      flatten_args(v, out)
    end
    return out
  end
  table.insert(out, tostring(value))
  return out
end

local function effective_spec(linter, bufnr)
  bufnr = normalize_bufnr(bufnr)
  local cwd = get_linter_cwd(linter)
  local filename = vim.api.nvim_buf_get_name(bufnr)

  local cmd, cmd_err = eval_noargs(linter.cmd, cwd)

  local args = {}
  local arg_errors = {}

  local raw_args = linter.args

  -- nvim-lint expects args to be a list of (string|fun():string), but be defensive.
  if type(raw_args) == "function" then
    local v, e = eval_noargs(raw_args, cwd)
    if e ~= nil then
      table.insert(arg_errors, "args(): " .. e)
      raw_args = nil
    else
      raw_args = v
    end
  end

  if type(raw_args) == "table" then
    for i, a in ipairs(raw_args) do
      local v, e = eval_noargs(a, cwd)
      if e ~= nil then
        table.insert(arg_errors, ("args[%d](): %s"):format(i, e))
      else
        flatten_args(v, args)
      end
    end
  elseif raw_args ~= nil then
    table.insert(arg_errors, "args: non-table value ignored (" .. type(raw_args) .. ")")
  end

  if not linter.stdin and linter.append_fname ~= false then
    table.insert(args, filename)
  end

  -- nvim-lint wraps the invocation on Windows using cmd.exe.
  if is_win() then
    local wrapped = { "/C", cmd }
    vim.list_extend(wrapped, args)
    cmd = "cmd.exe"
    args = wrapped
  end

  return {
    cmd = cmd,
    args = args,
    cwd = cwd,
    stdin = (linter.stdin == true),
    append_fname = (linter.append_fname ~= false),
    stream = linter.stream or "stdout",
    ignore_exitcode = (linter.ignore_exitcode == true),
    env = linter.env,
    parser = linter.parser,
    errors = {
      cmd = cmd_err,
      args = (#arg_errors > 0) and arg_errors or nil,
    },
  }
end

-- ---------------------------------------------------------------------------
-- Report rendering (buffers / windows)
-- ---------------------------------------------------------------------------

local function set_common_buf_opts(buf)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "markdown"
end

local function set_close_key(buf)
  vim.keymap.set("n", "q", "<cmd>close<cr>", {
    buffer = buf,
    silent = true,
    nowait = true,
    desc = "close",
  })
end

local function open_report(lines, opts)
  opts = opts or {}
  local mode = opts.open or "float" -- "float" | "split" | "tab"
  local title = opts.title or "nvim-lint info"

  if mode == "tab" then
    vim.cmd("tabnew")
    local buf = vim.api.nvim_get_current_buf()
    set_common_buf_opts(buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    set_close_key(buf)
    return
  end

  if mode == "split" then
    vim.cmd("new")
    local buf = vim.api.nvim_get_current_buf()
    set_common_buf_opts(buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    set_close_key(buf)
    return
  end

  -- Float (default)
  local buf = vim.api.nvim_create_buf(false, true)
  set_common_buf_opts(buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  set_close_key(buf)

  local width = math.max(20, math.floor(vim.o.columns * 0.85))
  local height = math.max(5, math.floor(vim.o.lines * 0.85))
  local row = math.max(0, math.floor((vim.o.lines - height) / 2))
  local col = math.max(0, math.floor((vim.o.columns - width) / 2))

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = "center",
  })
end

-- ---------------------------------------------------------------------------
-- 1) Current buffer: configured + active (condition) + binary status
-- ---------------------------------------------------------------------------

function M.collect_active(bufnr)
  bufnr = normalize_bufnr(bufnr)

  local lint = try_require_lint()
  if not lint then
    return { ok = false, error = "nvim-lint not available" }
  end

  local ft = vim.bo[bufnr].filetype or ""
  local ctx = make_ctx(bufnr)

  local names = resolve_names_for_ft(lint, ft)

  local configured = vim.list_extend({}, names)
  local active, disabled = {}, {}
  local missing_def = {}
  local status = {}
  local condition_errors = {}

  for _, name in ipairs(configured) do
    local linter, err = resolve_linter(lint, name)
    if not linter then
      table.insert(missing_def, { name = name, error = err })
    else
      status[name] = binary_status(linter)

      local cond = linter.condition
      if type(cond) == "function" then
        local ok, res = pcall(cond, { filename = ctx.filename, dirname = ctx.dirname })
        if not ok then
          table.insert(condition_errors, { name = name, error = tostring(res) })
          table.insert(disabled, name)
        elseif not res then
          table.insert(disabled, name)
        else
          table.insert(active, name)
        end
      else
        table.insert(active, name)
      end
    end
  end

  local running = {}
  if type(lint.get_running) == "function" then
    local ok_run, res = pcall(lint.get_running, bufnr)
    if ok_run and type(res) == "table" then
      running = res
    end
  end

  local active_missing_bin = {}
  for _, name in ipairs(active) do
    local st = status[name]
    if st and st.kind == "missing" then
      table.insert(active_missing_bin, name)
    end
  end
  active_missing_bin = dedupe_keep_order(active_missing_bin)

  return {
    ok = true,
    bufnr = bufnr,
    filetype = ft,
    filename = ctx.filename,
    dirname = ctx.dirname,
    vim_cwd = vim.fn.getcwd(),
    configured = configured,
    active = active,
    disabled = disabled,
    missing_def = missing_def,
    status = status,
    condition_errors = condition_errors,
    running = running,
    active_missing_bin = active_missing_bin,
  }
end

function M.show_active(bufnr, opts)
  opts = opts or {}
  local info = M.collect_active(bufnr)

  if not info.ok then
    vim.notify(info.error or "Failed to collect nvim-lint info", vim.log.levels.WARN)
    return
  end

  local lines = {}
  table.insert(lines, "# nvim-lint: Active linters (current buffer)")
  table.insert(lines, "")
  table.insert(lines, ("- bufnr: %d"):format(info.bufnr))
  table.insert(lines, ("- filetype: %s"):format(info.filetype ~= "" and info.filetype or "(none)"))
  table.insert(lines, ("- filename: %s"):format(info.filename ~= "" and info.filename or "(no name)"))
  table.insert(lines, ("- vim cwd: %s"):format(info.vim_cwd))
  table.insert(lines, ("- running: %s"):format(#info.running > 0 and table.concat(info.running, ", ") or "(none)"))
  table.insert(
    lines,
    ("- configured: %s"):format(#info.configured > 0 and table.concat(info.configured, ", ") or "(none)")
  )
  table.insert(
    lines,
    ("- active (condition passed): %s"):format(#info.active > 0 and table.concat(info.active, ", ") or "(none)")
  )
  table.insert(lines, "")

  if #info.disabled > 0 then
    table.insert(lines, "## Disabled by condition(ctx)")
    table.insert(lines, "")
    table.insert(lines, table.concat(info.disabled, ", "))
    table.insert(lines, "")
  end

  if #info.condition_errors > 0 then
    table.insert(lines, "## Condition errors")
    table.insert(lines, "")
    for _, e in ipairs(info.condition_errors) do
      table.insert(lines, ("- %s: %s"):format(e.name, e.error))
    end
    table.insert(lines, "")
  end

  if #info.missing_def > 0 then
    table.insert(lines, "## Missing / invalid linter definitions")
    table.insert(lines, "")
    for _, m in ipairs(info.missing_def) do
      table.insert(lines, ("- %s (%s)"):format(m.name, m.error))
    end
    table.insert(lines, "")
  end

  if #info.active_missing_bin > 0 then
    table.insert(lines, "## Active but binary is missing (will fail at runtime)")
    table.insert(lines, "")
    table.insert(lines, table.concat(info.active_missing_bin, ", "))
    table.insert(lines, "")
  end

  for _, name in ipairs(info.active) do
    local lint = try_require_lint()
    local linter = lint and lint.linters and lint.linters[name] or nil
    if type(linter) == "function" then
      local ok, res = pcall(linter)
      if ok then
        linter = res
      end
    end

    table.insert(lines, ("## %s"):format(name))
    table.insert(lines, "")

    local st = info.status[name]
    table.insert(lines, ("- binary: %s"):format(format_binary_status(st)))

    if type(linter) == "table" then
      table.insert(lines, ("- has condition(ctx): %s"):format(type(linter.condition) == "function" and "yes" or "no"))
      table.insert(lines, "")
      append_inspect_block(lines, "effective (preview)", effective_spec(linter, info.bufnr))
      append_inspect_block(lines, "raw", linter)
    else
      table.insert(lines, "- details: unavailable")
      table.insert(lines, "")
    end
  end

  open_report(lines, {
    open = opts.open or "float",
    title = opts.title or "LintInfo",
  })
end

-- Backward compatible aliases (if you used the previous function names).
M.collect = M.collect_active
M.show = M.show_active

-- ---------------------------------------------------------------------------
-- 2) Entire config: union of all configured linters + binary status
-- ---------------------------------------------------------------------------

local function normalize_linters_by_ft_entry(entry)
  if entry == nil then
    return {}
  end
  if type(entry) == "string" then
    return { entry }
  end
  if type(entry) == "table" then
    return entry
  end
  if type(entry) == "function" then
    -- Not part of nvim-lint's documented type, but handle defensively.
    local val, err = eval_noargs(entry, vim.fn.getcwd())
    if err ~= nil then
      return {}
    end
    return normalize_linters_by_ft_entry(val)
  end
  return {}
end

function M.collect_all_configured(opts)
  opts = opts or {}
  local lint = try_require_lint()
  if not lint then
    return { ok = false, error = "nvim-lint not available" }
  end

  local byft = lint.linters_by_ft or {}
  local refs = {} -- name -> { fts = {...} }
  local ft_keys = 0

  for ft, entry in pairs(byft) do
    ft_keys = ft_keys + 1
    local names = normalize_linters_by_ft_entry(entry)
    for _, name in ipairs(names) do
      if type(name) == "string" and name ~= "" then
        refs[name] = refs[name] or { fts = {} }
        table.insert(refs[name].fts, ft)
      end
    end
  end

  local all_names = {}
  for name, meta in pairs(refs) do
    meta.fts = sorted_unique(meta.fts)
    table.insert(all_names, name)
  end
  table.sort(all_names)

  local linters = {} -- name -> linter table
  local status = {} -- name -> binary status
  local missing_def = {}

  for _, name in ipairs(all_names) do
    local linter, err = resolve_linter(lint, name)
    if not linter then
      table.insert(missing_def, { name = name, error = err })
    else
      linters[name] = linter
      status[name] = binary_status(linter)
    end
  end

  return {
    ok = true,
    vim_cwd = vim.fn.getcwd(),
    total_filetype_keys = ft_keys,
    names = all_names,
    refs = refs,
    linters = linters,
    status = status,
    missing_def = missing_def,
  }
end

function M.show_all(opts)
  opts = opts or {}
  local info = M.collect_all_configured(opts)

  if not info.ok then
    vim.notify(info.error or "Failed to collect nvim-lint config", vim.log.levels.WARN)
    return
  end

  local lines = {}
  table.insert(lines, "# nvim-lint: All configured linters (union) + binary availability")
  table.insert(lines, "")
  table.insert(lines, ("- vim cwd: %s"):format(info.vim_cwd))
  table.insert(lines, ("- linters_by_ft keys: %d"):format(info.total_filetype_keys))
  table.insert(lines, ("- unique configured linters: %d"):format(#info.names))
  table.insert(lines, "")

  if #info.missing_def > 0 then
    table.insert(lines, "## Configured but linter definition is missing/invalid")
    table.insert(lines, "")
    for _, m in ipairs(info.missing_def) do
      table.insert(lines, ("- %s (%s)"):format(m.name, m.error))
    end
    table.insert(lines, "")
  end

  do
    local missing_bin = {}
    for _, name in ipairs(info.names) do
      local st = info.status[name]
      if st and st.kind == "missing" then
        table.insert(missing_bin, name)
      end
    end
    missing_bin = dedupe_keep_order(missing_bin)

    if #missing_bin > 0 then
      table.insert(lines, "## Configured but binary is missing (will not run)")
      table.insert(lines, "")
      table.insert(lines, table.concat(missing_bin, ", "))
      table.insert(lines, "")
    end
  end

  for _, name in ipairs(info.names) do
    table.insert(lines, ("## %s"):format(name))
    table.insert(lines, "")

    local fts = (info.refs[name] and info.refs[name].fts) or {}
    table.insert(lines, ("- configured for: %s"):format(#fts > 0 and table.concat(fts, ", ") or "(unknown)"))

    local linter = info.linters[name]
    if not linter then
      table.insert(lines, "- status: definition missing")
      table.insert(lines, "")
    else
      local st = info.status[name]
      table.insert(lines, ("- binary: %s"):format(format_binary_status(st)))
      table.insert(lines, ("- has condition(ctx): %s"):format(type(linter.condition) == "function" and "yes" or "no"))
      table.insert(lines, "")

      -- Use current buffer for filename preview (only affects the appended filename argument).
      append_inspect_block(lines, "effective (preview)", effective_spec(linter, 0))
      append_inspect_block(lines, "raw", linter)
    end
  end

  open_report(lines, {
    open = opts.open or "float",
    title = opts.title or "LintInfoAll",
  })
end

-- ---------------------------------------------------------------------------
-- Optional: command registration
-- ---------------------------------------------------------------------------

local function safe_create_user_command(name, fn, opts)
  local ok, err = pcall(vim.api.nvim_create_user_command, name, fn, opts)
  if ok then
    return
  end
  -- Ignore "command already exists" errors.
  if type(err) == "string" and err:match("E174") then
    return
  end
end

function M.setup_commands()
  safe_create_user_command("LintInfo", function(cmdopts)
    local open = (cmdopts.args ~= "" and cmdopts.args) or "float"
    M.show_active(0, { open = open, title = "LintInfo" })
  end, {
    desc = "Show current-buffer active nvim-lint linters (incl. binary status)",
    nargs = "?",
    complete = function()
      return { "float", "split", "tab" }
    end,
  })

  safe_create_user_command("LintInfoAll", function(cmdopts)
    local open = (cmdopts.args ~= "" and cmdopts.args) or "float"
    M.show_all({ open = open, title = "LintInfoAll" })
  end, {
    desc = "Show union of all configured nvim-lint linters (incl. missing binaries)",
    nargs = "?",
    complete = function()
      return { "float", "split", "tab" }
    end,
  })
end

return M
