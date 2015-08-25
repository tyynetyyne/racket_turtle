;; ---------------------------------------------------------------------------------------------------
;; Racket-Turtle 0.5
;; 
;; - animated turtle for drawing geometric shapes
;; - instructions for using this module can be found in turtle_examples.rkt (English) and 
;;   turtle_esimerkit.rkt (Finnish)
;; 
;; Tiina Partanen
;; ---------------------------------------------------------------------------------------------------
#lang racket                           ;; DrRacket (comment out in WeScheme)
(require 2htdp/image)                  ;; DrRacket (comment out in WeScheme)
(require 2htdp/universe)               ;; DrRacket (comment out in WeScheme)

(provide forward 
         turn-left 
         turn-right 
         pen-down 
         pen-up
         change-color
         change-pen-size               ;; WeScheme doesn't support this (ignored)
         change-pen-style              ;; WeScheme doesn't support this (ignored)
         change-bg-color
         repeat
         go-to
         go-to-origin
         stamper-on
         stamper-off
         mirror-x-on
         mirror-x-off
         mirror-y-on
         mirror-y-off
         set-origin
         set-bg-image
         set-bg-grid
         clean-up
         hide-turtle
         show-turtle
         draw 
         draw-custom
         draw-and-store                 ;; WeScheme doesn't support this (comment out in WeScheme)
         draw-and-store-custom          ;; WeScheme doesn't support this (comment out in WeScheme)   
         draw-step-by-step
         draw-step-by-step-custom
         piirrä 
         piirrä-osissa)

;; the appearance of the turtle
(define TURTLE (isosceles-triangle 20 50 "solid" "black"))
(define ORIGIN (circle 3 "solid" "red"))

;; the area in which the turtle moves:
(define WIDTH 500)
(define HEIGHT 500)

;; default color of the pen:
(define COLOR "blue")
(define BG-COLOR "white")
(define PEN-CAP "round")
(define PEN-JOIN "round")
(define PEN-STYLES (list "solid" "dot" "long-dash" "short-dash" "dot-dash"))

;; Position: 
;; - x (Number)
;; - y (Number)
;; - angle (Number)
(define-struct position (x y angle))

;; Turtle:
;; - location (Position)
;; - mirror-x (Boolean/Number), false = no mirroring versus x-axis
;; - mirror-y (Boolean/Number), false = no mirroring versus y-axis
(define-struct turtle (location mirror-x mirror-y))

;; Animation:
;; - location (Turtle), origin is in the top left corner, coordinates are in pixels
;; - image (Image)
;; - commands (List-of-procedures)
;; - color (Color / List-of-colors)
;; - pen? (Boolean)
;; - pen-size (Number)
;; - pen-style (String)
;; - bg-color (Color)
;; - stamp? (Boolean)
;; - stamps (Image / List-of-images)
;; - origin (Position)
;; - turtle? (Boolean)
(define-struct animation (location image commands color pen? pen-size pen-style bg-color stamp? stamps origin turtle?))

;; ---------------------------------------------------------------------------------------------------
;; Getters for Animation:

;; get-position : Animation -> Position
(define (get-position anim)
  (turtle-location (animation-location anim)))

;; get-x : Animation -> Number
(define (get-x anim)
 (position-x (turtle-location (animation-location anim))))

;; get-y : Animation -> Number
(define (get-y anim)
  (position-y (turtle-location (animation-location anim))))

;; get-origin-x : Animation -> Number
(define (get-origin-x anim)
 (position-x (animation-origin anim)))

;; get-origin-y : Animation -> Number
(define (get-origin-y anim)
  (position-y (animation-origin anim)))

;; get-height : Animation -> Number
(define (get-height anim)
 (image-height (animation-image anim)))

;; get-width : Animation -> Number
(define (get-width anim)
  (image-width (animation-image anim)))

;; get-angle : Animation -> Number
(define (get-angle anim)
  (position-angle (turtle-location (animation-location anim))))

;; get-mirror-x : Animation -> Boolean/Number
(define (get-mirror-x anim)
  (turtle-mirror-x (animation-location anim)))

;; get-mirror-y : Animation -> Boolean/Number
(define (get-mirror-y anim)
  (turtle-mirror-y (animation-location anim)))

;; get-color : Animation -> Color
(define (get-color anim)
  (cond [(or (color? (animation-color anim))
             (string? (animation-color anim)))
         (animation-color anim)]
        [(and (list? (animation-color anim))
              (not (empty? (animation-color anim))))
         (first (animation-color anim))]
        [else "black"]))
        
