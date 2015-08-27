#lang scribble/manual

@(require scriblib/figure)
@(require 2htdp/image)
@(require teachpacks/racket-turtle)
@(require (for-label lang/htdp-beginner))
@(require (for-label (except-in 2htdp/image image?)))
@(require (for-label teachpacks/racket-turtle))
@(require scribble/core
          scribble/html-properties)
@(require scribble/eval)

@declare-exporting[teachpacks/racket-turtle]

@title[#:tag "racket_turtlen_functionality"]{Racket Turtle Principles}

@(begin
   (require scribble/manual scribble/eval fin-doc/sl-eval)
   (define (bsl)
     (define *bsl
       (bsl+-eval
        (require 2htdp/image)
        (require teachpacks/racket-turtle)
        (define line1 (list (forward 100)))
        ))
     (set! bsl (lambda () *bsl))
     *bsl))

With Racket Turtle - library you can draw traditional turtle-graphics by ordering @italic{turtle} (black triangle)
to move forward, to turn left, to lift its pen up, to put it down etc. In addition to this you can draw stamps in the
turtle positions, mirror turtle's movements vertically and horizontally or order turtle to travel  
via some specific coordinates. You can make your images more interesting by changing the color of the pen, the width
and type of the line, also the background color and image can be set to your preferences.

@centered[@image[#:scale 0.8 "turtle1.png"]]

To give orders to turtle you need to create a list of turtle commands. This list is given as an argument to a drawing
function, which reads the commands and draws the image. By selecting a different drawing function, you can change the
animation window size and drawing speed, store the animation as a animated gif or draw the image step by step.

It is preferable to define the command list and give it a good desciptive name. The simplest command list
contains one command and its arguments written inside parenthesis.

@section[#:style 'unnumbered "Simple example"]

This command list draws one blue line of length 100 pixels from the middle of the animation screen towards the top
of the screen (the starting point of the turtle is in the middle of the screen in (250, 250) and it is facing up).

Defining a command list @italic{line1} for drawing the line (in definitions window):
@racketblock[(define line1 (list (forward 100)))]

Calling the drawing function @italic{draw} with @italic{line1} as the argument (in interactions window):
@interaction[#:eval (bsl)(draw line1)]

All Racket Turtle commands and drawing functions are presented in the following chapters.