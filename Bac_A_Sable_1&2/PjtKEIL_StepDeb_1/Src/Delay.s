	PRESERVE8
	THUMB   
		

; ====================== zone de r�servation de donn�es,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly ;directives
		;dans cette partie la les constantes


;Section RAM (read write):
	area    maram,data,readwrite
		
VarTime	dcd 0 ;reserve une place en ram pour stocker des choses apr�s (une adresse ?)
	EXPORT VarTime ; permet d'exporter varTime afin de la voir dans la watch 1
;met en place des etiquettes
;crer un variable et varTime c'est l'adresse de cette variable 
;dcd = 32 bit //commence par l'octet de poids faible car little indian
;32 bit = 4 tiroire dans la memoire de 8bits
;dcw 16bit
;dcb 8 bits
	
; ===============================================================================================
	
;constantes (�quivalent du #define en C)
TimeValue	equ 900000


	EXPORT Delay_100ms ; la fonction Delay_100ms est rendue publique donc utilisable par d'autres modules.

		
;Section ROM code (read only) :		
	area    moncode,code,readonly
		


; REMARQUE IMPORTANTE 
; Cette mani�re de cr�er une temporisation n'est clairement pas la bonne mani�re de proc�der :
; - elle est peu pr�cise
; - la fonction prend tout le temps CPU pour... ne rien faire...
;
; Pour autant, la fonction montre :
; - les boucles en ASM
; - l'acc�s �cr/lec de variable en RAM
; - le m�canisme d'appel / retour sous programme
;
; et donc poss�de un int�r�t pour d�buter en ASM pur

Delay_100ms proc ;nom de fonction
	
		; VarTime=TimeValue
	    ldr r0,=VarTime  ;R0=vatime		  
		ldr r1,=TimeValue ;R1=900000
		str r1,[r0] ;Vartime = 900000
		
BoucleTempo	
		;VarTime--
		ldr r1,[r0] ;r1=vartime=900000				
		subs r1,#1 ;r1-1 // s met a jour les flags !!!!!
		str  r1,[r0]; vartime = valeur de r1 (decrementer) 
		
		;retour � BoucleTempo si VarTime not 0
		bne	 BoucleTempo ; bne = branche not equals ?? - retourne la ou y a le label pour boucler ?
			
		bx lr ;sort de la procedure - dans lr endroit ou on doit retourner apr�s
		endp
		
		
	END	