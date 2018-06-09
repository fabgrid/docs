/**
 *
 */
#include "WhiteLamp.h"
#include "ModeTest.h"


void ModeTest::setLamp(WhiteLamp * lamp)
{
    Serial.println("Setting up ModeTest");
    _lamp = lamp;
}

void ModeTest::loop(int delta)
{
	long now = millis();
    long brightness = (now / 10) % 64;
    _lamp->setBrightness(brightness);
    _lamp->setColor(_lamp->getColor() + delta);
}
