	PRESERVE8
	THUMB   
		
	;include DriverJeuLaser.inc ON N ECRIT PAS CA - Baguette magique
	IMPORT GPIOB_Set
	IMPORT GPIOB_Clear
		

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		
		;char FlagCligno;
FlagCligno dcb 0
	EXPORT FlagCligno
		

	
; ===============================================================================================
	
	EXPORT timer_callback ;

		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici		


;code en C
;char FlagCligno;

	
;void timer_callback(void)
;{
	;if (FlagCligno==1)
	;{
		;FlagCligno=0;
		;GPIOB_Set(1);
	;}
	;else
	;{
		;FlagCligno=1;
		;GPIOB_Clear(1);
	;}


;void timer_callback(void)
timer_callback proc ;nom de fonction
;{
	push{lr} ; IMPORTANT CAR LES GPIOB VONT MODIFIER LR
	
	;if (FlagCligno==1)
	;met les vleurs dont j'ai besoin dans les registre
	ldr R1,=FlagCligno ;adresse de flagcligno dans R1 ; adresse de 32 bit
	ldrb R2, [R1] ;valeur de flag cligno dans r2
	cmp R2, #1 ; Z set to 1 when equal, 0 if not equal
	bne SINON ; on saute a sinon si lagcligno different de 1

	;{
ALORS
		;FlagCligno=0;
		mov R2, #0
		strb R2, [R1] ; on met 0 dans flagcligno 
		;GPIOB_Set(1);
		;appel de procedure
		mov R0, #1 ; car r0 va etre le registre ou on va chercher les parametre pour bpiob set
		bl GPIOB_Set; <- permet d'appeler GPIONB_SET
		b FINSI;


	;}
	;else
	;{
SINON
		;FlagCligno=1;
		mov R2, #1
		strb R2, [R1] ; on met 0 dans flagcligno
		;GPIOB_Clear(1);
		mov R0, #1 ; car r0 va etre le registre ou on va chercher les parametre pour bpiob set
		bl GPIOB_Clear; <- permet d'appeler GPIONB_SET
	;}

FINSI
	pop {lr} ; On remet dans lr la valeur qu'on avait stocker dans la pile au debut
	bx lr ;sort de la procedure - dans lr endroit ou on doit retourner après
	; les deux precedente lignes sosnt équivalente a un push {pc}
	
	endp
		
	END