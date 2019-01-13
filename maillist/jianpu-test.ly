\version "2.18.2"
\include "jianpu4.ly"

notesOne = {
  \key c \major
  r4 c'4 d'4 e'4
  f'4 g'4 a'4 b'4
  c''4 ces''4 cis''4 c4
  c,4 c''' c,, c''''
  c'1
  c'2 c'2
  r1
  r2 r2
  r4 r4 r4 r4
  c1
  r8 r r16 r r r r32 r r r
  c8 c c16 c c32 c c64 c c128 c
}

dottedNotes = {
  c1
  c2 c2
  c4 c c c
  c1.
  c2.
  c4.
}

restNotes = {
  r1 r2 r4 r8
  r16 r32 r64 r128
}

accidentalsNotes = \relative f' {
  \key d \major
  dis4 d des d
  cis c ces c
  cisis
  % ceses is not correct, no triple flat glyph
  ceses
  disis
  deses

  \key bes \major
  bes' b bis b
  a aes aeses aes
  % bisis is not correct, no triple sharp glyph
  bisis
  beses
  aisis aeses
}


\score {
  <<
    \new StaffJianpu
    \new Voice {
      % \notesOne
      % \dottedNotes
      % \restNotes
      \accidentalsNotes
    }
    \new Staff {
      % \notesOne
      \accidentalsNotes
    }
  >>
}
