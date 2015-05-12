Notes on my experiments with creating a Makefile to replicate the Arduino build chain (as of 1.6.4).  Works for me.  :)

Basically, what I did was to set up verbose logging in the Arduino IDE, copy the log files over, figure out what it was doing, and mimic it.


== Summary 

The IDE compiles everything in the core (.c and .cpp files) and throws them all into a big library function, core.a.

Your code (or the Blink.ino stand-in here) is then converted into a compilable .cpp file, compiled, and linked against the core.a library.  

To flash this into the Arduino, it's converted to an Intel Hex file and passed off to AVRDUDE.


== .ino to .cpp

The only bit that isn't straight out of the log file is the conversion from .ino to .cpp.  This, I got from comparing the two files as the IDE processes them.  The IDE seems to do the following:

a) add include "Arduino.h" 
b) add prototype declarations for each function in the .ino file, in this case setup() and loop()
c) delete all the comments.  I don't do this.  Why would you?


This is all a rough draft, but if it works (or doesn't) for you, let me know.  

