;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname bug_hunting) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
; Test code for finding a bug in animated gif creation (big-bang option: record)
; The last image of the animated gif is not correct in half of the cases (sometimes works
; fine, sometimes displays an earlier (random) image as the final image).

(require "teachpacks/racket_turtle.rkt")

(define (make-side len ang)
  (list (forward len)(turn-left ang)))

(define (spiral times len ang)
  (if (< times 0)
      empty
      (append (make-side len ang) (spiral (sub1 times) (+ 4 len) ang))))

(draw-and-store (spiral 100 1 91))