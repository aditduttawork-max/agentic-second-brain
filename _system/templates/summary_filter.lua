-- Pandoc Lua filter for SUMMARIZE PDFs.
-- Used with _system/templates/summary_template.tex.
-- 1. Obsidian callouts ("> [!type] Title") become boxed "callout" environments.
-- 2. Tables become longtables with full borders.
-- Raw LaTeX is produced here, so the Markdown itself never contains LaTeX.

local function is_latex()
  return FORMAT:match("latex") ~= nil
end

local function to_latex(blocks)
  local s = pandoc.write(pandoc.Pandoc(blocks), "latex")
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  return s
end

-- Callouts -----------------------------------------------------------------

function BlockQuote(el)
  if not is_latex() then return nil end
  local first = el.content[1]
  if not first or (first.t ~= "Para" and first.t ~= "Plain") then return nil end
  local inl = first.content
  if #inl == 0 or inl[1].t ~= "Str" then return nil end
  local kind, rest = inl[1].text:match("^%[!([%w%-]+)%][%+%-]?(.*)$")
  if not kind then return nil end

  -- Title: the rest of the first line. Body: everything after it.
  local title = pandoc.List()
  if rest ~= "" then title:insert(pandoc.Str(rest)) end
  local i = 2
  while i <= #inl and inl[i].t ~= "SoftBreak" and inl[i].t ~= "LineBreak" do
    title:insert(inl[i])
    i = i + 1
  end
  while #title > 0 and title[1].t == "Space" do title:remove(1) end

  local title_tex
  if #title == 0 then
    title_tex = kind:sub(1, 1):upper() .. kind:sub(2):lower()
  else
    title_tex = to_latex({ pandoc.Plain(title) })
  end

  local body = pandoc.List()
  local body_inl = pandoc.List()
  for j = i + 1, #inl do body_inl:insert(inl[j]) end
  if #body_inl > 0 then body:insert(pandoc.Para(body_inl)) end
  for j = 2, #el.content do body:insert(el.content[j]) end

  local out = pandoc.List()
  out:insert(pandoc.RawBlock("latex", "\\begin{callout}{" .. title_tex .. "}"))
  out:extend(body)
  out:insert(pandoc.RawBlock("latex", "\\end{callout}"))
  return out
end

-- Tables -------------------------------------------------------------------

local function cell_text_len(blocks)
  return #pandoc.utils.stringify(blocks)
end

local function cell_tex(blocks)
  local s = to_latex(blocks)
  s = s:gsub("\n%s*\n", " \\par ")
  return s
end

function Table(tbl)
  if not is_latex() then return nil end
  local st = pandoc.utils.to_simple_table(tbl)
  local n = #st.aligns
  if n == 0 then return nil end

  -- Column widths: pandoc's relative widths, or shares based on content length.
  local widths = {}
  local total = 0
  for k = 1, n do total = total + (st.widths[k] or 0) end
  if total > 0 then
    for k = 1, n do widths[k] = (st.widths[k] or 0) / total end
  else
    local lens, sum = {}, 0
    for k = 1, n do
      local m = cell_text_len(st.headers[k] or {})
      for _, row in ipairs(st.rows) do m = math.max(m, cell_text_len(row[k] or {})) end
      m = math.min(math.max(m, 6), 45)
      lens[k] = m
      sum = sum + m
    end
    for k = 1, n do widths[k] = lens[k] / sum end
  end

  local align_cmd = {
    AlignLeft = "\\raggedright",
    AlignRight = "\\raggedleft",
    AlignCenter = "\\centering",
    AlignDefault = "\\raggedright",
  }
  local avail = string.format(
    "\\dimexpr\\linewidth-%d\\tabcolsep-%d\\arrayrulewidth\\relax", 2 * n, n + 1)
  local spec = { "|" }
  for k = 1, n do
    local a = align_cmd[tostring(st.aligns[k])] or "\\raggedright"
    spec[#spec + 1] = string.format(">{%s\\arraybackslash}p{%.3f%s}|", a, widths[k], avail)
  end

  local function row_tex(cells, bold)
    local parts = {}
    for k = 1, n do
      local c = cell_tex(cells[k] or {})
      if bold and c ~= "" then c = "\\textbf{" .. c .. "}" end
      parts[#parts + 1] = c
    end
    return table.concat(parts, " & ") .. " \\\\ \\hline"
  end

  local has_header = false
  for k = 1, n do
    if st.headers[k] and #st.headers[k] > 0 then has_header = true end
  end

  local lines = { "\\begin{longtable}{" .. table.concat(spec) .. "}", "\\hline" }
  if has_header then
    lines[#lines + 1] = row_tex(st.headers, true)
    lines[#lines + 1] = "\\endhead"
  end
  for _, row in ipairs(st.rows) do lines[#lines + 1] = row_tex(row, false) end
  lines[#lines + 1] = "\\end{longtable}"
  return pandoc.RawBlock("latex", table.concat(lines, "\n"))
end
