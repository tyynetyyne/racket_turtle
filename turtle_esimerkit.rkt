;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname turtle_esimerkit) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require "teachpacks/racket_turtle.rkt")  
(require 2htdp/image)

;; DrRacket: valitse Beginning Student Language
;;                   -> Language -> Choose Language -> Teaching Languages -> Beginning Student
;; ---------------------------------------------------------------------------------------------------
;; Tässä muutamia esimerkkejä, joilla pääset alkuun.
;;
;; HUOM! Paina "run", kirjoita sitten kuviota vastaava "draw"-funktiokutsu REPL:iin ja paina <enter>
;; tai poista kommenttimerkki rivin edestä ja paina "run" 
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

;(draw neliö)

;; ---------------------------------------------------------------------------------------------------
;; Esimerkki 2: piirrä neliö käyttämällä toistorakennetta (repeat)
(define sivu 
  (list (forward 100) 
        (turn-left 90)))

(define toisto-neliö 
  (repeat 4 sivu))

;(draw toisto-neliö)

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

;(draw kaksi-neliötä)

;; ----------------------------------------------------------------------------------------------------
;; Esimerkki 4: piirrä eri kokoisia neliöitä funktion avulla (x = sivun pituus)
(define (muuttuva-sivu x) 
  (list (forward x) 
        (turn-left 90)))

(define (muuttuva-neliö x) 
  (repeat 4 (muuttuva-sivu x)))

;(draw (muuttuva-neliö 30))  

;; ----------------------------------------------------------------------------------------------------
;; Esimerkki 5: piirrä kuvio ohjaamalla turtle tiettyihin koodinaattipisteisiin
;; set-origin asettaa origoksi sen pisteen jossa turtle sillä hetkellä on
(define koordinaatti-neliö
  (list (set-origin)
        (go-to 100 0)
        (go-to 100 100)
        (go-to 0 100)
        (go-to 0 0)))

; (draw-step-by-step koordinaatti-neliö)

;; ----------------------------------------------------------------------------------------------------
;; Esimerkki 6: piirrä neliö ja peilaa se x-akselin ja y-akselin suhteen
(define peilaus-neliö
  (list (mirror-x-on) (mirror-y-on)
        neliö))

;(draw peilaus-neliö)

;; ----------------------------------------------------------------------------------------------------
;; Esimerkki 7: piirrä neliö käyttämällä leimasinta
;; leimasin painaa kuvan jokaisen etapin jälkeen
(define leimasin (circle 5 "solid" "red"))

(define leimasin-neliö
  (list (stamper-on leimasin)
        (pen-up)
        neliö))

;(draw leimasin-neliö)

;; ----------------------------------------------------------------------------------------------------
;; Esimerkki 8: piirrä suoran kuvaaja koordinaatistoon, merkitse neljä pistettä kuvaajalta
(define viiva-koordinaatistossa 
  (list (set-bg-grid 20 20 "pink")
        (pen-up)
        (go-to 0 0)
        (stamper-on leimasin)
        (pen-down)
        (go-to 40 40)
        (go-to 80 80)
        (go-to 120 120)
        (go-to 160 160)
        (stamper-off)
        (go-to 500 500)))

;(draw viiva-koordinaatistossa)

;; Esimerkki 9: muuta piirtoalueen kokoa (1000 x 600), taustaväriä ja taustakuvaa
;; taustakuva asetetaan keskelle piirtoaluetta, 0 tarkoittaa että animaation nopeutta ei muuteta
(define neliö-taustakuvan-päällä
  (list (change-bg-color "black")
        (set-bg-image (circle 100 "solid" "gold"))
        neliö))

;(draw-custom neliö-taustakuvan-päällä 1000 600 0)

;; Esimerkki 10: määrittele leimasimelle eri kuvia (listana) ja tee turtlen etenemisestä animoitu-gif
;; gif löytyy kansiosta "turtle_animations"
(define LEIMASIMET 
  (list (circle 5 "outline" "red")
        (circle 10 "outline" "red")
        (circle 15 "outline" "red")
        (circle 20 "outline" "red")
        (circle 35 "outline" "red")))

(define suora-leimasimilla
  (list (pen-up)
        (turn-right 45)
        (stamper-on LEIMASIMET)
        (repeat 7 (forward 40))))

;(draw-and-store suora-leimasimilla)

;; Esimerkki 11: piirrä useampi kuva ja tyhjennä ruutu välillä, hidasta animaation nopeutta (1 kuva sekunnissa)
(define kaksi-kuvaa-ja-tyhjennys
  (list (pen-up) 
        (go-to 0 0)
        suora-leimasimilla
        (clean-up)
        suora-leimasimilla))

;(draw-custom kaksi-kuvaa-ja-tyhjennys 500 500 1)

;; - invisible turtle (hide-turtle)(show-turtle)
;; - show-turtle? (not needed?)

;; Esimerkki 12: voit laskea pisteiden sijainnit
(define laskettu-sijainti
  (list (set-origin)
        (go-to (* (cos (/ pi 4)) 100) (* (sin (/ pi 4)) 100))))

;(draw laskettu-sijainti)

;; Esimerkki 13: vaihda kynän leveyttä ja viivan tyyliä
;; size : 0 - 255
;; style: "solid", "dot", "long-dash", "short-dash", "dot-dash"
(define erikoinen-kynä
  (list (change-pen-size 2)
        (change-pen-style "dot") 
        neliö))

;(draw erikoinen-kynä)

;; Esimerkki 14: piirrä kynällä jonka väri muuttuu listan mukaan, piilota turtle alussa, laita näkyviin puolivälissä
(define SATEENKAARI (list "red" "blue" "green" "yellow" "purple"))

(define sateenkaari-viiva
  (list (pen-up)
        (go-to 0 0)
        (turn-right 45)
        (pen-down)
        (change-color SATEENKAARI)
        (change-pen-size 10)
        (hide-turtle)
        (repeat 8 (forward 40))
        (show-turtle)
        (repeat 8 (forward 40))))

;(draw-custom sateenkaari-viiva 500 500 0.5)