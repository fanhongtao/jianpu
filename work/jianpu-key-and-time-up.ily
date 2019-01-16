\once \override KeySignature.Y-offset = #4
\once \override KeySignature.extra-spacing-width = #'(+inf.0 . -inf.0)

\once \override TimeSignature.Y-offset = #5
\once \override TimeSignature.extra-spacing-width = #'(+inf.0 . -inf.0)
\once \override TimeSignature.space-alist = #'(
            (cue-clef extra-space . 1.5)
            ;; (first-note fixed-space . 2.0)
            (right-edge extra-space . 0.5)
            (staff-bar extra-space . 1.0))
