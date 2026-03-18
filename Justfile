main := "main.typ"
filename := "slides.pdf"

default:
  @just --list

compile:
  typst compile {{ main }} {{ filename }}

watch:
  typst watch {{ main }} {{ filename }}

alias c := compile
alias w := watch
