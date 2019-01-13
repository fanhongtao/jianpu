\version "2.18.2"
\language "english"
\include "jianpu6.ly"

notesOne = {
  \key c \major
  c' d' e' f' g' a' b' c''
}

transposed = {
  \mark "1=C"
  \notesOne
  \mark "1=G"
  \transpose c g \notesOne
  \mark "1=D"
  \transpose c d \notesOne
  \mark "1=A"
  \transpose c a \notesOne
  \mark "1=E"
  \transpose c e \notesOne
  \mark "1=B"
  \transpose c b \notesOne
  \mark "1=G♭" % or F♯
  \transpose c gf \notesOne
  \mark "1=D♭" % or C♯
  \transpose c df \notesOne
  \mark "1=A♭"% or B♯
  \transpose c af \notesOne
  \mark "1=E♭"% or D♯
  \transpose c ef \notesOne
  \mark "1=B♭"% or A♯
  \transpose c bf \notesOne
  \mark "1=F"
  \transpose c f \notesOne
}

%%test for unusual key signatures
  freygish = #`((0 . ,NATURAL) (1 . ,FLAT) (2 . ,NATURAL)
         (3 . ,NATURAL) (4 . ,NATURAL) (5 . ,FLAT) (6 . ,FLAT))
notesTwo = {
  \mark "1=?"%%should be"1=C" and put sharps and flats to make correct pitchs
  \key c \freygish
  c' d' e' f' g' a' b' c''
}

\score {
  <<
    \new JianpuStaff \with{
      %\remove Key_engraver %%NEVER DO THIS!!!
    \override KeySignature.transparent = ##t %Instead, do this!
    \override KeyCancellation.transparent = ##t %Instead, do this!
    }
    \new Voice {
       \transposed
       \notesTwo
    }
    \new Staff {
       \transposed
       \notesTwo
    }
  >>
}
