\version "2.18.2"
% Test notes for both hands.
% Move key & time signature above the notes

keyTime = {
  \key c \major
  \time 4/4
  \numericTimeSignature
}

upper = \relative c' {
  \clef treble
  \keyTime
  \tempo 4=108
  
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
    \new JianpuStaff \with  {
      \once \override KeySignature.Y-offset = #4
      \once \override KeySignature.extra-spacing-width = #'(+inf.0 . -inf.0)
     
      \once \override TimeSignature.Y-offset = #5
      \once \override TimeSignature.extra-spacing-width = #'(+inf.0 . -inf.0)
      \once \override TimeSignature.space-alist = #'(
                  (cue-clef extra-space . 1.5)
                  ;; (first-note fixed-space . 2.0)
                  (right-edge extra-space . 0.5)
                  (staff-bar extra-space . 1.0))
    } \jianpuMusic {
      \once \override Score.MetronomeMark.X-offset = #10
      \once \override Score.MetronomeMark.Y-offset = #4
      \upper
    }
    % \new Staff {
    \new JianpuStaff \with {
      \remove "Key_engraver"
      \remove "Time_signature_engraver"
    } \jianpuMusic { 
      \lower
    }
  >>
  
  \layout { 
    indent=0\cm 
  }
  \midi { }
}