;; ---------------------------------------------------------------------------------------------------
;; Getters for Turtle:
;; t-get-x : Turtle -> Number
(define (t-get-x t)
  (position-x (turtle-location t)))

;; t-get-y : Turtle -> Number
(define (t-get-y t)
  (position-y (turtle-location t)))

;; t-get-angle : Turtle -> Number
(define (t-get-angle t)
  (position-angle (turtle-location t)))

;; on-screen? : Position Image -> Boolean
(define (on-screen? pos img)
  (and (<= 0 (position-x pos) (image-width img))
       (<= 0 (position-y pos) (image-height img))))

;; this is needed in WeScheme (comment out in DrRacket)
;; degrees->radians : Number -> Number
;(define (degrees->radians deg)
;  (/ (* deg pi) 180))

;; draw-horizontal-line : Number Image Color -> Image
(define (draw-horizontal-line y img color)
  (add-line img 0 y (image-width img) y color))

;; draw-vertical-line : Number Image Color-> Image
(define (draw-vertical-line x img color)
  (add-line img x 0 x (image-height img) color))

;; draw-vertical-lines : Number Position Image Color -> Image
(define (draw-vertical-lines x-step orig img color)
  (letrec ((start-x (modulo (position-x orig) x-step))
            (times (round (/ (image-width img) x-step)))
            (steps (map (lambda (x) (+ start-x (* x x-step))) (map sub1 (build-list times add1)))))
        (foldl (lambda (x i) (draw-vertical-line x i color)) img steps)))

;; draw-horizontal-lines : Number Position Image Color -> Image
(define (draw-horizontal-lines y-step orig img color)
  (letrec ((start-y (modulo (position-y orig) y-step))
            (times (round (/ (image-height img) y-step)))
            (steps (map (lambda (y) (+ start-y (* y y-step))) (map sub1 (build-list times add1)))))
        (foldl (lambda (y i) (draw-horizontal-line y i color)) img steps)))

;; draw-grid : Number Number Position Image Color -> Image
(define (draw-grid x-step y-step origin img color)
  (draw-vertical-lines x-step origin (draw-horizontal-lines y-step origin img color) color))

;; new-turtle-position : Animation Number -> Position
(define (new-turtle-position anim dist)
  (let 
      ((x (get-x anim))
       (y (get-y anim))
       (a (get-angle anim)))
    (cond 
      [(= dist 0) 
       (make-position x y a)]
      [(or (= a 0) (= a 360))
       (make-position x (- y dist) a)]
      [(= a 90)
       (make-position (- x dist) y a)]
      [(= a 180)
       (make-position x (+ y dist) a)]
      [(= a 270)
       (make-position (+ x dist) y a)]
      [(< 0 a 90)
       (make-position   (- x (* dist (cos (degrees->radians (- 90 a)))))
                        (- y (* dist (sin (degrees->radians (- 90 a)))))
                        a)]
      [(< 90 a 180)
       (make-position   (- x (* dist (cos (degrees->radians (- a 90)))))
                        (+ y (* dist (sin (degrees->radians (- a 90)))))
                        a)]
      [(< 180 a 270)
       (make-position   (+ x (* dist (cos (degrees->radians (- 270 a)))))
                        (+ y (* dist (sin (degrees->radians (- 270 a)))))
                        a)]
      [(< 270 a 360)
       (make-position  (+ x (* dist (cos (degrees->radians (- a 270)))))
                       (- y (* dist (sin (degrees->radians (- a 270)))))
                       a)]
      [else (make-position x y a)])))

;; new-turtle-direction : Animation Number -> Position
(define (new-turtle-direction anim turn)
  (let 
      ((x (get-x anim))
       (y (get-y anim))
       (a (get-angle anim))
       (turning-angle (modulo (round turn) 360)))
    (cond [(= 0 turning-angle)
           (make-position x y a)]
          [(< 0 turning-angle) 
           (make-position x
                          y 
                          (modulo (+ a turning-angle) 360))]
          [(and (> 0 turning-angle) (> (abs turning-angle) a))
           (make-position x 
                          y 
                          (+ 360 (modulo (+ a turning-angle) 360)))]
          [(and (> 0 turning-angle) (<= (abs turning-angle) a))
           (make-position x 
                          y 
                          (+ a turning-angle))]
          [else (make-position x y a)])))

