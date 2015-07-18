;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname esimerkkikuviot_v.0.5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
(require 2htdp/image)
(require "teachpacks/racket_turtle.rkt")

;; levenevä spiraali
(define VÄRIT (list "red" "blue" "green" "yellow" "purple"))

(define (sivu p l k)
  (list (change-pen-size l) (forward p)(turn-left k)))

(define (levenevä-spiraali2 p l k kerrat)
  (if (<= kerrat 0)
      empty
      (cons (sivu p l k) (levenevä-spiraali2 (+ p 5) (+ l 1) k (sub1 kerrat)))))

(define levenevä-spiraali (list (change-bg-color "black")(change-color VÄRIT) (levenevä-spiraali2 1 1 45 45)))

(draw levenevä-spiraali)

;; Spiraalikuvio
(define VÄRIT2 (list "red" "green" "yellow" "purple"))

(define (spiraali k p kerrat)
  (if (< kerrat 0)
      empty
      (append (list (forward p)(turn-left k)) (spiraali k (+ p 2)(sub1 kerrat)))))

(define spiraalikuvio
  (list (change-pen-size 2) 
        (change-bg-color "black") 
        (change-color VÄRIT2)
        (spiraali 91 1 152)))

(draw spiraalikuvio)

;; kukkaspiraali
(define (lehti koko väri)
  (ellipse (* 8 koko) koko "solid" väri))

(define (lehdet koko väri)
  (overlay (lehti koko väri)
           (rotate 90 (lehti koko väri))))

(define (tee-kukka2 koko väri)
  (overlay (circle (/ koko 2) "solid" "white")  
           (lehdet koko väri)
           (rotate 45 (lehdet koko väri))))

(define (kukka-spiraali k p kerrat)
  (if (< kerrat 0)
      empty
      (append (list (forward p)(turn-left k)) (kukka-spiraali k (+ p 6)(sub1 kerrat)))))

(define (tee-kukat määrä koko)
  (if (<= määrä 0)
      empty
      (cons (rotate koko (tee-kukka2 koko (make-color (random 255)(random 255)(random 255))))(tee-kukat (sub1 määrä)(add1 koko)))))
                    
(define kukkaspiraali (list (stamper-on (tee-kukat 20 1))
                            (pen-up)
                            (kukka-spiraali 25 1 20)))

(draw kukkaspiraali)

;; tähtispiraali
(define (tee-tähdet määrä koko)
  (if (<= määrä 0)
      empty
      (cons (rotate koko (star koko "solid" (make-color (random 255)(random 255)(random 255))))(tee-tähdet (sub1 määrä)(add1 koko)))))
                            
(define tähtispiraali (list (stamper-on (tee-tähdet 100 1))
                            (pen-up)
                            (spiraali 91 1 100)))

(draw tähtispiraali)

;; peilauskukka
(define (tee-kaari väri koko kynä) 
  (list (change-color väri)
        (change-pen-size kynä)
        (repeat (round (* (/ 90 koko))) (list (forward koko) (turn-left koko)))))

(define (tee-lehti väri koko kynä)
  (list (tee-kaari väri koko kynä)
        (turn-left 90)
        (tee-kaari väri koko kynä)))

(define (tee-kukka väri koko kynä)
  (list (mirror-x-on)
        (mirror-y-on)
        (repeat 2 (tee-lehti väri koko kynä))))

(define peilauskukka (list (tee-kukka "red" 3 5)
                           (turn-left 45)
                           (tee-kukka "pink" 3 2)))

(draw peilauskukka)

;; multi-kukka-spiraali
(define (tee-kukat2 määrä koko väri)
  (if (<= määrä 0)
      empty
      (cons (rotate koko (tee-kukka2 koko väri))(tee-kukat2 (sub1 määrä)(add1 koko) väri))))

(define multi-kukka-spiraali
  (list 
   (change-bg-color "black")
   (set-origin)
   (pen-up)
        (stamper-on (tee-kukat2 50 1 "yellow"))
        (kukka-spiraali 25 1 15)
        (turn-left 90)
        (stamper-on (tee-kukat2 50 1 "blue"))
        (go-to 0 0)
        (kukka-spiraali 25 1 15)
        (turn-left 120)
        (stamper-on (tee-kukat2 50 1 "red"))
        (go-to 0 0)
        (kukka-spiraali 25 1 15)))

(draw-and-store multi-kukka-spiraali)
        
;; koordinaatisto-kuva
(define koordinaatisto-kuva
  (list (set-origin) 
        (set-bg-grid 30 30 "blue")
        (mirror-x-on)
        (mirror-y-on)
        (stamper-on (circle 5 "solid" "red"))
        (change-pen-style "dot")
        (change-pen-size 3)
        (change-color "red")   
        (pen-up)
        (go-to 60 0)
        (pen-down)
        (go-to 120 60)
        (go-to 60 60)
        (go-to 60 120)
        (go-to 0 60)
        (go-to -60 120)
        (go-to -60 60)
        (go-to -120 60)
        (go-to -60 0)))

(draw-custom koordinaatisto-kuva 600 600 0)

;; kukkaspiraali-koordinaatistossa
(define taustakuva (draw koordinaatisto-kuva))

(define kukkaspiraali-koordinaatistossa
  (list 
   (set-bg-image taustakuva)
   (set-origin)
   (pen-up)
        (stamper-on (tee-kukat2 50 1 "red"))
        (go-to 0 0)
        (kukka-spiraali 25 1 15)))

(draw kukkaspiraali-koordinaatistossa)


  
  
