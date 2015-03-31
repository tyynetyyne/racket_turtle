;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname turtle_esimerkit) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require "teachpacks/racket_turtle.rkt")  

;; DrRacket: valitse Beginning Student Language
;;                   -> Language -> Choose Language -> Teaching Languages -> Beginning Student
;; --------------------------------------------------------------------------------------------------
;; Racket-Turtle:
;; --------------------------------------------------------------------------------------------------
;; Turtlea ohjataan seuraavilla turtle-komennoilla:
;;   (forward <matka>)
;;   (turn-right <kulman suuruus>)
;;   (turn-left <kulman suuruus>)
;;   (pen-up)
;;   (pen-down)
;;   (change-color <väri>)
;;   (repeat <kerrat> <komentolista>)
;;
;; Useampi komento yhdistetään komentolistaksi:
;;   (list <turtle-komento>
;;         <turtle-komento>)
;; 
;; Komentolista annetaan piirtofunktiolle:
;;   (piirrä <komentolista>)  TAI 
;;   (piirrä-osissa <komentolista>)
;; jälkimmäinen piirtää kuvion viiva kerrallaan, kun painetaan jotain näppäintä
;; 
;; Tiina Partanen
;;
;; ---------------------------------------------------------------------------------------------------
;; Tässä muutamia esimerkkejä, joilla pääset alkuun.
;;
;; HUOM! Paina "run", kirjoita sitten kuviota vastaava piirtofunktiokutsu REPL:iin ja paina <enter>
;; ---------------------------------------------------------------------------------------------------
;; Esimerkki 1: piirrä neliö
(define neliö 
  (list (forward 100) 
        (turn-left 90) 
        (forward 100) 
        (turn-left 90) 
        (forward 100) 
        (turn-left 90)
        (forward 100)))

;(piirrä neliö)

;; ---------------------------------------------------------------------------------------------------
;; Esimerkki 2: piirrä neliö käyttämällä toistorakennetta (repeat)
(define sivu 
  (list (forward 100) 
        (turn-left 90)))

(define toisto-neliö 
  (repeat 4 sivu))

;(piirrä toisto-neliö)

;; ---------------------------------------------------------------------------------------------------
;; Esimerkki 3: piirrä kaksi neliötä samaan kuvaan
(define siirry
  (list (pen-up)
        (turn-right 90)
        (forward 100) 
        (pen-down) 
        (change-color "red")))

(define kaksi-neliötä 
  (list neliö 
        siirry 
        neliö))

;(piirrä kaksi-neliötä)

;; ----------------------------------------------------------------------------------------------------
;; Esimerkki 4: piirrä eri kokoisia neliöitä funktion avulla (x = sivun pituus)
(define (muuttuva-sivu x) 
  (list (forward x) 
        (turn-left 90)))

(define (muuttuva-neliö x) 
  (repeat 4 (muuttuva-sivu x)))

;(piirrä (muuttuva-neliö 30))  