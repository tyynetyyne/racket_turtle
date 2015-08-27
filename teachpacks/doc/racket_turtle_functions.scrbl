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

@title[#:tag "racket_turtle_functions"]{Drawing functions for Racket Turtle}


@defproc[(draw [command-list (list-of procedure)]) image?]{

Reads and executes the commands in @racket[command-list] and returns the created picture. Opens animation window and
shows the turtle in action.

}

@defproc[(draw-custom [command-list (list-of procedure)]
                      [width (and/c positive? real?)]
                      [height (and/c positive? real?)]
                      [speed (and/c positive? real?)]) image?]{

Set the animation window's size to @racket[width] and @racket[height] and the drawing speed to (@racket[speed].
If @racket[speed] is set to value @racket[0], default speed is used. The default size of the animation window
is @racket[500] x @racket[500] pixels.

}

@defproc[(draw-step-by-step [command-list (list-of procedure)]) image?]{

Like @racket[draw] but @racket[command-list] is processed step-by-step. Each step is performed after user has pressed
the spacebar. Notice that changing for example turtle's pen color is one step, so turle doesn't necessarity move each time.

}

@defproc[(draw-step-by-step-custom [command-list (list-of procedure)]
                                   [width (and/c positive? real?)]
                                   [height (and/c positive? real?)]
                                   [speed (and/c positive? real?)]) image?]{

Like @racket[draw-custom] but @racket[command-list] is processed step-by-step. Each step is performed after user has pressed
the spacebar. Notice that changing for example turtle's pen color is one step, so turle doesn't necessarity move each time.

}

@defproc[(draw-and-store [command-list (list-of procedure)]) image?]{

Like @racket[draw] but stores an @italic{animated gif} of the animation in a folder called @italic[@bold{turtle_animations}].
This folder has to be located in the same path as the @italic{.rkt} file. If this folder is missing, @italic{animated gif} file 
is not created. Notice that the creation of the file takes some time so don't close the animation window before the text
@italic{"Creating animated gif"} has disappeared and the final image is shown again.

@italic{Note!} WeScheme doesn't support this.

}

@defproc[(draw-and-store-custom [command-list (list-of procedure)]
                                [width (and/c positive? real?)]
                                [height (and/c positive? real?)]
                                [speed (and/c positive? real?)]) image?]{

Like @racket[draw-custom] but stores animation as an @italic{animated gif}-file.

@italic{Note!} WeScheme doesn't support this.
}






