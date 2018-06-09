/**
 *
 */
#include "WhiteLamp.h"
#include "ModeColor.h"

#define DEBUG true


void ModeColor::setLamp(WhiteLamp * lamp)
{
    _lamp = lamp;

    if (DEBUG) {
        Serial.println("Setting up ModeColor");
    }
}

void ModeColor::loop(int delta)
{
    if (delta != 0)
    {
        // Update color
        _lamp->setColor(_lamp->getColor() + delta);
    }
}
