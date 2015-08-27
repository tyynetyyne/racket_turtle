#lang scribble/manual

@(require scriblib/figure)
@(require 2htdp/image)
@(require teachpacks/racket-turtle)
@(require (for-label lang/htdp-beginner))
@(require (for-label (except-in 2htdp/image image?)))
@(require (for-label (only-in racket/contract and/c or/c any/c not/c listof
                                              >=/c <=/c)))
@(require (for-label teachpacks/racket-turtle))
@(require scribble/core
          scribble/html-properties)
@(require scribble/eval)
@(require scribble/pdf-render)

@declare-exporting[teachpacks/racket-turtle]

@title[#:tag "racket_turtle_commands" #:style 'toc]{Commands for Racket Turtle}

@(begin
   (require scribble/manual scribble/eval fin-doc/sl-eval)
   (define (bsl)
     (define *bsl
       (bsl+-eval
        (require 2htdp/image)
        (require teachpacks/racket-turtle)
        ))
     (set! bsl (lambda () *bsl))
     *bsl))

@defproc[(forward [x real?]) procedure]{

 Moves the turtle forward @racket[x] pixels, if given @racket[x] is positive,
 backwards it it's negative.}

@defproc[(turn-left [a real?]) procedure]{

 Turns the turtle heading to the left @racket[a] degrees, if given @racket[a] is positive.
 Negative @racket[a] will make the turtle to turn right @racket[(abs a)] degrees. 
}

@defproc[(turn-right [a real?]) procedure]{
                                          
 Turn the turtle heading to the right @racket[a] degrees, if given @racket[a] is positive.
 Negative @racket[a] will make the turtle to turn left @racket[(abs a)] degrees.   
}

@defproc[(repeat [k (and/c integer? positive?)][command-list (list-of procedure)]) procedure]{

 Makes the turtle to repeat @racket[k] times the commands given in the @racket[command-list].
                                                                            
}

@defproc[(pen-up) procedure]{
                             
 Lifts up the pen so the turtle will not draw a line when it moves. The default position is down.
 
}

@defproc[(pen-down) procedure]{

 Puts the pen down so that the turtle will draw a line as it moves.
}

@defproc[(go-to [x real?][y real?]) procedure]{

 Makes the turtle go to a given point (@racket[x], @racket[y]). The origin of the turtle image is in the low left
 corner unless it has been moved (see: @racket[set-origin]).            
}

@defproc[(go-to-origin) procedure]{

 Makes the turtle go to the origin of the animation window. The origin is in the low left corner unless it
 has been moved (see: @racket[set-origin]).             
 
}

@defproc*[([(change-color [color image-color?]) procedure]
           [(change-color [color-list (list-of image-color?)]) procedure])]{

 Changes the color of the pen (the default color is blue). The argument can be a single @racket[color] or a
 @racket[color-list], which contains one or more colors. Colors in the @racket[color-list] are used one by one
 and when the list is finished it starts from the beginning.
}

@defproc[(change-pen-size [width (and/c integer? (<= 0 255))]) procedure]{

 Sets the width of the pen. The @racket[width] is an interger between @racket[0] - @racket[255].
                                                                               
 @italic{Note!} WeScheme doesn't support this.
}

@defproc[(change-pen-style [style pen-style?]) procedure]{

 Changes the pen style. The @racket[style] can be one of these: @italic{"solid", "dot", "long-dash",
  "short-dash"} or @italic{"dot-dash"}.
               
@italic{Note!} WeScheme doesn't support this.

}

@defproc[(change-bg-color [color image-color?]) procedure]{

 Changes the background color (the default color is white). This command should be used first since it
 fills the whole image with the given color.
 
}

@defproc[(set-bg-image [img image?]) procedure]{

 Sets the given image @racket[img] as a background image. This command should be used before drawing the actual image,
 since @racket[img] is put on top of the existing turtle drawings.
                   
}

@defproc[(set-bg-grid [width (and/c integer? positive?)]
                      [height (and/c integer? positive?)]
                      [color image-color?]) procedure]{

 Draws a background grid with given cell @racket[width], @racket[height] and @racket[color]. This command
 should be used before drawing the actual turtle drawings.
}

@defproc[(set-origin) procedure]{
                                 
Stores the current position of the turtle as a new origin. The location of the origin is shown as a red dot during
the turtle animation.
 
}

@defproc*[([(stamper-on [stamp image?]) procedure]
           [(stamper-on [stamp-list (list-of image?)]) procedure])]{

 Activates the stamper. Stamper draws one @racket[stamp] in each new turtle location. If the argument is a list of
 images @racket[stamp-list] stamps are used one after another according to the list. After all stamp images have been
 used once, the list starts again from the beginning.

 The stamper doesn't affect the pen so if the pen is down, a line will be drawn in additions to the stamps.
}

@defproc[(stamper-off) procedure]{
                                  
 Removes the stamper. 
 
}

@defproc[(mirror-x-on) procedure]{
                                  
 Copies the turtle commands so that they are mirrored horizontally e.g. there will be a second
 mirrored image in addition to the original image. The position of the mirroring axis is set to be a vertical line,
 which y-coordinate is taken from the point in which @racket[mirror-x-on] was used. If @racket[mirror-y-on] is
 used in the same location, the mirroring will be done also vertically.
}

@defproc[(mirror-y-on) procedure]{
                                  
 Copies the turtle commands so that they are mirrored vertically e.g. there will be a second
 mirrored image in addition to the original image. The position of the mirroring axis is set to be a horizontal line,
 which x-coordinate is taken from the point in which @racket[mirror-y-on] was used. If @racket[mirror-x-on] is
 used in the same location, the mirroring will be done also horizontally.
}

@defproc[(mirror-x-off) procedure]{
                                   
 Removes horizontal mirroring. 
 
}

@defproc[(mirror-y-off) procedure]{
                                   
 Removes vertical mirroring.
 
}

@defproc[(clean-up) procedure]{
                               
 Cleans up the animation screen including the background image and grid but keeps the background color.
 Also the location and heading of the turtle are kept.
 
}

@defproc[(hide-turtle) procedure]{
                                  
 Hides the turtle sprite for the duration of the animation (turtle is visible as a default). Turtle sprite is a black
 triangle showing the location and current heading of the turtle.
 
}

@defproc[(show-turtle) procedure]{

 Shows turtle sprite again during the animation. Turtle sprite is a black
 triangle showing the location and current heading of the turtle.
 
}