;; new-turtle-direction-full : Animation Number -> Animation
(define (new-turtle-direction-full anim turn)
  (set-location anim (make-turtle (new-turtle-direction anim turn)
                               (get-mirror-x anim)
                               (get-mirror-y anim))))

;; new-turtle-position-full : Animation Number -> Animation
(define (new-turtle-position-full anim turn)
  (set-location anim (make-turtle (new-turtle-position anim turn)
                               (get-mirror-x anim)
                               (get-mirror-y anim))))

;; ---------------------------------------------------------------------------------------------------
;; Setters for animation

;; set-location : Animation Turtle -> Animation
(define (set-location anim turt)
  (if (turtle? turt)
      (make-animation turt
                      (animation-image anim)
                      (animation-commands anim)
                      (animation-color anim)
                      (animation-pen? anim)
                      (animation-pen-size anim)
                      (animation-pen-style anim)
                      (animation-bg-color anim)
                      (animation-stamp? anim)
                      (animation-stamps anim)
                      (animation-origin anim)
                      (animation-turtle? anim))
      anim))

;; set-image : Animation Image -> Animation
(define (set-image anim img)
  (if (image? img)
      (make-animation (animation-location anim)
                      (overlay img (animation-image anim))
                      (animation-commands anim)
                      (animation-color anim)
                      (animation-pen? anim)
                      (animation-pen-size anim)
                      (animation-pen-style anim)
                      (animation-bg-color anim)
                      (animation-stamp? anim)
                      (animation-stamps anim)
                      (animation-origin anim)
                      (animation-turtle? anim))
      anim))

;; set-pen : Animation Color -> Animation
(define (set-pen anim setting)
  (cond [(boolean? setting)
         (make-animation (animation-location anim) 
                         (animation-image anim) 
                         (animation-commands anim)
                         (animation-color anim)
                         setting
                         (animation-pen-size anim)
                         (animation-pen-style anim)
                         (animation-bg-color anim)
                         (animation-stamp? anim)
                         (animation-stamps anim)
                         (animation-origin anim)
                         (animation-turtle? anim))]
        [else anim]))
 
;; set-color : Animation Color -> Animation
(define (set-color anim setting)
  (cond [(or (string? setting) (color? setting)
             (and (list? setting)
                  (andmap (lambda (x) (or (string? x)(color? x))) setting)))
         (make-animation (animation-location anim)
                         (animation-image anim) 
                         (animation-commands anim)
                         setting
                         (animation-pen? anim)
                         (animation-pen-size anim)
                         (animation-pen-style anim)
                         (animation-bg-color anim)
                         (animation-stamp? anim)
                         (animation-stamps anim)
                         (animation-origin anim)
                         (animation-turtle? anim))]
        [else anim]))

;; set-bg-color : Animation Color -> Animation
(define (set-bg-color anim setting)
  (cond [(or (string? setting) (color? setting))
         (make-animation (animation-location anim)
                         (overlay (rectangle (get-width anim) (get-height anim) "solid" setting) (animation-image anim))
                         (animation-commands anim)
                         (animation-color anim)
                         (animation-pen? anim)
                         (animation-pen-size anim)
                         (animation-pen-style anim)
                         setting
                         (animation-stamp? anim)
                         (animation-stamps anim)
                         (animation-origin anim)
                         (animation-turtle? anim))]
         [else anim]))

;; x-inside? : Number Number Numer -> Boolean
(define (x-inside? x origon-x width)
  (<= (- origon-x) x (- width origon-x)))

;; y-inside? : Number Number Number -> Boolean
(define (y-inside? y origon-y height)
  (<= (- (- height origon-y)) y origon-y))

;; set-position : Animation Number Number -> Animation
(define (set-position anim x y)
  (cond [(and (x-inside? x (get-origin-x anim) (get-width anim))
              (y-inside? y (get-origin-y anim) (get-height anim))) 
         (set-location anim (make-turtle (make-position (+ (get-origin-x anim) x) 
                                                        (- (get-origin-y anim) y) 
                                                        (get-angle anim)) 
                                         (get-mirror-x anim) 
                                         (get-mirror-y anim)))]
        [else anim]))

;; clean-up-image : Animation -> Animation
(define (clean-up-image anim)
  (set-image anim (rectangle (get-width anim) (get-height anim) "solid" (animation-bg-color anim))))

