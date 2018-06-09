/**
 * A mode to set the color of the lamp.
 */
#ifndef ModeTest_h
#define ModeTest_h

#include "Mode.h"

class ModeTest : public Mode
{
    public:
        virtual void setLamp(WhiteLamp* lamp);
        virtual void loop(int delta);
};

#endif
