#ifndef __IO_CONTROL.H
#define __IO_CONTROL.H

#include "xgpio.h"

int init_xgpio(XGpio *xgpio);
void switch_leds(XGpio *led_driver);

#endif