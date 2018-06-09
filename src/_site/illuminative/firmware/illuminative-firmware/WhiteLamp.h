/**
 * WhiteLamp - library for a two-color Lamp.
 *
 * Author: Joseph Paul <mail@jsph.pl>
 * License: Public Domain
 */
#ifndef WhiteLamp_h
#define WhiteLamp_h

#include "Arduino.h"

#define MIN_BRIGHTNESS      0
#define MAX_BRIGHTNESS      160
#define MIN_COLOR           0
#define MAX_COLOR           100

class WhiteLamp
{
    public:
        WhiteLamp();
        void setup();
        int getColor();
        int getBrightness();
        void setColor(int color);
        void setBrightness(int brightness);

    private:
        void _update();
        void _initPWM();
        int _linearize(int level);
        int _color = MAX_COLOR/2;  // Value indiciating color temperature
        int _brightness = MAX_BRIGHTNESS;  // Value from 0 (off) to 100 (max brightness)
        const int _pin_cold;  // Pin on which to do the PWM for the cold channel
        const int _pin_warm;  // Pin on which to do the PWM for the warm channel
        const int _n_steps = 160;
};

#endif
