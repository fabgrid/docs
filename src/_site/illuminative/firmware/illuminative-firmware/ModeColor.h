/**
 * A mode to set the color of the lamp.
 */
#ifndef ModeColor_h
#define ModeColor_h

#include "Mode.h"

class ModeColor : public Mode
{
    public:
        virtual void setLamp(WhiteLamp* lamp);
        virtual void loop(int delta);
};

#endif
