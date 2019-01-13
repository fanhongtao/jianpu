\version "2.18.2"
\language "english"
\include "jianpu5.ly"

music = \relative f''' {
  \key c \major
  c,, d e f
  g a b c
  d e f g
  a b c d
  \break
  \key d \major
  c,, d e f
  g a b c
  d e f g
  a b c d
  \break
  \key e \major
  c,, d e f
  g a b c
  d e f g
  a b c d
  \break
  \key b \major
  \transpose c b {
  c,, d e f
  g a b c
  d e f g
  a b c d
  }
}

musicB = {
  \key c \major
  b, bs, cf c
  d e
  f g
  a b
  c' d'
  e' f'
  g' a'
  b' bs'
  cf'' c''
  \break
}

transposed = {
  \musicB
  \transpose c d \musicB
  \transpose c e \musicB
  \transpose c b \musicB
  \transpose c c' \musicB
}

<<
  \new JianpuStaff {
    \transposed

  }
  \new Staff {
    \transposed
  }
>>