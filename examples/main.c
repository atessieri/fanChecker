#include <stdio.h>		//printf()
#include <stdlib.h>		//exit()
#include <signal.h>     //signal()
#include <unistd.h>

#include "DEV_Config.h"
#include "OLED_Driver.h"
#include "OLED_GUI.h"
#include <time.h>
#include "CPU.h"
void  Handler(int signo)
{
    //System Exit
    printf("\r\nHandler:exit\r\n");
    
    FAN_OFF;
    
    DEV_ModuleExit();
    exit(0);
}

char temp[20];
uint32_t temp_m;


int main(void)
{
    char hostname[50];
    char *hostnamePointer;

    // Exception handling:ctrl + c
    signal(SIGINT, Handler);
    DEV_ModuleInit();
    
    OLED_Init();
    GUI_Init(OLED_WIDTH, OLED_HEIGHT);
    GUI_Clear();
    
    FAN_ON;
    DEV_Delay_ms(20);
    FAN_OFF;
    
    while(1){
    temp_m = Get_CPU_Temperature(temp);//Get temperature
    gethostname(hostname, sizeof(hostname)-1);
    hostnamePointer = strtok(hostname, ".");
    if (hostnamePointer == NULL)
    {
        hostname[0] = '\0';
    } 

    POE_HAT_Display(hostname, temp_m, 55);
    
    DEV_Delay_ms(1000);
    }
	//System Exit
	DEV_ModuleExit();
	return 0;
	
}

