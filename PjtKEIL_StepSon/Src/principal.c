

#include "DriverJeuLaser.h"
#include "GestionSon.h"
//extern void CallbackSon(void);
//extern void StartSon(void);



int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Apr?s ex?cution : le coeur CPU est clock? ? 72MHz ainsi que tous les timers
CLOCK_Configure();

//configuration du timer 3
PWM_Init_ff(TIM3,3,720);
GPIO_Configure(GPIOB,0,OUTPUT,ALT_PPULL);	
	
	
// configuration du Timer 4 en d?bordement 91micro seconde (periode du son)
Timer_1234_Init_ff(TIM4,6552);
Active_IT_Debordement_Timer(TIM4,2,CallbackSon);
	


	
	

//============================================================================	
	
	
while	(1)
	{
		//on fait une pause de 1 million pour attendre avant de remettre a 0 l'index
		for(int i=0;i<5000000;i++) {
		}
		StartSon();
	}
}

