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
@(require scribble/pdf-render)

@declare-exporting[teachpacks/racket-turtle]

@title[#:tag "racket_turtle_examples"]{Racket Turtle examples}

@(begin
   (require scribble/manual scribble/eval fin-doc/sl-eval)
   (define (bsl)
    (define *bsl
       (bsl+-eval
        (require 2htdp/image)
        (require teachpacks/racket-turtle)
        (define square1
               (list (forward 100)
                     (turn-left 90)
                     (forward 100)
                     (turn-left 90)
                     (forward 100)
                     (turn-left 90)
                     (forward 100)))
               (define side
               (list (forward 100)
                     (turn-left 90)))
(define repeat-square
               (repeat 4 side))
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

(define (changing-side x) 
               (list (forward x) 
                     (turn-left 90)))

(define (changing-square x) 
               (repeat 4 (changing-side x)))
(define coordinate-square
  (list (set-origin)
        (go-to 100 0)
        (go-to 100 100)
        (go-to 0 100)
        (go-to 0 0)))
(define mirroring-square
   (list (mirror-x-on) (mirror-y-on)
         square1))
(define STAMP (circle 5 "solid" "red"))
(define stamper-square
  (list (stamper-on STAMP)
        (pen-up)
        square1))
(define special-pen-square
  (list (change-pen-size 5)
        (change-pen-style "dot") 
        square1))
(define line-with-grid
  (list (set-bg-grid 20 20 "pink")
        (pen-up)
        (go-to 0 0)
        (stamper-on (circle 5 "solid" "blue"))
        (pen-down)
        (go-to 40 40)
        (go-to 80 80)
        (go-to 120 120)
        (go-to 160 160)
        (stamper-off)
        (go-to 500 500)))
(define STAMPS 
  (list (circle 10 "solid" "red")
        (star 10 "solid" "blue")
        (circle 10 "solid" "green")
        (star 10 "solid" "yellow")
        (circle 10 "solid" "black")))
 (define line-with-stamps
   (list (pen-up)
         (go-to-origin)
         (turn-right 45)
         (stamper-on STAMPS)
         (repeat 8 (forward 50))))
(define square-over-bg
  (list (change-bg-color "black")
        (set-bg-image (circle 100 "solid" "gold"))
        square1))
(define COLORS
  (list "red" "blue" "green" "yellow" "purple"))
(define color-line
  (list (pen-up)
        (go-to 0 0)
        (turn-right 45)
        (pen-down)
        (change-color COLORS)
        (change-pen-size 10)
        (hide-turtle)
        (repeat 8 (forward 40))
        (show-turtle)
        (repeat 8 (forward 40))))
         ))
     (set! bsl (lambda () *bsl))
     *bsl))

@section[#:tag "racket_turtle_square"]{Drawing a square}

First you need to @racket[define] a list of turtle commands for drawing a square. We will name it @italic{square1}.
Actual drawing of the turtle image is done using @racket[draw] function, the turtle command list is given as an argument
to @racket[draw].

@racketblock[(define square1
               (list (forward 100)
                     (turn-left 90)
                     (forward 100)
                     (turn-left 90)
                     (forward 100)
                     (turn-left 90)
                     (forward 100)))]

@interaction[#:eval (bsl)
             (draw square1)]

@section[#:tag "racket_turtle_square_with_repeat"]{Drawing a square using repeat}

Since the command list for drawing a square has a repeating pattern, it is better to define it separately
and use it repeatedly. We will name it @italic{side} and we will repeat it 4 times using @racket[repeat].

@racketblock[(define side
               (list (forward 100)
                     (turn-left 90)))]
@racketblock[(define repeat-square
               (repeat 4 side))]

@interaction[#:eval (bsl)
             (draw repeat-square)]

@section[#:tag "racket_turtle_two_squares"]{Drawing two squares in a same picture}

We can use a previously defined square and draw two of those in the same picture. We will define a list of
commands @italic{move} to move to a new location and changes the pen color before drawing the second square.

@racketblock[(define move
               (list (pen-up)
                     (turn-right 90)
                     (forward 100) 
                     (pen-down) 
                     (change-color "red")))]

@racketblock[(define two-squares 
               (list square1 
                     move 
                     square1))]

@interaction[#:eval (bsl) 
             (draw two-squares)]

@section[#:tag "racket_turtle_square_using_function"]{Drawing a square using a function}

To be able to draw squares with changing side lengths, we need to define a @italic{function}, which we will name
@italic{changing-square}. We need also a helper function @italic{changing-side} to draw sides with changing lengths.
The variable @racket[x] is the side length. Finally we call the new function @italic{changing-square}
with argument 30 (@italic{x=30}).

@racketblock[(define (changing-side x) 
               (list (forward x) 
                     (turn-left 90)))]

@racketblock[(define (changing-square x) 
               (repeat 4 (changing-side x)))]
             
@interaction[#:eval (bsl)
             (draw (changing-square 30))]

@section[#:tag "racket_turtle_coordinate_square"]{Drawing a square using coordinates}

You can draw a square also by ordering the turtle to go via some points in the coordinate plane using @racket[go-to]
commands. To get easier coordinates we change the place of the origin with @racket[set-origin] command. 

@racketblock[
(define coordinate-square
  (list (set-origin)
        (go-to 100 0)
        (go-to 100 100)
        (go-to 0 100)
        (go-to 0 0)))]

@interaction[#:eval (bsl)
             (draw coordinate-square)]

@section[#:tag "racket_turtle_mirroring_square"]{Mirroring a square}

We can draw two square so that the second one is created by mirroring the first one using a pivot point.
The pivot point is the location where the mirroring was turned on (@racket[mirron-x-on], @racket[mirron-y-on]),  
in this example it is the starting point.

@racketblock[
 (define mirroring-square
   (list (mirror-x-on) (mirror-y-on)
         square1))]

@interaction[#:eval (bsl)(draw mirroring-square)]

@section[#:tag "racket_turtle_square_with_stamper"]{Drawing a square using a stamper}

We can activate the stamper functionality using @racket[stamper-on] command. Now the turtle will "stamp" the given image after
each movement. Here we use a red circle as the stamp. You could also let the pen draw the line also (here is it
taken up).

@racketblock[
(define STAMP (circle 5 "solid" "red"))]

@racketblock[
(define stamper-square
  (list (stamper-on STAMP)
        (pen-up)
        square1))]

@interaction[#:eval (bsl)(draw stamper-square)]

@section[#:tag "racket_turtle_changing_pen_style_and_size"]{Changing pen style and size}

You can change the style of the line using @racket[change-pen-style] command and the width of the line using 
@racket[change-pen-size] command.

@italic{Note!} This doesn't work in WeScheme.

@racketblock[
(define special-pen-square
  (list (change-pen-size 5)
        (change-pen-style "dot") 
        square1))]

@interaction[#:eval (bsl)(draw special-pen-square)]

@section[#:tag "racket_turtle_drawing_line_with_grid"]{Drawing a line in a grid}

First we draw a background grid using @racket[set-bg-grid]. We move to the origin using @racket[(go-to 0 0)]
and activate the stamper with a blue circle as the stamp. To get the stamps in the right coordinates we need to
command the turtle using @racket[go-to] multiple times. In this example the stamper is inactivated after four points .

@racketblock[
(define line-with-grid
  (list (set-bg-grid 20 20 "pink")
        (pen-up)
        (go-to 0 0)
        (stamper-on (circle 5 "solid" "blue"))
        (pen-down)
        (go-to 40 40)
        (go-to 80 80)
        (go-to 120 120)
        (go-to 160 160)
        (stamper-off)
        (go-to 500 500)))]

@interaction[#:eval (bsl)(draw line-with-grid)]

@section[#:tag "racket_turtle_multiple_stamps"]{Drawing a line with multiple stamps}

We move to origin using @racket[go-to-origin] command and draw a line using a list of stamps.

@racketblock[
(define STAMPS 
  (list (circle 10 "solid" "red")
        (star 10 "solid" "blue")
        (circle 10 "solid" "green")
        (star 10 "solid" "yellow")
        (circle 10 "solid" "black")))]

@racketblock[
 (define line-with-stamps
   (list (pen-up)
         (go-to-origin)
         (turn-right 45)
         (stamper-on STAMPS)
         (repeat 8 (forward 50))))]

@interaction[#:eval (bsl)(draw line-with-stamps)]

@section[#:tag "racket_turtle_square_over_bg_image"]{Changing background color, background image and animation size}

You can change the background color using @racket[change-bg-color] color and you can put an additional image on top of
it using @racket[set-bg-image]. In the example we want to draw a picture with different dimensions so
@racket[draw-custom] is used (setting the drawing speed to zero will not affect the drawing speed).

@racketblock[
(define square-over-bg
  (list (change-bg-color "black")
        (set-bg-image (circle 100 "solid" "gold"))
        square1))]

@interaction[#:eval (bsl)(draw-custom square-over-bg 400 250 0)]

@section[#:tag "racket_turtle_color_line"]{A line with changing colors}

In this example we set the pen color to be a list of colors. Turtle will use each color one after another. The
animation speed has been set to be slower (the last argument of @racket[draw-custom]). The turtle is also hidden during
the first part of the animation. 

@racketblock[
(define COLORS
  (list "red" "blue" "green" "yellow" "purple"))]

@racketblock[
(define color-line
  (list (pen-up)
        (go-to 0 0)
        (turn-right 45)
        (pen-down)
        (change-color COLORS)
        (change-pen-size 10)
        (hide-turtle)
        (repeat 8 (forward 40))
        (show-turtle)
        (repeat 8 (forward 40))))]

@interaction[#:eval (bsl)(draw-custom color-line 500 500 0.5)]