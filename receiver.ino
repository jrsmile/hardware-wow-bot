/*

*/
#define HWSERIAL Serial1
#include "Keyboard.h"
unsigned long baud = 31250;
String inputString = "";         // a String to hold incoming data
boolean stringComplete = false;  // whether the string is complete

void setup() {
   // open the serial port:
   HWSERIAL.setTX(4); // set TX and RX to the ports ajacent to each other on the Teensy-LC.
   HWSERIAL.setRX(21);
   HWSERIAL.begin(baud);
   // initialize control over the keyboard:
   Keyboard.begin();
   Mouse.screenSize(3840, 2160);  // configure screen size (4k ex.)
   inputString.reserve(200); // reserve 200 bytes for the inputString:
}

void loop() {
   serialEvent();
  if (stringComplete) {
   String str = inputString;
    if (str == "KEY_A") {
      Keyboard.press('a');
    } else if (str == "KEY_B") {
      Keyboard.press('b');
    } else if (str == "KEY_C") {
      Keyboard.press('c');
    } else if (str == "KEY_D") {
      Keyboard.press('D');
    } else if (str == "KEY_E") {
      Keyboard.press('e');
    } else if (str == "KEY_F") {
      Keyboard.press('f');
    } else if (str == "KEY_G") {
      Keyboard.press('g');
    } else if (str == "KEY_H") {
      Keyboard.press('h');
    } else if (str == "KEY_I") {
      Keyboard.press('i');
    } else if (str == "KEY_J") {
      Keyboard.press('j');
    } else if (str == "KEY_K") {
      Keyboard.press('k');
    } else if (str == "KEY_L") {
      Keyboard.press('l');
    } else if (str == "KEY_M") {
      Keyboard.press('m');
    } else if (str == "KEY_N") {
      Keyboard.press('n');
    } else if (str == "KEY_O") {
      Keyboard.press('o');
    } else if (str == "KEY_P") {
      Keyboard.press('p');
    } else if (str == "KEY_Q") {
      Keyboard.press('q');
    } else if (str == "KEY_R") {
      Keyboard.press('r');
    } else if (str == "KEY_S") {
      Keyboard.press('s');
    } else if (str == "KEY_T") {
      Keyboard.press('t');
    } else if (str == "KEY_U") {
      Keyboard.press('u');
    } else if (str == "KEY_V") {
      Keyboard.press('v');
    } else if (str == "KEY_W") {
      Keyboard.press('w');
    } else if (str == "KEY_X") {
      Keyboard.press('x');
    } else if (str == "KEY_Y") {
      Keyboard.press('y');
    } else if (str == "KEY_Z") {
      Keyboard.press('z');
    } else if (str == "KEY_1") {
      Keyboard.press('1');
    } else if (str == "KEY_2") {
      Keyboard.press('2');
    } else if (str == "KEY_3") {
      Keyboard.press('3');
    } else if (str == "KEY_4") {
      Keyboard.press('4');
    } else if (str == "KEY_5") {
      Keyboard.press('5');
    } else if (str == "KEY_6") {
      Keyboard.press('6');
    } else if (str == "KEY_7") {
      Keyboard.press('7');
    } else if (str == "KEY_8") {
      Keyboard.press('8');
    } else if (str == "KEY_9") {
      Keyboard.press('9');
    } else if (str == "KEY_0") {
      Keyboard.press('0');
    } else if (str == "KEY_ß") {
      Keyboard.press('ß');
    } else if (str == "KEY_adg") {
      Keyboard.press('´');
    } else if (str == "KEY_LEFT_CTRL") {
      Keyboard.press(KEY_LEFT_CTRL);
    } else if (str == "KEY_LEFT_SHIFT") {
      Keyboard.press(KEY_LEFT_SHIFT);
    } else if (str == "KEY_LEFT_ALT") {
      Keyboard.press(KEY_LEFT_ALT);
    } else if (str == "KEY_LEFT_GUI") {
      Keyboard.press(KEY_LEFT_GUI);
    } else if (str == "KEY_RIGHT_CTRL") {
      Keyboard.press(KEY_RIGHT_CTRL);
    } else if (str == "KEY_RIGHT_SHIFT") {
      Keyboard.press(KEY_RIGHT_SHIFT);
    } else if (str == "KEY_RIGHT_ALT") {
      Keyboard.press(KEY_RIGHT_ALT);
    } else if (str == "KEY_RIGHT_GUI") {
      Keyboard.press(KEY_RIGHT_GUI);
    } else if (str == "KEY_UP_ARROW") {
      Keyboard.press(KEY_UP_ARROW);
    } else if (str == "KEY_DOWN_ARROW") {
      Keyboard.press(KEY_DOWN_ARROW);
    } else if (str == "KEY_LEFT_ARROW") {
      Keyboard.press(KEY_LEFT_ARROW);
    } else if (str == "KEY_RIGHT_ARROW") {
      Keyboard.press(KEY_RIGHT_ARROW);
    } else if (str == "KEY_TAB") {
      Keyboard.press(KEY_TAB);
    } else if (str == "KEY_RETURN") {
      Keyboard.press(KEY_RETURN);
    } else if (str == "KEY_ESC") {
      Keyboard.press(KEY_ESC);
    } else if (str == "KEY_RELEASE_ALL") {
      Keyboard.releaseAll();
    } else if (str == "MOUSE_CLICK_LEFT") {
      Mouse.press(MOUSE_LEFT);
    } else if (str == "MOUSE_CLICK_RIGHT") {
      Mouse.press(MOUSE_RIGHT);
    } else {
      Keyboard.releaseAll();
    }
    // clear the string:
    inputString = "";
    stringComplete = false;
  }
}

void serialEvent() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    inputString += inChar;
    if (inChar == '\n') {
      stringComplete = true;
    }
  }
}
