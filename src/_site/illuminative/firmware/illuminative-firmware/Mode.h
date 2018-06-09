/**
 * Abstract for the different modes of the lamp.
 */
#ifndef Mode_h
#define Mode_h


class Mode
{
    public:
        virtual void setLamp(WhiteLamp* lamp) {WhiteLamp * _lamp = lamp;}
        virtual void loop(int delta) = 0;
    protected:
        WhiteLamp* _lamp;
};

#endif
