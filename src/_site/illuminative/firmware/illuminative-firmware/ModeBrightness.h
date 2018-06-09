/**
 * A mode to set the brightness of the lamp.
 */
#ifndef ModeBrightness_h
#define ModeBrightness_h

#include "Mode.h"

class ModeBrightness : public Mode
{
    public:
        virtual void setLamp(WhiteLamp* lamp);
        virtual void loop(int delta);
};

#endif
