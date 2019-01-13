\version "2.18.2"
\include "jianpu10a.ly"
\language "english"

test_a={
  cf'8 c'8 cs'8 c'8 df'8 d'8 ds'8 d'8 
  ef'8 e'8 es'8 e'8 ff'8 f'8 fs'8 f'8 
  gf'8 g'8 gs'8 g'8 af'8 a'8 as'8 a'8
  bf'8 b'8 bs'8 b'8 r2 \bar "|"
}

\new JianpuStaff{
  \jianpuMusic{
    \key c \major
    {
      \test_a
    }
   \key df\major{
     \transpose c df { \test_a }
   }
   \key d\major{
     \transpose c d { \test_a }
   }
   \key ds\major{
     \transpose c ds { \test_a }
   }
   \key ef\major{
     \transpose c ef { \test_a }
   }
  }
}