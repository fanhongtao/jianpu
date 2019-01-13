\version "2.18.2"

#(define (get-keysig-alt-count alt-alist)
   "Return number of sharps/flats in key sig, (+) for sharps, (-) for flats."
   (if (null? alt-alist)
       0
       (* (length alt-alist) 2 (cdr (car alt-alist)))))

#(define (get-major-tonic alt-count)
   "Return number of the tonic note 0-6, as if the key sig were major."
   ;; (alt-count major-tonic)
   ;; (-7 0) (-5 1) (-3 2) (-1 3) (1 4) (3 5) (5 6) (7 0)
   ;; (-6 4) (-4 5) (-2 6) (0 0) (2 1) (4 2) (6 3)
   (if (odd? alt-count)
       (modulo (- (/ (+ alt-count 1) 2) 4) 7)
       (modulo (/ alt-count 2) 7)))

#(define (add-dash-right stencil)
   "For half notes and whole notes, adds a dash to the right of the stencil."
   (ly:stencil-combine-at-edge stencil X RIGHT
     (ly:stencil-translate
      (make-connected-path-stencil
       '((1 0))
       0.3 1 1 #f #f)
      (cons 0 1))
     1))

#(define (add-dot direction stencil)
   "For adding octave dots above and below notes."
   (ly:stencil-combine-at-edge stencil Y direction
     (ly:stencil-translate
      (make-circle-stencil 0.3 0 #t)
      (cons 0.5 0))
     1))

#(define (add-flag-dash stencil)
   "For adding dashes below 8th notes and shorter notes."
   (ly:stencil-combine-at-edge stencil Y DOWN
     (ly:stencil-translate
      (make-connected-path-stencil
       '((1 0))
       0.3 1 1 #f #f)
      (cons 0 0))
     0.5))