;; set-stamper-image : Animation Image/List-of-images -> Animation
(define (set-stamper-image anim img)
  (if (or (image? img)
          (and (list? img)
               (andmap image? img)))
      (make-animation (animation-location anim)
                      (animation-image anim)
                      (animation-commands anim)
                      (animation-color anim)
                      (animation-pen? anim)
                      (animation-pen-size anim)
                      (animation-pen-style anim)
                      (animation-bg-color anim)
                      true
                      img
                      (animation-origin anim)
                      (animation-turtle? anim))
      anim))

;; set-stamper-off : Animation -> Animation
(define (set-stamper-off anim)
  (make-animation (animation-location anim)
                  (animation-image anim)
                  (animation-commands anim)
                  (animation-color anim)
                  (animation-pen? anim)
                  (animation-pen-size anim)
                  (animation-pen-style anim)
                  (animation-bg-color anim)
                  false
                  empty-image
                  (animation-origin anim)
                  (animation-turtle? anim)))

;; set-mirror-y-on : Animation -> Animation
(define (set-mirror-y-on anim)
  (set-location anim 
                  (make-turtle (get-position anim)
                               (get-x anim)
                               (get-mirror-y anim))))

;; set-mirror-y-off : Animation -> Animation
(define (set-mirror-y-off anim)
  (set-location anim
                  (make-turtle (get-position anim)
                               false
                               (get-mirror-y anim))))

;; set-mirror-x-on : Animation -> Animation
(define (set-mirror-x-on anim)
  (set-location anim (make-turtle (get-position anim)
                               (get-mirror-x anim)
                               (get-y anim))))

;; set-origin-xy : Animation -> Animation 
(define (set-origin-xy anim)
  (make-animation (animation-location anim)
                  (animation-image anim)
                  (animation-commands anim)
                  (animation-color anim)
                  (animation-pen? anim)
                  (animation-pen-size anim)
                  (animation-pen-style anim)
                  (animation-bg-color anim)
                  (animation-stamp? anim)
                  (animation-stamps anim)
                  (make-position (get-x anim)
                                 (get-y anim)
                                 0)
                  (animation-turtle? anim)))

;; set-pen-size : Animation -> Animation 
(define (set-pen-size anim size)
  (if (<= 0 size 255)
      (make-animation (animation-location anim)
                      (animation-image anim)
                      (animation-commands anim)
                      (animation-color anim)
                      (animation-pen? anim)
                      size
                      (animation-pen-style anim)
                      (animation-bg-color anim)
                      (animation-stamp? anim)
                      (animation-stamps anim)
                      (animation-origin anim)
                      (animation-turtle? anim))
      anim))

;; is-pen-style? : String -> Boolean
(define (is-pen-style? str)
  (member str PEN-STYLES)     ; DrRacket
  ;(member? str PEN-STYLES)   ; WeScheme
  )

;; set-pen-style : Animation -> Animation 
(define (set-pen-style anim style)
  (if (is-pen-style? style)
      (make-animation (animation-location anim)
                      (animation-image anim)
                      (animation-commands anim)
                      (animation-color anim)
                      (animation-pen? anim)
                      (animation-pen-size anim)
                      style
                      (animation-bg-color anim)
                      (animation-stamp? anim)
                      (animation-stamps anim)
                      (animation-origin anim)
                      (animation-turtle? anim))
      anim))

;; set-turtle-on-off : Animation -> Animation
(define (set-turtle-on-off anim setting)
   (if (boolean? setting)
      (make-animation (animation-location anim)
                      (animation-image anim)
                      (animation-commands anim)
                      (animation-color anim)
                      (animation-pen? anim)
                      (animation-pen-size anim)
                      (animation-pen-style anim)
                      (animation-bg-color anim)
                      (animation-stamp? anim)
                      (animation-stamps anim)
                      (animation-origin anim)
                      setting)
      anim))

;; set-mirror-x-off : Animation -> Animation
(define (set-mirror-x-off anim)
  (set-location anim (make-turtle (get-position anim)
                                  (get-mirror-x anim)
                                  false)))

;; set-and-draw-bg-grid : Animation Number Number Color -> Animation
(define (set-and-draw-bg-grid anim x-step y-step color)
  (set-image anim (draw-grid x-step y-step (animation-origin anim) (animation-image anim) color)))

;; set-bg-image : Animation Image -> Animation
(define (set-bg-image-for anim img)
  (set-image anim img))

;; set-position-to-origin : Animation -> Animation
(define (set-position-to-origin anim)
  (set-location anim (make-turtle (make-position (get-origin-x anim)
                                                 (get-origin-y anim)
                                                 (get-angle anim))
                                   (get-mirror-x anim)
                                   (get-mirror-y anim))))

