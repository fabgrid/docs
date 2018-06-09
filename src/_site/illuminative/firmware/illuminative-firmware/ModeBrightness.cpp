/**
 *
 */
#include "WhiteLamp.h"
#include "ModeBrightness.h"

#define DEBUG true


void ModeBrightness::setLamp(WhiteLamp * lamp)
{
    _lamp = lamp;

    if (DEBUG) {
        Serial.println("Setting up ModeBrightness");
    }
}

void ModeBrightness::loop(int delta)
{
    if (delta != 0)
    {
        // Update color
        _lamp->setBrightness(_lamp->getBrightness() + delta);
    }
}

