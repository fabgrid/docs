#include "WhiteLamp.h"

#define DEBUG true

const int steps_lookup[160] PROGMEM = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 34, 35, 37, 38, 40, 42, 44, 46, 48, 50, 52, 54, 57, 59, 62, 64, 67, 70, 73, 76, 80, 83, 87, 91, 95, 99, 103, 108, 113, 118, 123, 128, 134, 140, 146, 153, 159, 166, 174, 181, 189, 198, 206, 216, 225, 235, 245, 256, 268, 279, 292, 305, 318, 332, 347, 362, 378, 395, 413, 431, 450, 470, 491, 512, 535, 559, 583, 609, 636, 664, 694, 724, 756, 790, 825, 861, 900, 939, 981, 1024, 1070, 1117, 1166, 1218, 1272, 1328, 1387, 1448, 1513, 1580, 1649, 1722, 1799, 1878, 1961, 2048, 2139, 2234, 2333, 2436, 2544, 2656, 2774, 2897, 3025, 3159, 3299, 3445, 3597, 3756, 3923, 4096, 4278, 4467, 4665, 4871, 5087, 5312, 5547, 5793, 6049, 6317, 6597, 6889, 7194, 7512, 7845, 8191};

WhiteLamp::WhiteLamp()
{
    //
}

/**
 * Do the pin and PWM setup. This function should be called from within setup().
 */
void WhiteLamp::setup()
{
    _initPWM();
    _update();
}

/**
 * Return the currently set color;
 *
 * @return integer
 */
int WhiteLamp::getColor()
{
    return _color;
}

/**
 * Return the currently set brightness;
 *
 * @return integer
 */
int WhiteLamp::getBrightness()
{
    return _brightness;
}

/**
 * Update the color of the lamp.
 *
 * @param color integer between -32 (cold) and 31 (warm)
 */
void WhiteLamp::setColor(int color)
{
    _color = max(min(color, MAX_COLOR), MIN_COLOR);
    _update();

    if (DEBUG) {
        Serial.print("WhiteLamp::setColor(): ");
        Serial.println(_color);
    }
}

/**
 * Update the brightness of the lamp.
 *
 * @param brightness integer between 0 (off) and 63 (fully on)
 */
void WhiteLamp::setBrightness(int brightness)
{
    _brightness = max(min(brightness, MAX_BRIGHTNESS), MIN_BRIGHTNESS);
    _update();

    if (DEBUG) {
        Serial.print("WhiteLamp::setBrightness(): ");
        Serial.println(_brightness);
    }
}

/**
 * Update the PWM outputs to represent the currently
 * set parameters (color & brightness).
 */
void WhiteLamp::_update()
{
    float target = _brightness;  // total power we want to output
    float warm_share = ((1.0*_color - MIN_COLOR) / (MAX_COLOR - MIN_COLOR));
    float cold_share = 1 - warm_share;
    int warm_value = _linearize(round(warm_share * target));
    int cold_value = _linearize(round(cold_share * target));

    OCR1B = warm_value;
    OCR1A = cold_value;

    if (DEBUG) {
        Serial.print("WhiteLamp::update(): target=");
        Serial.print(target);
        Serial.print(", cold_share=");
        Serial.print(cold_share);
        Serial.print(", warm_share=");
        Serial.print(warm_share);
        Serial.print(", warm_value=");
        Serial.print(warm_value);
        Serial.print(", cold_value=");
        Serial.println(cold_value);
    }
}

/**
 * Return a PWM duty cycle for a brightness level.
 *
 * @param level integer between 0 and `_n_steps`
 */
int WhiteLamp::_linearize(int level)
{
    level = max(min(level, _n_steps-1), 0);
    return pgm_read_word(&steps_lookup[level]);
}

/**
 * Setup the timers for desired PWM resolution/frequency.
 */
void WhiteLamp::_initPWM()
{
    OCR1A = 0;
    OCR1B = 0;

    // Set PB1 and PB2 to output
    DDRB = 0x06;

    // Waveform generator: Fast PWM, TOP from ICR1
    // Compare mode: clear on match, set at bottom
    // Prescaler: /1
    ICR1 = 8191;
    TCCR1A = 0xa2;
    TCCR1B = 0x19;
}