;; draw-image : Position Position Image String Number String -> Image
(define (draw-image new-pos old-pos img color size style)
  (cond [(and (on-screen? new-pos img)
              (on-screen? old-pos img))
         (add-line  img
                    (position-x old-pos)
                    (position-y old-pos)
                    (position-x new-pos)
                    (position-y new-pos)
                    ; color                                       ; WeScheme
                    (make-pen color size style PEN-CAP PEN-JOIN)  ; DrRacket
                    )]
        [else img]))

;; mirror : Number Number -> Number
(define (mirror p mp)
  (let ((delta (abs (- p mp)))) 
    (if (< p mp)
        (+ mp delta)
        (- mp delta))))

;; draw-m-image : Animation Animation -> Image
(define (draw-m-image next-step anim)
  (if (animation-pen? next-step)
      (let ((img (draw-image (get-position next-step) 
                             (get-position anim) 
                             (animation-image next-step)
                             (get-color next-step)
                             (animation-pen-size next-step)
                             (animation-pen-style next-step)))
            (mx (get-mirror-x anim))
            (my (get-mirror-y anim))
            (old-x (get-x anim))
            (old-y (get-y anim))
            (new-x (get-x next-step))
            (new-y (get-y next-step))
            (old-angle (get-angle anim))
            (new-angle (get-angle next-step)))
        (cond [(and (number? mx) (number? my))
               (draw-image (make-position (mirror new-x mx) (mirror new-y my) new-angle)
                           (make-position (mirror old-x mx) (mirror old-y my) old-angle)
                           img
                           (get-color next-step)
                           (animation-pen-size next-step)
                           (animation-pen-style next-step))]
              [ (number? mx)
               (draw-image (make-position (mirror new-x mx) new-y new-angle)
                           (make-position (mirror old-x mx) old-y old-angle)
                           img
                           (get-color next-step)
                           (animation-pen-size next-step)
                           (animation-pen-style next-step))]
              [ (number? my)
               (draw-image (make-position new-x (mirror new-y my) new-angle)
                           (make-position old-x (mirror old-y my) old-angle)
                           img
                           (get-color next-step) 
                           (animation-pen-size next-step)
                           (animation-pen-style next-step))]
              [else img]))
      (animation-image next-step)))

;; draw-stamp : Position Image Image -> Image
(define (draw-stamp posit img st)
    (cond [(on-screen? posit img)     
           (place-image st
                        (position-x posit)
                        (position-y posit)
                      img)]
        [else img]))

;; draw-m-stamp : Turtle Image Image -> Image
(define (draw-m-stamp t img st)
      (let ((image (draw-stamp (turtle-location t) img st))
            (mx (turtle-mirror-x t))
            (my (turtle-mirror-y t))
            (new-x (t-get-x t))
            (new-y (t-get-y t))
            (new-angle (t-get-angle t)))
        (cond [(and (number? mx) (number? my))
               (draw-stamp (make-position (mirror new-x mx) (mirror new-y my) new-angle)
                           image
                           st)]
              [ (number? mx)
               (draw-stamp (make-position (mirror new-x mx) new-y new-angle)
                           image
                           st)]
              [ (number? my)
               (draw-stamp (make-position new-x (mirror new-y my) new-angle)
                           image
                           st)]
              [else image])))

;; draw-animation : Animation -> Image
(define (draw-animation anim)
  (if (animation-turtle? anim)
      (place-image ORIGIN (get-origin-x anim) (get-origin-y anim) 
                   (place-image (rotate (get-angle anim) TURTLE) 
                                (get-x anim)
                                (get-y anim)
                                (animation-image anim)))
      (animation-image anim)))

;; remove turtle when image is ready (only used in DrRacket)
;; draw-last : Animation -> image
(define (draw-last anim)
  (animation-image anim))                       

;; ready? : Animation -> Boolean
(define (ready? anim)
  (empty? (animation-commands anim)))

;; handle-automatically : Animation -> Animation
(define (handle-automatically anim)
  (handle-command anim " "))

;; stationary? : Position Position -> Boolean
(define (stationary? old-pos new-pos)
  (and (= (position-x old-pos)
          (position-x new-pos))
       (= (position-y old-pos)
          (position-y new-pos))))
            
;; number-of-stamps : Animation -> Number
(define (number-of-stamps anim)
  (cond [(and (animation-stamp? anim)
              (image? (animation-stamps anim)))
         1]
        [(and (animation-stamp? anim)
              (list? (animation-stamps anim)))
         (length (animation-stamps anim))]
        [else 0]))
 
