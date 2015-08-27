# racket_turtle

Racket-Turtle is a teachpack for teaching Racket-programming and math concepts in middle-school. You can draw geometric 
shapes using Racket-Turtle animation. You need DrRacket for running this package (download it here: http://racket-lang.org/download/).

1) First you define a list containing the Turtle-commands:
Example 1: square

> (define square1 
>  (list (forward 100)
>        (turn-left 90)
>        (forward 100)
>        (turn-left 90)
>        (forward 100)
>        (turn-left 90)
>        (forward 100)))
        
2) Then you give the defined list to a drawing function:
> (draw square1)

The complete documentation of this library can be found in: 
http://racket.koodiaapinen.fi/racket_turtle_eng/index.html 

Want to see Racket Turtle in action? 
http://touch.wescheme.appspot.com/view?publicId=DhQn0zS5LN (select "Play")

Have fun!
