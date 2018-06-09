/**
* Firmware for the IllumiNative color temperature adjustable lamps.
*
* Version: 0.0.2
* Author: Joseph Paul <joseph@sehrgute.software>
* License: Public Domain
*/

#include <Encoder.h>
#include <SoftwareSerial.h>

#include "Button.h"
#include "WhiteLamp.h"
#include "ModeColor.h"
#include "ModeBrightness.h"
#include "ModeTest.h"


#define VERSION         "0.0.2"
#define DEBUG           true

// Pin mappings
#define ENCODER_DOWN    3
#define ENCODER_UP      4
#define CENTER_BUTTON   8
#define BT_TX           12
#define BT_RX           13

// Resources
WhiteLamp lamp;
Encoder encoder(ENCODER_DOWN, ENCODER_UP);
Button centerButton(CENTER_BUTTON);
SoftwareSerial bluetooth(BT_RX, BT_TX);

// Modes
ModeColor modeColor;
ModeBrightness modeBrightness;
//ModeTest modeTest;

Mode *const modes[2] = {
    &modeColor,
    &modeBrightness
};

// Program Variables
const byte n_modes = 2;
byte current_mode = 0;
long encoder_pos = 0;
String btBuffer = "";


void setup()
{
    // Initialize Lamp
    lamp.setup();

    // Initialize Bluetooth
    bluetooth.begin(9600);

    if (DEBUG) {
        Serial.begin(115200);
        Serial.print("IllumiNative v.");
        Serial.println(VERSION);
        Serial.println("DEBUGGING ENABLED\n");
    }

    // Setup Modes
    for (int i = 0; i < n_modes; ++i)
    {
        modes[i]->setLamp(&lamp);
    }


}

void loop()
{
    // Read encoder
    long new_pos = encoder.read()/4;
    int delta = new_pos - encoder_pos;
    encoder_pos = new_pos;
    // if (abs(delta) >= 4) {
    //     delta /= 4;  // otherwise goes
    // }
    // else {
    //     delta = 0;
    // }


    // Hand off to the currently selected mode's loop
    currentMode()->loop(delta);

    // Read Button
    byte signal = centerButton.check();
    if (signal) {
        switch (signal) {
            case Button::PUSH_SINGLE:
                nextMode();
                if (DEBUG) {
                    Serial.print("Switched to mode ");
                    Serial.println(String(current_mode));
                }
                break;
        }

        if (DEBUG) {
            Serial.print("Button event: ");
            Serial.println(signal);
        }
    }

    // Check Bluetooth
    if (bluetooth.available()) {
        btBuffer = bluetooth.readString();
        String btValue = btBuffer.substring(3);
        int btValueInt = btValue.toInt();

        if (btBuffer.startsWith("bc")) {
            // Brightness change
            lamp.setBrightness(btValueInt);
            if (DEBUG) {
                Serial.print("Brightness change: ");
                Serial.println(btValueInt);
            }
        }
        else if (btBuffer.startsWith("cc")) {
            // Color change
            lamp.setColor(btValueInt);
            if (DEBUG) {
                Serial.print("Color change: ");
                Serial.println(btValueInt);
            }
        }
    }

    // DEBUG
    if (DEBUG && (delta != 0)) {
        Serial.print("Encoder movement: ");
        Serial.print(String(delta));

        Serial.print(" (");
        Serial.print(String(encoder_pos));
        Serial.println(")");
    }
}

/**
 * Get back the mode we're currently in.
 */
Mode * currentMode()
{
    return modes[current_mode];
}

/**
 * Switch to the next mode.
 */
void nextMode()
{
    current_mode += 1;
    if (current_mode >= n_modes) {
        current_mode = 0;
    }
}
