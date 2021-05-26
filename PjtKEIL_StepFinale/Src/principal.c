#include "DriverJeuLaser.h"
//extern int DFT_ModuleAuCarre(short int Signal64ech [], char k); 
#include "DFT.h" 

extern short int LeSignal[];

int test[64];
short int dma_buf[64];

void callback_systick(void) {
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	//a modifier pour faire que pour les 4 pistolets
	for(int k=0;k<64;k++) {
		test[k]=DFT_ModuleAuCarre(dma_buf,k);
	}
	//calcul de score !

}	

int tab_scores[6]; //le tableau des scores pour les différentes valeurs de fréquences des pistolets 


//int * calcul_score () {
	//la cible doit défiler de manière cyclique
	//dès qu'i1 joueur touche la cible, il marque un point 
	
	//verifier si test[k] pour k correspond au pistolet > seuil
	//si oui +1
	
	//seuil =0,08 (un peu de marge vis a vis de la valeur théorique 94)
	//pour 60 mVpp en entrée
	
	//return tab_scores; 
//}


int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Après exécution : le coeur CPU est clocké à 72MHz ainsi que tous les timers
CLOCK_Configure();
	
Systick_Period_ff( 360000 );
Systick_Prio_IT(0, callback_systick);

SysTick_On ;
SysTick_Enable_IT ;
	
Init_TimingADC_ActiveADC_ff( ADC1,72 );
Single_Channel_ADC( ADC1, 2 );
Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
Init_ADC1_DMA1( 0, dma_buf );


//============================================================================	

	


 while	(1)
	{
	}
}

