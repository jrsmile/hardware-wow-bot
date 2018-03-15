/*
   Keyboard test
   For the Arduino Leonardo, Micro or Due Reads
      a byte from the serial port, sends a keystroke back. 
   The sent keystroke is one higher than what's received, e.g. if you send a, you get b, send
      A you get B, and so forth.
   The circuit:
   * none
*/
#define HWSERIAL Serial1
#include "Keyboard.h"
unsigned long baud = 31250;

void setup() {
   // open the serial port:
   HWSERIAL.setTX(4); // set TX and RX to the ports ajacent to each other on the Teensy-LC.
   HWSERIAL.setRX(21);
   HWSERIAL.begin(baud);
   // initialize control over the keyboard:
   Keyboard.begin();
}

void loop() {
   // check for incoming serial data:
   if (HWSERIAL.available() > 0) {
      // read incoming serial data:
      char inChar = HWSERIAL.read();
      // Type the next ASCII value from what you received:
      if (inChar == 255) {
        Keyboard.releaseAll();
      } else {
       Keyboard.press(inChar); 
      }
   }
} 
