# slide-sub-heading

> [!NOTE]
> Built with AI

Quarto extension (pandoc Lua filter) that turns headings below the slide level
into slides of their own.

A slide has no sub-headings: a `###` under a `##` would simply sit in the middle
of the slide in reveal.js and friends. The filter flattens such headings onto
the slide level and prefixes the titles of their ancestor headings.

> [!WARNING]
> Built for my own presentations. Fit for that, not promised to
> fit anything else.

```markdown
## Networking

### DNS
```

becomes two slides, the second one titled `Networking - DNS`.

## Installation

```bash
quarto add huesken-consulting/quarto-slide-sub-heading
```

Or copy the directory `_extensions/slide-sub-heading` into your own project.

## Usage

List the filter in the document or in `_quarto.yml`:

```yaml
---
format: revealjs
filters:
  - slide-sub-heading
---
```

Outside a reveal.js deck the filter does nothing: on an html page or in the
LaTeX target the outline stays as written. Flattening only exists because a
slide has no sub-headings -- in a document it would produce long title chains
and bloat the table of contents. That check is what lets a project list the
filter once in `_quarto.yml` for all its formats.

## Slide level

The slide level defaults to 2 and follows Quarto's own `slide-level` option:

```yaml
---
format: revealjs
slide-level: 3
filters:
  - slide-sub-heading
---
```

With that, `###` headings stay slides of their own and only `####` is flattened.

## Tests

```bash
tests/run.sh            # all cases
tests/run.sh latex      # only cases whose name contains the pattern
tests/run.sh --update   # rewrite expected.txt
```

Golden-file tests: each case under `tests/cases/` consists of `input.qmd`, an
optional `format` file (target format, default `revealjs`) and the recorded output
in `expected.txt`. Rendering uses plain pandoc -- `tests/quarto-stub.lua`
provides the `quarto` global the filter needs for `quarto.doc.is_format`.
