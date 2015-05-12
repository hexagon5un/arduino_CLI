
## This shell script does what the Arduino logfile does, and is just a PoC.
## You may need to specify paths for the AVR build commands like avr-gcc etc.
## You probably have them in your Arduino install under /hardware/tools/avr/bin/
##   and the same thing with the core code files directory. 
## This is intended more as a demo than a workable tool.
## The Makefile stands a better chance of working for you.

## Complete clean start: rebuild cpp file from ino
echo "#include \"Arduino.h\"" | cat > Blink.cpp
echo "void setup();" | cat >> Blink.cpp
echo "void loop();" | cat >> Blink.cpp
cat Blink.ino >> Blink.cpp


echo Copy all core code files over:
CORE='/usr/share/arduino/hardware/arduino/avr/cores/arduino'
VARIANT='/usr/share/arduino/hardware/arduino/avr/variants/standard'
cp ${CORE}/* .
cp ${VARIANT}/pins_arduino.h .

echo Compile core files:
date
for f in *.cpp 
do avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10604 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR  -I. $f -o $f.o
done

for f in *.c
do avr-gcc -c -g -Os -w -ffunction-sections -fdata-sections -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10604 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR  -I. $f -o $f.o
done

echo "Add all object files into core.a, creating library"
for f in *.o
	do avr-ar rcs core.a $f
done

echo Compile our code, link it in to the core library
avr-gcc -w -Os -Wl,--gc-sections -mmcu=atmega328p -o Blink.cpp.elf Blink.cpp.o core.a -L. -lm 

echo "Add in eeprom if needed (not for Blink)"
avr-objcopy -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 Blink.cpp.elf Blink.cpp.eep 

echo Convert elf to hex for avrdude
avr-objcopy -O ihex -R .eeprom Blink.cpp.elf Blink.cpp.hex 

echo Flash it
avrdude -qq -p atmega328p -c arduino -P /dev/ttyACM0 -b 115200 -D -U Blink.cpp.hex

echo Done