#(define Jianpu_rest_engraver
   (make-engraver
    (acknowledgers
     ((rest-interface engraver grob source-engraver)
      ;; make sure \omit is not in effect (stencil is not #f)
      (if (ly:grob-property-data grob 'stencil)
          (let* ((stencil-a
                  (grob-interpret-markup grob (markup #:musicglyph "zero")))

                 ;; add duration dashes to the rest, to the right or below
                 (dur-log (ly:grob-property grob 'duration-log))
                 (stencil-b (case dur-log
                              ((0) (add-dash-right (add-dash-right (add-dash-right stencil-a))))
                              ((1) (add-dash-right stencil-a))
                              ((2) stencil-a)
                              ((3) (add-flag-dash stencil-a))
                              ((4) (add-flag-dash (add-flag-dash stencil-a)))
                              ((5) (add-flag-dash (add-flag-dash (add-flag-dash stencil-a))))
                              ((6) (add-flag-dash (add-flag-dash (add-flag-dash
                                                                  (add-flag-dash stencil-a)))))
                              ((7) (add-flag-dash (add-flag-dash (add-flag-dash
                                                                  (add-flag-dash (add-flag-dash stencil-a))))))
                              (else stencil-a))) )

            ;; (display dur-log) (newline)

            (ly:grob-set-property! grob 'stencil stencil-b)
            (ly:grob-set-property! grob 'X-extent
              (ly:stencil-extent (ly:grob-property grob 'stencil) X))
            (ly:grob-set-property! grob 'Y-extent
              (ly:stencil-extent (ly:grob-property grob 'stencil) Y))
            ))))))


#(define Jianpu_note_head_engraver
   (make-engraver
    (acknowledgers
     ((note-head-interface engraver grob source-engraver)
      ;; make sure \omit is not in effect (stencil is not #f)
      (if (ly:grob-property-data grob 'stencil)
          (let* ((staff-context (ly:translator-context engraver))
                 ;; (tonic-pitch (ly:context-property staff-context 'tonic))
                 ;; (tonic-number (ly:pitch-notename tonic-pitch))
                 (stem-grob (ly:grob-object grob 'stem))
                 (flag-grob (ly:grob-object stem-grob 'flag))

                 ;; start with a number stencil based on the scale degree of the note
                 (key-alts (ly:context-property staff-context 'keySignature))
                 ;; for LilyPond 2.19:
                 ;; (key-alts (ly:context-property staff-context 'keyAlterations))
                 (keysig-alt-count (get-keysig-alt-count key-alts))
                 (major-tonic-number (get-major-tonic keysig-alt-count))
                 (grob-pitch (ly:event-property (event-cause grob) 'pitch))
                 (grob-number (ly:pitch-notename grob-pitch))
                 (note-number (+ 1 (modulo (- grob-number major-tonic-number) 7)))
                 (glyph-string (case note-number
                                 ((1) "one")
                                 ((2) "two")
                                 ((3) "three")
                                 ((4) "four")
                                 ((5) "five")
                                 ((6) "six")
                                 ((7) "seven")
                                 (else "zero")))
                 (stencil-a (grob-interpret-markup grob
                              (markup #:musicglyph glyph-string)))

                 ;; TODO: handle dotted notes
                 ;; but how to access dots grob from note head grob?
                 ;; (note-column-grob (ly:grob-parent stem-grob Y))
                 ;; (note-column-grob (ly:grob-parent stem-grob X))
                 ;; these don't work:
                 ;; (vert-axis-group-grob (ly:grob-object note-column-grob 'vertical-axis-group))
                 ;; (vert-axis-group-grob (ly:grob-parent note-column-grob X))
                 ;; (paper-column-grob (ly:grob-object note-column-grob 'paper-column))

                 ;; TODO: use some kind of looping, iteration, recursion, fold function, etc.
                 ;; instead of hard-coding the repetitions of stencil-modifying functions

                 ;; add duration dashes to right of half note and whole note
                 (dur-log (ly:grob-property grob 'duration-log))
                 (stencil-b (case dur-log
                              ((0) (add-dash-right (add-dash-right (add-dash-right stencil-a))))
                              ((1) (add-dash-right stencil-a))
                              ((2) stencil-a)
                              (else stencil-a)))

                 ;; add duration dashes below 8th notes and shorter
                 (flag-glyph-name
                  (if (ly:grob? flag-grob)
                      (ly:grob-property flag-grob 'glyph-name)
                      ""))
                 (flag-num (cond
                            ((string= flag-glyph-name "flags.u3") 1)
                            ((string= flag-glyph-name "flags.u4") 2)
                            ((string= flag-glyph-name "flags.u5") 3)
                            ((string= flag-glyph-name "flags.u6") 4)
                            ((string= flag-glyph-name "flags.u7") 5)
                            (else 0)))
                 (stencil-c (case flag-num
                              ((0) stencil-b)
                              ((1) (add-flag-dash stencil-b))
                              ((2) (add-flag-dash (add-flag-dash stencil-b)))
                              ((3) (add-flag-dash (add-flag-dash (add-flag-dash stencil-b))))
                              ((4) (add-flag-dash (add-flag-dash (add-flag-dash
                                                                  (add-flag-dash stencil-b)))))
                              ((5) (add-flag-dash (add-flag-dash (add-flag-dash
                                                                  (add-flag-dash (add-flag-dash stencil-b))))))
                              (else stencil-b)))

                 ;; add octave dots above or below the stencil
                 (octave (ly:pitch-octave grob-pitch))
                 (stencil-d (case octave
                              ((3) (add-dot UP (add-dot UP (add-dot UP stencil-c))))
                              ((2) (add-dot UP (add-dot UP stencil-c)))
                              ((1) (add-dot UP stencil-c))
                              ((0) stencil-c)
                              ((-1) (add-dot DOWN stencil-c))
                              ((-2) (add-dot DOWN (add-dot DOWN stencil-c)))
                              ((-3) (add-dot DOWN (add-dot DOWN (add-dot DOWN stencil-c))))
                              (else stencil-c))) )
            ;; (display octave)(newline)

            ;; set the stencil for the note head grob
            (ly:grob-set-property! grob 'stencil stencil-d)
            ))))))


#(define Jianpu_accidental_engraver
   (make-engraver
    (acknowledgers
     ((accidental-interface engraver grob source-engraver)
      (let*
       ((context (ly:translator-context engraver))
        (key-alts (ly:context-property context 'keySignature))
        ;; for LilyPond 2.19:
        ;; (key-alts (ly:context-property context 'keyAlterations))
        (alt (accidental-interface::calc-alteration grob))
        (note-head-grob (ly:grob-parent grob Y))
        (pitch (ly:event-property
                (ly:grob-property note-head-grob 'cause)
                'pitch))
        (note-number (ly:pitch-notename pitch))
        ;; default alteration of this note, in the key, as if there were no accidental sign
        (default (or (assoc-ref key-alts note-number) 0))
        (new-alt
         (cond

          ;; natural sign: convert to sharp or flat (the opposite of the sharps
          ;; or flats in the key signature) if natural is not in the key
          ((and (= alt 0) (not (= alt default)))
           (* -1 (cdr (car key-alts))))

          ;; single sharp sign: convert to natural if sharp is in key
          ((and (= alt 1/2) (= 1/2 default)) 0)

          ;; single flat sign: convert to natural if flat is in key
          ((and (= alt -1/2) (= -1/2 default)) 0)

          ;; single sharp sign: convert to double sharp if natural (and sharp) is not in key
          ((and (= alt 1/2) (not (= 0 default))) 1)

          ;; single flat sign: convert to double flat if natural (and flat) is not in key
          ((and (= alt -1/2) (not (= 0 default))) -1)

          ;; double sharp sign: convert to single if single sharp is in the key
          ((and (= alt 1) (= 1/2 default)) 1/2)

          ;; double flat sign: convert to single if single flat is in the key
          ((and (= alt -1) (= -1/2 default)) -1/2)

          ;; there are no triple sharp or triple flat glyphs,
          ;; so these are needed but don't work:
          ;; double sharp sign: convert to triple sharp if single flat is in the key
          ;; ((and (= alt 1) (= -1/2 default))
          ;; (ly:grob-set-property! grob 'alteration 3/2))
          ;; double flat sign: convert to triple flat if single sharp is in the key
          ;; ((and (= alt -1) (= -1/2 default))
          ;; (ly:grob-set-property! grob 'alteration -3/2))

          (else #f))))
       ;; (display default)(newline)
       (if new-alt (ly:grob-set-property! grob 'alteration new-alt))
       )))))



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
    \new Staff \with {
      \consists \Jianpu_note_head_engraver
      \consists \Jianpu_rest_engraver
      \consists \Jianpu_accidental_engraver
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
