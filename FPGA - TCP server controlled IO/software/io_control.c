// control of board I/O using AXI xgpio. 

#include "io_control.h"

#include "xgpio.h"
#include  <xgpio_l.h>
#include "xparameters.h"
#include <xstatus.h>
#include <sys/_intsup.h>
#include <xgpio_l.h>


// AXI GPIO initialization
int init_xgpio(XGpio *xgpio)
{
    int status = XGpio_Initialize(xgpio, XPAR_AXI_GPIO_0_BASEADDR);

    if (status != XST_SUCCESS)
    {
        xil_printf("Gpio init failed \n");
        return XST_FAILURE;
    }
    
    return 0;
}

void switch_leds(XGpio *led_driver){

    //XPAR_AXI_GPIO_0_GPIO_WIDTH

    XGpio_SetDataDirection(led_driver, 1, 0);
    
    u32 LEDS = XGpio_DiscreteRead(led_driver, 1);

    switch(LEDS) // cycle through r-g-b, on both leds;
    {
    case 0b000000: // initial case 
        XGpio_DiscreteWrite(led_driver,1, 0b000001);
        break;
    case 0b000001:
        XGpio_DiscreteWrite(led_driver,1, 0b000010);
        break;
    case 0b000010:
        XGpio_DiscreteWrite(led_driver,1, 0b000100);
        break;
    case 0b000100:
        XGpio_DiscreteWrite(led_driver,1, 0b001000);
        break;
    case 0b001000:
        XGpio_DiscreteWrite(led_driver,1, 0b010000);
        break;
    case 0b010000:
        XGpio_DiscreteWrite(led_driver,1, 0b100000);
        break;
    case 0b100000:
        XGpio_DiscreteWrite(led_driver,1, 0b000000);
        break;        
    }

}