;; number-of-colors : Animation -> Number
(define (number-of-colors anim)
  (cond [(and (animation-pen? anim)
              (or (color? (animation-color anim))
                  (string? (animation-color anim))))
         1]
        [(and (animation-pen? anim) 
              (list? (animation-color anim)))
         (length (animation-color anim))]
        [else 0]))

;; handle-command : Animation String -> Animation
(define (handle-command anim k)  
  (cond [(empty? (animation-commands anim))
         anim]
        [else
         (letrec ((next-step ((first (animation-commands anim)) anim))
                  (moved? (not (stationary? (get-position anim) (get-position next-step)))))
           (cond [(and moved?
                       (= (number-of-stamps next-step) 1)
                       (= (number-of-colors next-step) 1))
                  (make-animation (animation-location next-step)
                                  (draw-m-stamp (animation-location next-step)
                                                (draw-m-image next-step anim)
                                                (animation-stamps next-step))
                                  (rest (animation-commands anim))
                                  (animation-color next-step)
                                  (animation-pen? next-step)
                                  (animation-pen-size next-step)
                                  (animation-pen-style next-step)
                                  (animation-bg-color next-step)
                                  (animation-stamp? next-step)
                                  (animation-stamps next-step)
                                  (animation-origin next-step)
                                  (animation-turtle? next-step))]
                 [(and moved?
                       (> (number-of-stamps next-step) 1)
                       (> (number-of-colors next-step) 1))
                  (make-animation (animation-location next-step)
                                  (draw-m-stamp (animation-location next-step) 
                                                (draw-m-image next-step anim)
                                                (first (animation-stamps next-step)))
                                  (rest (animation-commands anim))
                                  (append (rest (animation-color next-step))(list (first (animation-color next-step))))
                                  (animation-pen? next-step)
                                  (animation-pen-size next-step)
                                  (animation-pen-style next-step)
                                  (animation-bg-color next-step)
                                  (animation-stamp? next-step)
                                  (append (rest (animation-stamps next-step))(list (first (animation-stamps next-step))))
                                  (animation-origin next-step)
                                  (animation-turtle? next-step))]
                 [(and moved?
                       (> (number-of-stamps next-step) 1)
                       (= (number-of-colors next-step) 1))
                  (make-animation (animation-location next-step)
                                  (draw-m-stamp (animation-location next-step) 
                                                (draw-m-image next-step anim)
                                                (first (animation-stamps next-step)))
                                  (rest (animation-commands anim))
                                  (animation-color next-step)
                                  (animation-pen? next-step)
                                  (animation-pen-size next-step)
                                  (animation-pen-style next-step)
                                  (animation-bg-color next-step)
                                  (animation-stamp? next-step)
                                  (append (rest (animation-stamps next-step))(list (first (animation-stamps next-step))))
                                  (animation-origin next-step)
                                  (animation-turtle? next-step))]
                 [(and moved?
                       (= (number-of-stamps next-step) 1)
                       (> (number-of-colors next-step) 1))
                  (make-animation (animation-location next-step)
                                  (draw-m-stamp (animation-location next-step) 
                                                (draw-m-image next-step anim)
                                                (first (animation-stamps next-step)))
                                  (rest (animation-commands anim))
                                  (append (rest (animation-color next-step))(list (first (animation-color next-step))))
                                  (animation-pen? next-step)
                                  (animation-pen-size next-step)
                                  (animation-pen-style next-step)
                                  (animation-bg-color next-step)
                                  (animation-stamp? next-step)
                                  (animation-stamps next-step)
                                  (animation-origin next-step)
                                  (animation-turtle? next-step))]
                 [(and moved?
                       (= (number-of-stamps next-step) 1)
                       (= (number-of-colors next-step) 0))
                  (make-animation (animation-location next-step)
                                  (draw-m-stamp (animation-location next-step)
                                                (animation-image next-step)
                                                (animation-stamps next-step))
                                  (rest (animation-commands anim))
                                  (animation-color next-step)
                                  (animation-pen? next-step)
                                  (animation-pen-size next-step)
                                  (animation-pen-style next-step)
                                  (animation-bg-color next-step)
                                  (animation-stamp? next-step)
                                  (animation-stamps next-step)
                                  (animation-origin next-step)
                                  (animation-turtle? next-step))]
                 [(and moved?
                       (= (number-of-stamps next-step) 0)
                       (= (number-of-colors next-step) 1))
                  (make-animation (animation-location next-step)
                                  (draw-m-image next-step anim) 
                                  (rest (animation-commands anim))
                                  (animation-color next-step)
                                  (animation-pen? next-step)
                                  (animation-pen-size next-step)
                                  (animation-pen-style next-step)
                                  (animation-bg-color next-step)
                                  (animation-stamp? next-step)
                                  (animation-stamps next-step)
                                  (animation-origin next-step)
                                  (animation-turtle? next-step))]
                 [(and moved?
                       (> (number-of-stamps next-step) 1)
                       (= (number-of-colors next-step) 0))
                  (make-animation (animation-location next-step)
                                  (draw-m-stamp (animation-location next-step) 
                                                (animation-image next-step)
                                                (first (animation-stamps next-step)))
                                  (rest (animation-commands anim))
                                  (animation-color next-step)
                                  (animation-pen? next-step)
                                  (animation-pen-size next-step)
                                  (animation-pen-style next-step)
                                  (animation-bg-color next-step)
                                  (animation-stamp? next-step)
                                  (append (rest (animation-stamps next-step))(list (first (animation-stamps next-step))))
                                  (animation-origin next-step)
                                  (animation-turtle? next-step))]
                 [(and moved?
                       (= (number-of-stamps next-step) 0)
                       (> (number-of-colors next-step) 1))
                  (make-animation (animation-location next-step)
                                  (draw-m-image next-step anim)
                                  (rest (animation-commands anim))
                                  (append (rest (animation-color next-step))(list (first (animation-color next-step))))
                                  (animation-pen? next-step)
                                  (animation-pen-size next-step)
                                  (animation-pen-style next-step)
                                  (animation-bg-color next-step)
                                  (animation-stamp? next-step)
                                  (animation-stamps next-step)
                                  (animation-origin next-step)
                                  (animation-turtle? next-step))]
                 [else 
                  (make-animation (animation-location next-step)
                                  (draw-m-image next-step anim) 
                                  (rest (animation-commands anim))
                                  (animation-color next-step)
                                  (animation-pen? next-step)
                                  (animation-pen-size next-step)
                                  (animation-pen-style next-step)
                                  (animation-bg-color next-step)
                                  (animation-stamp? next-step)
                                  (animation-stamps next-step)
                                  (animation-origin next-step)
                                  (animation-turtle? next-step))]))]))

