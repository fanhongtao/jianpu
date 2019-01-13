\version "2.18.2"
% Test notes for both hands.

keyTime = {
  \key c \major
  \time 4/4
  \numericTimeSignature
}

upper = \relative c' {
  \clef treble
  \keyTime
  \tempo "Allegretto" 4=108
  
  \repeat unfold 4 {
    c4 d e f |
    g4 a b c |
    c4 b a g |
    f4 e d c |\break
  }
  |\bar "|."
}

lower = \relative c {
  \clef bass
  \keyTime
  
  \repeat unfold 4 {
    c4 d e f |
    g4 a b c |
    c4 b a g |
    f4 e d c |
  }
  \bar "|."
}


\include "jianpu.ly"

\score {
  \new PianoStaff <<
    % \new Staff {
    \new JianpuStaff \jianpuMusic {
        \upper
    }
    % \new Staff {
    \new JianpuStaff \jianpuMusic { 
        \lower
    }
  >>
  
  \layout { }
  \midi { }
}
