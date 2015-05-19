Notes on my experiments with creating a Makefile to replicate the Arduino build chain (as of 1.6.4).  Works for me.  :)

I started down this path because I wanted to understand the Arduino build chain, not because I wanted a working full-service Makefile for Aduino.  That is to say, there's a complexity/readability tradeoff here, and this Makefile is heavy on the quick, dirty, and minimal side.  If you want something more full-service, (https://github.com/sudar/Arduino-Makefile).

Basically, all I did was to set up verbose logging in the Arduino IDE, copy the log files over, figure out what it was doing, and mimic it.  

The bash script `makefile_shell_version.sh` does just that, and is probably most readable if you're interested in what it took.  OTOH, the `Makefile` should be easier/quicker to make work on your system with less editing.


## Summary 

The Arduino IDE compiles everything in the core (`.c` and `.cpp` files) and throws them all into a big library function, `core.a`.

Your code (or the `Blink.ino` stand-in here) is then converted into a compilable `.cpp` file, compiled, and linked against the `core.a` library.  

To flash this into the Arduino, it's converted to an Intel hex file and passed off to AVRDUDE.


## .ino to .cpp

The only part of this process that wasn't visible in the log file is the conversion from `.ino` to `.cpp`, so I just compared `Blink.ino` with `Blink.cpp`.  The differences are straightforward.  The IDE seems to do the following:

1. add `include "Arduino.h"`
2. add prototype declarations for each function in the .ino file, in this case `setup()` and `loop()`  
3. delete all the comments.  I don't do this.  Why would you?

## Try it!

This is all a rough draft, but if it works (or doesn't) for you, let me know.  

## Context

This came out of a talk I gave ("Doing Arduino without the Arduino").  Slides attached as PDF.  You kinda had to be there, though.

