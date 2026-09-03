-- Quarto filter: headings below the slide level become slides of their own.
--
-- A slide has no sub-headings. Anything deeper than the slide level is
-- therefore flattened onto the slide level, with the titles of its ancestor
-- headings prefixed: "## Networking" plus "### DNS" turns into the slide
-- "Networking - DNS".
--
-- The filter ships as an extension and has to be listed under `filters:` in the
-- document or the project -- see README.md.

local slide_level = 2
local heading_texts = {}

function Meta(meta)
  if meta["slide-level"] then
    slide_level = tonumber(pandoc.utils.stringify(meta["slide-level"])) or 2
  end
end

function Header(el)
  -- Only in a reveal.js deck. Everywhere else -- an html page, the LaTeX
  -- target -- the outline stays as written: flattening onto the slide level
  -- only exists because a slide has no sub-headings. In a document it would
  -- produce chains like "Setup - Networking - DNS" and bloat the table of
  -- contents. Checking the format here lets a project list the filter once in
  -- `_quarto.yml` for all its output formats.
  if not quarto.doc.is_format("revealjs") then
    return nil
  end

  local level = el.level
  local this_text = pandoc.utils.stringify(el.content)

  -- A heading at this level resets all deeper tracked headings
  for i = level + 1, 10 do
    heading_texts[i] = nil
  end
  heading_texts[level] = this_text

  if level <= slide_level then
    return el
  end

  -- Deeper than slide level: flatten and prefix with ancestor titles
  local parts = {}
  for i = slide_level, level do
    if heading_texts[i] then
      parts[#parts + 1] = heading_texts[i]
    end
  end

  return pandoc.Header(slide_level, {pandoc.Str(table.concat(parts, " - "))}, el.attr)
end

-- Two passes instead of one: in pandoc's default order `Meta` runs after the
-- `Header`s, so `slide-level` would only be read once everything is already
-- flattened. As a list of filters the metadata pass completes before the
-- heading pass starts.
return {
  {Meta = Meta},
  {Header = Header},
}
