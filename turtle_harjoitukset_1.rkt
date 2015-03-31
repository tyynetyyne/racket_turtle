;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname turtle_harjoitukset_1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
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
;; Katso esimerkkejä turtle_esimerkit.rkt tiedostosta
;; 
;; Tiina Partanen
;; 
;; ---------------------------------------------------------------------------------------------------
;; Tehtävät:
;; ---------------------------------------------------------------------------------------------------
;; 1: Muuta alla oleva koodi niin, että se tekee suorakulmion, joka ei ole neliö. Muuta myös nimi.
;;    Testaa koodisi näin: paina "run", kirjoita REPL:iin (piirrä suorakulmio) ja paina <enter>.
;; ---------------------------------------------------------------------------------------------------
(define neliö 
  (list (forward 100) 
        (turn-left 90) 
        (forward 100) 
        (turn-left 90) 
        (forward 100) 
        (turn-left 90)
        (forward 100)))

;; ---------------------------------------------------------------------------------------------------
;; 2: Kirjoita ohjeet tasasivuisen kolmion piirtämiseksi ja testaa se.
;; ---------------------------------------------------------------------------------------------------



;; ---------------------------------------------------------------------------------------------------
;; 3: Kirjoita ohjeet kuusikulmion piirtämiseksi ja testaa se.
;; ---------------------------------------------------------------------------------------------------



;; ---------------------------------------------------------------------------------------------------
;; 4: Kirjoita ohjeet suunnikkaan piirtämiseksi ja testaa se.
;; ---------------------------------------------------------------------------------------------------



;; ---------------------------------------------------------------------------------------------------
;; 5: Kirjoita ohjeet ympyrän piirtämiseksi ja testaa se. Huom. tarvitset nyt "repeat"-käskyä.
;; ---------------------------------------------------------------------------------------------------



;; ---------------------------------------------------------------------------------------------------
;; 6: Kirjoita ohjeet oman kuvion piirtämiseksi ja testaa se.
;; ---------------------------------------------------------------------------------------------------



;; ---------------------------------------------------------------------------------------------------
;; 7: Kirjoita ohjeet kaikkien em. kuvioiden piirtämiseksi samaan kuvaan ERI väreillä. 
;;    Huom. Tarvitset nyt "pen-up", "pen-down" ja "change-color" -käskyjä.
;; ---------------------------------------------------------------------------------------------------

