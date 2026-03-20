#let rustikon(body) = {
  set page(
    width: 16cm,
    height: 9cm,
    margin: (
      top: 1.5cm,
      bottom: 0.25cm,
      rest: 1cm,
    ),
    fill: black,
    background: {
      place(
        top + left,
        dx: 0.6cm,
        dy: 0.5cm,
        image("rustikon-logo.png", width: 3.4cm),
      )
      place(
        top + right,
        dx: -0.5cm,
        dy: 0.5cm,
        image("logo.svg", width: 2.5cm),
      )
    },
  )

  // show heading: set text(fill: white)

  set align(center + horizon)
  set text(
    fill: white,
    font: "Iosevka",
    size: 24pt,
    weight: "bold",
  )

  show raw.where(block: true): it => {
    // set text(size: 12pt)
    block(
      fill: luma(30),
      radius: 6pt,
      inset: 6pt,
      width: 100%,
      {
        set align(left)
        grid(
          columns: (auto, 1fr),
          gutter: 0.5em,
          ..it.lines.map(line => (
            text(fill: luma(100), str(line.number)),
            line,
          )).flatten()
        )
      },
    )
  }

  body
}

#let block-with-offset(body, offset: 0) = {
  show raw.where(block: true): it => {
    block(
      fill: luma(30),
      radius: 6pt,
      inset: 6pt,
      width: 100%,
      {
        set align(left)
        grid(
          columns: (auto, 1fr),
          gutter: 0.5em,
          ..it.lines.map(line => (
            text(fill: luma(100), str(line.number + offset)),
            line,
          )).flatten()
        )
      },
    )
  }

  body
}

#let slide(..args, body) = {
  pagebreak()

  let named = args.named()
  if named.len() > 0 {
    set text(..named)
    body
  } else {
    body
  }
}

#let slide2(left: none, right: none) = {
  pagebreak()

  grid(
    columns: (1fr, auto, 1fr),
    gutter: 0.5em,
    left,
    line(stroke: 0.5pt + white, angle: 90deg, length: 100%),
    right,
  )
}

#let slide2flow(body) = {
  pagebreak()

  place(center, line(stroke: 0.5pt + white, angle: 90deg, length: 100%))
  columns(2, gutter: 1em, body)
}

#let title-slide(title, subtitle: none) = {
  text(size: 1em)[#title]

  if subtitle != none {
    v(0.25em)
    text(size: 0.75em)[#subtitle]
  }
}
