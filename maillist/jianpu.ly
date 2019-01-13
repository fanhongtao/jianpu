\version "2.18.2"

#(define Jianpu_rest_engraver
   (make-engraver
    (acknowledgers
     ((rest-interface engraver grob source-engraver)
      ;; make sure \omit is not in effect (stencil is not #f)
      (if (ly:grob-property-data grob 'stencil)
          (ly:grob-set-property! grob 'stencil
            (grob-interpret-markup grob
              (markup #:musicglyph "zero"))))
      ;; TODO: modify stencil based on rest duration
      ;; (dur-log (ly:grob-property grob 'duration-log))
      ))))

#(define Jianpu_note_head_engraver
   (make-engraver
    (acknowledgers
     ((note-head-interface engraver grob source-engraver)
      ;; make sure \omit is not in effect (stencil is not #f)
      (if (ly:grob-property-data grob 'stencil)
          (let* ((context (ly:translator-context engraver))
                 (tonic-pitch (ly:context-property context 'tonic))
                 (tonic-number (ly:pitch-notename tonic-pitch))
                 (grob-pitch (ly:event-property (event-cause grob) 'pitch))
                 (grob-number (ly:pitch-notename grob-pitch))
                 (jianpu-number (+ 1 (modulo (- grob-number tonic-number) 7)))
                 (glyph-string
                  (case jianpu-number
                    ((1) "one")
                    ((2) "two")
                    ((3) "three")
                    ((4) "four")
                    ((5) "five")
                    ((6) "six")
                    ((7) "seven")))
                 (number-stencil
                  (grob-interpret-markup grob
                    (markup #:musicglyph glyph-string)))

                 ;; TODO: currently only accurate with major keys, need to change
                 ;; note-to-number mapping based on the mode (major, minor, etc.)
                 (key-alts (ly:context-property context 'keySignature))

                 ;; TODO: based on duration-log, modify stencil to
                 ;; indicate note duration
                 (dur-log (ly:grob-property grob 'duration-log))

                 ;; TODO: based on octave, modify stencil to add
                 ;; dots above or below
                 (octave (ly:pitch-octave grob-pitch))
                 (dot (make-circle-stencil 0.3 0 #t))
                 )
            ;; (display jianpu-number) (newline)

            ;; set the stencil for the note head grob
            (ly:grob-set-property! grob 'stencil number-stencil)
            ))))))


notedot=\markup{\hspace #0.5 \draw-circle #0.3 #0 ##t}

jianpuStem=\markup{ \override #'(thickness . 3) \draw-line #'(1 . 0)}

jianpuRestBar={
  \once \override Rest.Y-offset = #-0.3
  \once \override Rest.stencil = #ly:text-interface::print
  \once \override Rest.text = #(markup #:musicglyph "rests.1")
}

jianpuNoteBar={
  \once \override NoteHead.Y-offset = #-0.3
  \once \override NoteHead.stencil = #ly:text-interface::print
  \once \override NoteHead.text = #(markup #:musicglyph "rests.1")
}

\score {
  <<
    \new Staff \with {
      \consists \Jianpu_note_head_engraver
      \consists \Jianpu_rest_engraver
      \override Clef.stencil = ##f

      \remove Staff_symbol_engraver
      \override StaffSymbol.line-count = #0
      \override BarLine.bar-extent = #'(-2 . 2)
      \override Staff.TimeSignature.style = #'numbered
      \override Staff.Stem.transparent = ##t
      \override Stem.length = #0
      \override Rest.Y-offset = #-1
      \override NoteHead.Y-offset = #-1
      \override Beam.transparent = ##t
      \override Stem.direction = #UP
      \override Beam.beam-thickness = #0
      \override Beam.length-fraction = #0
      \override Tie.staff-position = #2.5
      \override TupletBracket.bracket-visibility = ##t
      \tupletUp
      \hide Stem
      \hide Beam
    }
    \new Voice {
      \key c \major
      r4 c'4 d'4 e'4
      f'4 g'4 a'4 b'4

      c''4
      ces''4^\notedot
      cis''4^\notedot
      c4_\notedot

      c'8_\jianpuStem
      c'8_\jianpuStem
      r4
      \jianpuRestBar
      r4
      r4
      |
      c4
      \jianpuNoteBar
      c4
      \jianpuNoteBar
      c4
      \jianpuNoteBar
      c4
    }
    \new Staff {
      r4 c'4 d'4 e'4 f'4 g'4 a'4 b'4 c''4 ces''4 cis''4 c4 c'8c'8 r2 r4 | c1
    }
  >>
}