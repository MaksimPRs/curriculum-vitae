// ---------------------------- Theme ---------------------------------
// Every style knob lives in this one dictionary; the components below read
// from it and never hard-code a length, size or colour.
//
// Groups whose keys match a function's parameters are spread straight into it,
// so a rule costs one line instead of one line per parameter:
//
//   theme.page    -> set page(..theme.page)
//   theme.text    -> set text(..theme.text)
//   theme.par     -> set par(..theme.par)
//   theme.list    -> set list(..theme.list)
//   theme.block   -> block(..theme.block)            (via `cv-block`)
//   theme.heading -> cv-block(..theme.heading, …)    (overrides the frame)
//   theme.entry   -> cv-block(..theme.entry, …)
//   theme.skills  -> cv-block(..theme.skills)…
//   theme.grid    -> grid(..theme.grid, …)
//
// The rest are plain lookups: sizes, weight, gap, rule, link, align,
// separator, duration, labels.

#let defaults = (
  indent: 0.5em,
  spacing: 0.5em,
)
#let theme = (
  // ---- page format & paddings --------------------------------------
  page: (
    paper: "a4",
    margin: (x: 7.5mm, top: 7.5mm, bottom: 7.5mm),
  ),

  // ---- body text ---------------------------------------------------
  text: (
    font: "New Computer Modern",
    lang: "en",
    size: 11pt,
  ),

  // ---- sizes of the other lines ------------------------------------
  sizes: (
    name: 16pt,
    contact: 10pt,
    heading: 15pt,
  ),

  // ---- paragraphs --------------------------------------------------
  par: (
    justify: true,
    leading: defaults.spacing,
    spacing: 1.5em, // unknown effect
  ),

  // ---- list markers & indents --------------------------------------
  // `marker` cycles by nesting depth (level 1, level 2, …).
  list: (
    marker: ([•], [◦]),
    indent: defaults.indent,
    body-indent: defaults.indent,
    spacing: defaults.spacing,
    tight: true,
  ),

  // ---- shared block frame ------------------------------------------
  // Every block starts from these three; a component below overrides only the
  // side that differs, so the common paddings stay defined in one place.
  block: (
    above: 0em, // space before the block
    below: 1.5em, // space after the block
    width: 100%,
  ),
  heading: (above: 1.5em, below: 1.0em),
  entry: (below: 1.5em),
  skills: (above: 0.5em, below: 0pt),

  // ---- gaps inside those blocks ------------------------------------
  gap: (
    heading: defaults.spacing, // space between title -> rule
    entry: 0.75em,  // position line -> company -> bullets
  ),

  // ---- two-column rows ---------------------------------------------
  // Contact line and entry headers.
  grid: (
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
  ),

  // ---- hairlines ---------------------------------------------------
  rule: (
    length: 100%,
    stroke: 0.5pt,
  ),

  // ---- links -------------------------------------------------------
  link: (
    color: rgb("#0074d9"),
    stroke: 0.4pt,
    offset: 2.5pt,
  ),

  // ---- alignment of single lines -----------------------------------
  align: (
    header: center,
    heading: center,
  ),

  // ---- separators for joined arrays --------------------------------
  separator: (
    items: ", ",
    contact: " · ",
  ),

  // ---- date ranges -------------------------------------------------
  duration: (
    format: "[month repr:short] [year]",
    year-format: "[year]",
    separator: " — ",
  ),
)

// One scope in which the document gets the theme above. Module-level
// `#set`/`#show` rules never leave this file, hence the wrapper:
//   #import "dsl.typ": *
//   #show: cv-theme
#let cv-theme(body) = {
  set page(..theme.page)
  set text(..theme.text)
  set par(..theme.par)
  set list(..theme.list)
  // Delete this line for plain black links instead of blue underlined ones.
  show link: it => underline(
    text(it, theme.link.color),
    stroke: theme.link.stroke + theme.link.color,
    offset: theme.link.offset,
  )
  body
}

// ---------------------------- Components ----------------------------
// Frame shared by every block: `theme.block`, overridden by extra arguments.
#let cv-block(body, ..overrides) = block(..theme.block, ..overrides, body)

// Emphasis: positions, companies, labels.
#let bold(x) = text(weight: "bold", x)

// Array of strings/content -> "a<sep>b<sep>c"; anything else passes through.
#let join-as-text(x, sep: theme.separator.items) = if type(x) == array { x.join(sep) } else { x }

