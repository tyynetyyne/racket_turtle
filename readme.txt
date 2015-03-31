# racket_turtle

Racket-Turtle is a teachpack for teaching Racket-programming and math concepts in middle-school. You can draw geometric 
shapes using Racket-Turtle animation. First you define a list containing the Turtle-commands:

Example 1: square

(define square1 
  (list (forward 100) 
        (turn-left 90) 
        (forward 100) 
        (turn-left 90) 
        (forward 100) 
        (turn-left 90)
        (forward 100)))
        
Then you call the drawing function in the REPL (you need DrRacket to be installed):
> (draw square1)

More examples and full description of the Turtle-commands can be found in these files:

- racket_turtle_examples.rkt  (English)
- racket_turtle_esimerkit.rkt (Finnish)

Have fun!