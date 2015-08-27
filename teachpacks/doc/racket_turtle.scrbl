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

@title[#:tag "racket_turtle" #:style 'toc]{Racket Turtle}

@defmodule[teachpacks/racket-turtle]

Racket Turtle - library provides a simple interface for drawing traditional turtle-graphics. Racket Turtle
has also a stamper functionality, so its images are not limited to line drawings.

Racket Turtle was designed to teach programming and geometrical concepts for middle school students
but it can also be used to teach more advanced programming concepts such as lists and recursion.  

Images drawn with Racket Turtle:

@image[#:scale 0.5 "racket_turtle1_img.png"]
@image[#:scale 0.5 "racket_turtle2_img.png"]
@image[#:scale 0.5 "racket_turtle3_img.png"]
@image[#:scale 0.5 "racket_turtle4_img.png"]
                                                                           
@local-table-of-contents[#:style 'unnumbered]

@include-section["racket_turtle_functionality.scrbl"]
@include-section["racket_turtle_commands.scrbl"]
@include-section["racket_turtle_functions.scrbl"]
@include-section["racket_turtle_examples.scrbl"]
@include-section["racket_turtle_examples_recursion.scrbl"]


