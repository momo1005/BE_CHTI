#include "DriverJeuLaser.h"
//extern int DFT_ModuleAuCarre(short int Signal64ech [], char k); 
#include "DFT.h" 
#include "GestionSon.h"


extern short int LeSignal[];

int test[4];
short int dma_buf[64];
int tab_score[4];//le tableau des scores pour les différentes valeurs de fréquences des pistolets 
int tab_semaphore[4];

void callback_systick(void) {
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	
	//verifier si test[k] pour k correspond au pistolet > seuil
	//si oui +1
	//Seuil 60 mVpp -> 0,08 -> en decimal de 5.27 = 10737418
	// en hexa 5.27 = 0xa3d70a
	int seuil = 335544;
	
	//on prend 85,90,95,100k pour les pistolets
	for(int k=17;k<21;k++) {
		test[k-17]=DFT_ModuleAuCarre(dma_buf,k);
	}
	
	for(int k=17;k<21;k++) {
			//Calcul des scores
		//la cible doit défiler de manière cyclique
		//dès qu'i1 joueur touche la cible, il marque un point
		
		//Si on depasse le seuil = pistolet a tirer
		if (test[k-17]>seuil) {
			
			//si semaphore a 0 cela signifie que avant on ne tirait pas
			if (tab_semaphore[k-17]==0) {
				//on peut donc incrementer
				tab_score[k-17]+=1;
				StartSon();
				
			} //sinon le pistolet tirait deja avant donc on incremente pas
			
			//on indique que le pistolet était en train de tirer
			tab_semaphore[k-17]=1;
			
		} else {
			//on a pas depasser le seuil donc on tirait pas. 
			tab_semaphore[k-17]=0;
		}
	}
	
}	


int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Après exécution : le coeur CPU est clocké à 72MHz ainsi que tous les timers
CLOCK_Configure();
	
	//SON
	
	//configuration du timer 3
PWM_Init_ff(TIM3,3,720);
GPIO_Configure(GPIOB,0,OUTPUT,ALT_PPULL);	
	
// configuration du Timer 4 en débordement 91micro seconde (periode du son)
Timer_1234_Init_ff(TIM4,6552);
Active_IT_Debordement_Timer(TIM4,2,CallbackSon);
	
Systick_Period_ff( 360000 );
Systick_Prio_IT(0, callback_systick);

SysTick_On ;
SysTick_Enable_IT ;
	
Init_TimingADC_ActiveADC_ff( ADC1,72 );
Single_Channel_ADC( ADC1, 2 );
Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
Init_ADC1_DMA1( 0, dma_buf );


//============================================================================	
for (int i=0;i>4;i++) {
	tab_semaphore[i]=0;
}

for (int i=0;i>4;i++) {
	tab_score[i]=0;
}





 while	(1)
	{
		
	}
}

