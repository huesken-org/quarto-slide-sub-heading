-- Stand-in for the `quarto` global that Quarto injects into filters.
--
-- slide-sub-heading.lua calls `quarto.doc.is_format`, which plain pandoc does
-- not provide, so the tests load this wrapper instead of the filter itself: it
-- defines just enough of `quarto` to answer that one question, then loads the
-- real filter and passes its list of filter passes on to pandoc unchanged.
--
-- TEST_FILTER  path of the filter to load
-- TEST_FORMAT  format `quarto.doc.is_format` reports (see the `format` file of
--              a test case; default revealjs)

local format = os.getenv("TEST_FORMAT") or "revealjs"

quarto = {
  doc = {
    is_format = function(f)
      return f == format
    end,
  },
}

return dofile(assert(os.getenv("TEST_FILTER"), "TEST_FILTER is not set"))
