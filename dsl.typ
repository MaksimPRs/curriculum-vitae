// ---------------------------- Theme ---------------------------------
// Tune the whole document from here; the components below only read it.
#let theme = (
  font: "New Computer Modern",
  body-size: 11pt,
  name-size: 16pt,
  contact-size: 11pt,
  heading-size: 16pt,
  rule-stroke: 0.5pt,
)

#let cv-theme(body) = {
  set page(paper: "a4", margin: (x: 7.5mm, top: 7.5mm, bottom: 7.5mm))
  set text(font: theme.font, size: theme.body-size, lang: "en")
  set par(justify: true, leading: 0.45em, spacing: 1.38em)
  set list(marker: ([•], [◦]), indent: 0.5em, body-indent: 0.6em, spacing: 0.45em, tight: true)
  // Delete this line for plain black links instead of blue underlined ones.
  show link: it => underline(text(it, blue), stroke: 0.4pt + rgb("#0074d9"), offset: 2.5pt)
  body
}

// ---------------------------- Components ----------------------------
// Array of strings/content -> "a<sep>b<sep>c"; anything else passes through.
#let as-text(x, sep: ", ") = if type(x) == array { x.join(sep) } else { x }

// `duration` as a (start, end) tuple of datetimes; either side may be `none`.
//   (datetime(2024, 12, 1), none)                   -> "Dec 2024 — Present"
//   (datetime(2022, 1, 1), datetime(2024, 11, 1))   -> "Jan 2022 — Nov 2024"
// Plain strings still pass through, so existing entries keep working.
#let format-duration(span) = {
  if span == none { return none }
  if type(span) != array { return span }
  let fmt(d) = if d == none { "Present" } else { d.display("[month repr:short] [year]") }
  let (from, to) = span
  if from == none and to == none { return [] }
  if from == none { return to.display("[year]") }
  fmt(from) + " — " + fmt(to)
}

// Section title + hairline rule.
#let heading(title) = block(above: 1.5em, below: 1.0em, stack(
  spacing: 0.50em,
  align(center, text(size: theme.heading-size, title)),
  line(length: 100%, stroke: theme.rule-stroke),
))

// Generic section: #section("Projects")[ ...body... ]
#let section(title, ..body) = {
  heading(title)
  body.pos().join()
}

// Page head. NB: shadows Typst's built-in `header` page element — rename to
// cv-header if you ever want running page headers.
#let name-in-header(name) = block(
  above: 0pt,
  below: 1.25em,
  width: 100%,
  align(center, text(size: theme.name-size, name)),
)

// Two-sided contact line: `left` sits flush left, `right` flush right.
//   #contact-info(
//     content-left:  ("Country", "City"),
//     content-right: (link("mailto:…")[email], link("https://…")[LinkedIn]),
//   )
// NB: the parameters are called left/right, which shadows Typst's `left`/`right`
// alignment constants inside this body — hence `start`/`end` below.
#let contact-info(content-left: (), content-right: (), sep: " · ") = block(
  above: 0pt,
  below: 1.25em,
  width: 100%,
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    {
      set text(size: theme.contact-size)
      as-text(content-left, sep: sep)
    },
    {
      set text(size: theme.contact-size)
      as-text(content-right, sep: sep)
    },
  ),
)

// One job / degree / position. Every field except `position` is optional.
//   duration:     (datetime(2024, 12, 1), none)                // "Dec 2024 — Present"
//   achievements: ("shipped x", "wrote y", ("sub a", "sub b"))
// Strings in `achievements` are bulleted and capitalized; content is kept as-is.
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
      columns: (1fr, auto),
      align: (left + horizon, right + horizon),
      text(weight: "bold", position),
      if dates == none { [] } else { format-duration(dates) },
    ),
  )
  // `rows + (x,)` instead of `rows.push(x)`: concatenation behaves the same in
  // every Typst version, whereas push() changed semantics between releases.
  if company != none { rows = rows + (text(weight: "bold", company),) }
  if achievements != none { rows = rows + (achievements,) }
  if tech-stack != none { rows = rows + (text(weight: "bold", "Tech Stack: ") + as-text(tech-stack),) }
  block(above: 0em, below: 1.5em, stack(spacing: 0.75em, ..rows))
}

// A section that is just a title plus a list of entries.
#let summary(title: "Summary", ..body) = section(title, ..body)
#let experience(title: "Experience", ..entries) = section(title, ..entries)
#let education(title: "Education", ..entries) = section(title, ..entries)

// Labeled one-line entries: #skills(Languages: ("Rust", "Java"), Tools: "…")
// Every named argument becomes "Label — items"; arrays and strings both work.
#let skills(title: "Skills", ..categories) = section(title,
  for (label, items) in categories.named() {
    block(above: 0.55em, below: 0pt)[*#label*: #as-text(items)]
  },
)