// `duration` as a (start, end) tuple of datetimes; either side may be `none`.
//   (ym(2024, 12), none)                    -> "Dec 2024 — Present"
//   (ym(2022, 1), ym(2024, 11))             -> "Jan 2022 — Nov 2024"
// The strings are `theme.duration.*`. Plain strings still pass through, so
// existing entries keep working.
#let format-duration(span) = {
  if span == none { return none }
  if type(span) != array { return span }
  let fmt(d) = if d == none {
    "Present"
  } else {
    d.display(theme.duration.format)
  }
  let (from, to) = span
  if from == none and to == none { return [] }
  if from == none { return to.display(theme.duration.year-format) }
  fmt(from) + theme.duration.separator + fmt(to)
}

// First letter upper-case, rest untouched. Strings only: content carries markup.
#let capitalize(s) = if type(s) == str { upper(s.slice(0, 1)) + s.slice(1) } else { s }

// Array of strings/content -> bullet list; a nested array becomes a sub-list.
// Strings are capitalised, content is rendered verbatim. Markers and indents
// come from `theme.list` via `set list` in `cv-theme`.
#let bullets(..items) = {
  let lift(item) = if type(item) == array { bullets(..item) } else { capitalize(item) }
  list(..items.pos().map(lift))
}

// Typst needs a complete date, so fill in the first day of the month.
#let ym(year, month) = datetime(year: year, month: month, day: 1)

// Section title + hairline rule.
#let heading(title) = cv-block(
  ..theme.heading,
  stack(
    spacing: theme.gap.heading,
    align(theme.align.heading, text(size: theme.sizes.heading, title)),
    line(..theme.rule),
  ),
)

// Generic section: #section("Projects")[ ...body... ]
#let section(title, ..body) = {
  heading(title)
  body.pos().join()
}

// Page head. Named `name-in-header`, not `header`, so it does not shadow
// Typst's built-in page `header` element.
#let name-in-header(name) = cv-block(
  align(theme.align.header, text(size: theme.sizes.name, name)),
)

// Two-sided contact line: `content-left` sits flush left, `content-right` flush
// right.
//   #contact-info(
//     content-left:  ("Country", "City"),
//     content-right: (link("mailto:…")[email], link("https://…")[LinkedIn]),
//   )
// NB: the parameters are not called left/right because those names shadow
// Typst's `left`/`right` alignment constants inside this body.
#let contact-info(content-left: (), content-right: (), sep: theme.separator.contact) = cv-block(
  text(size: theme.sizes.contact, grid(
    ..theme.grid,
    join-as-text(content-left, sep: sep),
    join-as-text(content-right, sep: sep),
  )),
)

// One job / degree / position. Every field except `position` is optional.
//   duration:     (ym(2024, 12), none)                         // "Dec 2024 — Present"
//   achievements: ("shipped x", "wrote y", ("sub a", "sub b"))
// Rows are stacked so a wrapped bullet keeps its hanging indent (wrapping a
// list in a block with explicit `below` misplaces it — Typst quirk).
#let entry(
  position: none,
  company: none,
  dates: none,
  achievements: none,
  tech-stack: none,
) = {
  let rows = (
    grid(
      ..theme.grid,
      bold(position),
      if dates == none { [] } else { format-duration(dates) },
    ),
    if company != none { bold(company) },
    if achievements != none {
      if type(achievements) == array { bullets(..achievements) } else { achievements }
    },
    if tech-stack != none { bold("Tech Stack: ") + join-as-text(tech-stack) },
  ).filter(row => row != none) // optional fields that were left out
  cv-block(..theme.entry, stack(spacing: theme.gap.entry, ..rows))
}

// A section that is just a title plus a list of entries.
#let summary(title: "Summary", ..body) = section(title, ..body)
#let experience(title: "Experience", ..entries) = section(title, ..entries)
#let education(title: "Education", ..entries) = section(title, ..entries)

// Labeled one-line entries: #skills(Languages: ("Rust", "Java"), Tools: "…")
// Every named argument becomes "Label: items"; arrays and strings both work.
#let skills(title: "Skills", ..categories) = section(title,
  for (label, items) in categories.named() {
    cv-block(..theme.skills)[#bold(label): #join-as-text(items)]
  },
)
