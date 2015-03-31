;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname turtle_examples) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require "teachpacks/racket_turtle.rkt")  

;; In DrRacket: use Beginning Student Language with this module
;;                   -> Language -> Choose Language -> Teaching Languages -> Beginning Student
;; --------------------------------------------------------------------------------------------------
;; Racket-Turtle:
;; --------------------------------------------------------------------------------------------------
;; Move your Turtle with these commands:
;;   (forward <distance>)
;;   (turn-right <angle>)
;;   (turn-left <angle>)
;;   (pen-up)
;;   (pen-down)
;;   (change-color <color>)
;;   (repeat <times> <list-of-commands>)
;;
;; Form a list of commands for your Turtle:
;;   (list <turtle-command>
;;         <turtle-command>)
;; 
;; Start Turtle-animation:
;;   (draw <list-of-commands>)  OR 
;;   (draw-step-by-step <list-of-commands>)
;; the later draws the image one line at the time when a key is pressed
;; 
;; Tiina Partanen
;;
;; ---------------------------------------------------------------------------------------------------
;; Here are some examples to start with.
;;
;; NOTE! Hit "run", then write the corresponding "draw" expression in the REPL and press <enter>
;; ---------------------------------------------------------------------------------------------------
;; Example 1: draw a square
(define square1 
  (list (forward 100) 
        (turn-left 90) 
        (forward 100) 
        (turn-left 90) 
        (forward 100) 
        (turn-left 90)
        (forward 100)))

;(draw square1)

;; ---------------------------------------------------------------------------------------------------
;; Example 2: draw square using repeat
(define side 
  (list (forward 100) 
        (turn-left 90)))

(define r-square 
  (repeat 4 side))

;(draw r-square)

;; ---------------------------------------------------------------------------------------------------
;; Example 3: draw two squares in the same picture
(define move
  (list (pen-up)
        (turn-right 90)
        (forward 100) 
        (pen-down) 
        (change-color "red")))

(define two-squares 
  (list square1 
        move 
        square1))

;(draw two-squares)

;; ----------------------------------------------------------------------------------------------------
;; Example 4: draw squares of different sizes (x)
(define (v-side x) 
  (list (forward x) 
        (turn-left 90)))

(define (v-square x) 
  (repeat 4 (v-side x)))

;(draw (v-square 30))  