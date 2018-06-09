/**
 *
 */

#include "Arduino.h"
#include "Button.h"

Button::Button(int pin)
{
    _pin = pin;
    _interval = 10;
    pinMode(pin, INPUT);
}

/**
 * Should be called from within loop().
 */
byte Button::check()
{
    long now = millis();
    if (now - _last_check >= _interval) {
        _last_check = now;
        bool reading = digitalRead(_pin);
        if ((!_state) && reading) {
            _went_high = now;
        }
        _state = reading;
    }
    if (_state) {
        return false;
    }
    else {
        int time_high = millis() - _went_high;
        int signal = 0;

        if (time_high > 10 && time_high < 300) {
            signal = PUSH_SINGLE;
        }
        else if (time_high > 300 && time_high < 2000) {
            signal = PUSH_LONG;
        }

        _went_high = -1;
        return signal;
    }
}