;; this is needed in WeScheme (comment out in DrRacket)
;(define (reverse-flatten-into x lst)
;  (if (not (procedure? x))
;      (foldl reverse-flatten-into lst x)
;      (cons x lst)))

;(define (flatten lst)
;  (reverse (reverse-flatten-into lst '())))

;; ---------------------------------------------------------------------------------------------------
;; turtle-commands:
;; ---------------------------------------------------------------------------------------------------
;; forward : Number -> Procedure
(define (forward distance)
  (lambda (x) (new-turtle-position-full x distance)))

;; turn-left : Number -> Procedure
(define (turn-left turn)
  (lambda (x) (new-turtle-direction-full x turn)))

;; turn-right : Number -> Procedure
(define (turn-right turn)
  (lambda (x) (new-turtle-direction-full x (* -1 turn))))

;; pen-up : void -> Procedure
(define (pen-up)
  (lambda (x) (set-pen x false)))

;; pen-down : void -> Procedure
(define (pen-down)
  (lambda (x) (set-pen x true)))

;; change-color : String -> Procedure
(define (change-color color)
  (lambda (x) (set-color x color)))

;; repeat : Number List-of-procedures -> List-of-procedures
(define (repeat times commands)
  (if (<= times 0)
      '()
      (append (if (list? commands) 
                   commands
                  (list commands))
              (repeat (sub1 times) commands))))

;; change-bg-color : String -> Procedure
(define (change-bg-color color)
  (lambda (x) (set-bg-color x color)))

;; go-to : Number Number -> Procedure
(define (go-to x y)
  (lambda (z) (set-position z x y))) 

;; clean-up : void -> Procedure
(define (clean-up)
  (lambda (x) (clean-up-image x)))

;; stamper-on : Image -> Procedure
(define (stamper-on img)
  (lambda (x) (set-stamper-image x img)))

;; stamper-off : void -> Procedure
(define (stamper-off)
  (lambda (x) (set-stamper-off x)))

;; mirror-x-on : void -> Procedure
(define (mirror-x-on)
  (lambda (x) (set-mirror-x-on x)))

;; mirror-y-on : void -> Procedure
(define (mirror-y-on)
  (lambda (x) (set-mirror-y-on x)))

;; mirror-x-off : void -> Procedure
(define (mirror-x-off)
  (lambda (x) (set-mirror-x-off x)))

;; mirror-y-off : void -> Procedure
(define (mirror-y-off)
  (lambda (x) (set-mirror-y-off x)))

;; set-origin : void -> Procedure
(define (set-origin)
  (lambda (x) (set-origin-xy x)))

;; set-bg-grid : Number Number Color -> Procedure 
(define (set-bg-grid x y color)
  (lambda (z) (set-and-draw-bg-grid z x y color)))

;; set-bg-image : Image -> Procedure
(define (set-bg-image img)
  (lambda (x) (set-bg-image-for x img)))

;; go-to-origin : void -> Procedure
(define (go-to-origin)
  (lambda (x) (set-position-to-origin x)))

;; change-pen-size : Number -> Procedure
(define (change-pen-size size)
  (lambda (x) (set-pen-size x size)))

;; change-pen-style : String -> Procedure
(define (change-pen-style style)
  (lambda (x) (set-pen-style x style)))

;; hide-turtle : <void> -> Procedure
(define (hide-turtle)
  (lambda (x) (set-turtle-on-off x false)))

;; show-turtle : <void> -> Procedure
(define (show-turtle)
  (lambda (x) (set-turtle-on-off x true)))

;; ---------------------------------------------------------------------------------------------------
;; Functions for starting the animation
;; ---------------------------------------------------------------------------------------------------
(define (create-animation list-of-commands width height) 
  (make-animation (make-turtle (make-position (/ width 2) (/ height 2) 0) false false)
                 (empty-scene width height BG-COLOR)
                  (flatten list-of-commands) 
                  COLOR 
                  true
                  1
                  "solid"
                  BG-COLOR
                  false
                  '()
                  (make-position 0 height 0)
                  true))

;; give-speed : Number -> Number
(define (give-speed sp)
  (if (> sp 0)
      sp
      (/ 1 28)))

;; draw : List-of-procedures -> Image
(define (draw list-of-commands)
  (animation-image (big-bang 
                    (create-animation list-of-commands WIDTH HEIGHT)
                    (to-draw draw-animation)
                    (on-tick handle-automatically)
                    (stop-when ready? draw-last))))  

;; draw-custom : List-of-procedures -> Image
(define (draw-custom list-of-commands width height speed)
  (animation-image (big-bang 
                    (create-animation list-of-commands width height)
                    (to-draw draw-animation)
                    (on-tick handle-automatically (give-speed speed))
                    (stop-when ready? draw-last))))  

;; draw-and-store : List-of-procedures -> Image
(define (draw-and-store list-of-commands)
  (animation-image (big-bang 
                    (create-animation list-of-commands WIDTH HEIGHT)
                    (to-draw draw-animation)
                    (on-tick handle-automatically)
                    (record? "turtle_animations")   ;; stores animated gifs in this folder
                    (stop-when ready? draw-last))))  

;; draw-and-store-custom : List-of-procedures -> Image
(define (draw-and-store-custom list-of-commands width height speed)
  (animation-image (big-bang 
                    (create-animation list-of-commands width height)
                    (to-draw draw-animation)
                    (on-tick handle-automatically (give-speed speed))
                    (record? "turtle_animations")   ;; stores animated gifs in this folder
                    (stop-when ready? draw-last))))  

;; draw commands step by step when a key is pressed
;; draw-step-by-step : List-of-procedures -> Image
(define (draw-step-by-step list-of-commands)
  (animation-image (big-bang 
                     (create-animation list-of-commands WIDTH HEIGHT)
                    (on-key handle-command)
                    (to-draw draw-animation)
                    (stop-when ready? draw-last))))   

;; draw commands step by step when a key is pressed
;; draw-step-by-step-custom : List-of-procedures -> Image
(define (draw-step-by-step-custom list-of-commands width height)
  (animation-image (big-bang 
                     (create-animation list-of-commands width height)
                    (on-key handle-command)
                    (to-draw draw-animation)
                    (stop-when ready? draw-last))))   

;; Finnish versions for starting animation:
(define (piirrä list-of-commands)
  (draw list-of-commands WIDTH HEIGHT))

(define (piirrä-osissa list-of-commands)
  (draw-step-by-step list-of-commands WIDTH HEIGHT))