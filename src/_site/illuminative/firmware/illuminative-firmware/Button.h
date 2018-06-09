/**
 * Button - read a pin and detect differen press events
 *
 * Author: Joseph Paul <mail@jsph.pl>
 * License: Public Domain
 */
#ifndef Button_h
#define Button_h

#include "Arduino.h"

class Button
{
    public:
        Button(int pin);
        byte check();
        const static byte PUSH_SINGLE = 1;
        const static byte PUSH_LONG = 2;

    private:
        int _interval;  // msecs to wait between reads
        int _pin;  // Pin to which the button is connected
        int _last_check; //
        long _went_high = -1;
        bool _state = false;
        bool _push_single = false;
};

#endif
