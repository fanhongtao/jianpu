\version "2.18.2"

headZero        = {
\once \override Rest.stencil = #ly:text-interface::print
\once \override Rest.text = #(markup #:musicglyph "zero") }
headOne        = {
\once \override NoteHead.stencil = #ly:text-interface::print
\once \override NoteHead.text = #(markup #:musicglyph "one") }
headTwo        = {
\once \override NoteHead.stencil = #ly:text-interface::print
\once \override NoteHead.text = #(markup #:musicglyph "two") }
headThree        = {
\once \override NoteHead.stencil = #ly:text-interface::print
\once \override NoteHead.text = #(markup #:musicglyph "three") }
headFour        = {
\once \override NoteHead.stencil = #ly:text-interface::print
\once \override NoteHead.text = #(markup #:musicglyph "four") }
headFive        = {
\once \override NoteHead.stencil = #ly:text-interface::print
\once \override NoteHead.text = #(markup #:musicglyph "five") }
headSix        = {
\once \override NoteHead.stencil = #ly:text-interface::print
\once \override NoteHead.text = #(markup #:musicglyph "six") }
headSeven        = {
\once \override NoteHead.stencil = #ly:text-interface::print
\once \override NoteHead.text = #(markup #:musicglyph "seven") }
notedot=\markup{\hspace #0.5 \draw-circle #0.3 #0 ##t}
jianpuStem=\markup{ \override #'(thickness . 3) \draw-line#'(1 . 0)}
jianpuRestBar={
\once \override Rest.Y-offset = #-0.3
\once \override Rest.stencil = #ly:text-interface::print
\once \override Rest.text = #(markup #:musicglyph "rests.1")}
jianpuNoteBar={
\once \override NoteHead.Y-offset = #-0.3
\once \override NoteHead.stencil = #ly:text-interface::print
\once \override NoteHead.text = #(markup #:musicglyph "rests.1")}

\score {
  <<
  \new RhythmicStaff \with {
    \remove Staff_symbol_engraver
    \consists "Accidental_engraver" 
    \override StaffSymbol #'line-count = #0
    \override BarLine #'bar-extent = #'(-2 . 2)
    \override Staff.TimeSignature #'style = #'numbered
    \override Staff.Stem #'transparent = ##t
    \override Stem.length = #0
    \override Rest.Y-offset = #-1
    \override NoteHead.Y-offset = #-1
    \override Beam #'transparent = ##t 
    \override Stem #'direction = #UP
    \override Beam #'beam-thickness = #0
    \override Beam #'length-fraction = #0
    \override Tie #'staff-position = #2.5
    \override TupletBracket #'bracket-visibility = ##t
    \tupletUp
    \hide Stem
    \hide Beam
  }
  \new Voice {
  \headZero
  r4  
  \headOne
  c'4
  \headTwo
  d'4
  \headThree
  e'4 
  \headFour
  f'4
  \headFive
  g'4
  \headSix
  a'4
  \headSeven
  b'4
  \headOne
  c''4
  \headOne
  ces''4^\notedot
  \headOne
  cis''4^\notedot
  \headOne
  c4_\notedot
  \headOne
  c'8_\jianpuStem
  \headOne
  c'8_\jianpuStem
  \headZero
  r4
  \jianpuRestBar
  r4
  \headZero
  r4
  |
  \headOne
  c4
  \jianpuNoteBar
  c4
  \jianpuNoteBar
  c4
  \jianpuNoteBar
  c4
  }
  \new Staff{
    r4 c'4 d'4 e'4 f'4 g'4 a'4 b'4 c''4 ces''4 cis''4 c4 c'8c'8 r2 r4 | c1
  }
  >>
}