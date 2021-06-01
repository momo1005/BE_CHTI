	PRESERVE8
	THUMB   
		

	IMPORT LongueurSon
	IMPORT PeriodeSonMicroSec
	IMPORT Son
	include DriverJeuLaser.inc
; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite

SortieSon dcw 0
	EXPORT SortieSon

index dcd 0 ;index de tableau
	EXPORT index
		
auxmul dcd 719
auxdiv dcd 65535
		
;dcd = 32 bit //commence par l'octet de poids faible car little indian
;32 bit = 4 tiroire dans la memoire de 8bits
;dcw 16bit
;dcb 8 bits

	
; ===============================================================================================

		
;Section ROM code (read only) :		
	area    moncode,code,readonly

	EXPORT CallbackSon
	EXPORT StartSon
; écrire le code ici		

StartSon proc
	ldr R0,=index
	ldr R1,[R0]
	mov R1, #0
	str R1,[R0]
	endp

;void CallbackSon(void)
CallbackSon proc
;son = table d'échantillon
;A chaque entrée dans le callback, lire l'échantillon à traiter (echantillon courant)  
;puis mettre à jour un index de table

;on doit verifier que index < longueur son (max du tableau)
; si on a atteint le max on incremente plus index (on va toujours jouer le meme echantillon - fin du son car plus de vibration différente)
	push {lr,R4-R7}

	ldr R1,=Son ;adresse de son dans R1 ;
	ldr R2,=index ;adresse de index dans r2
	ldr R0,=SortieSon ; adresse de SortieSon dans R0

	ldr R4,[R2] ;valeur de index dans r4

	ldr R5,=LongueurSon ;adresse de Longeur Son dans R5
	ldr R5,[R5] ; Valeur de LongeurSon dans r5
	
	ldr R6,=auxmul
	ldr R6,[R6]
	ldr R7,=auxdiv
	ldr R7,[R7]

	cmp R4, R5 ; Z set to 1 when equal, 0 if not equal on compare la valeur de l'index avec la valeur de Longeur son
	beq FINSI ; on saute a sinon si on a fini de parcourir le tableau

ALORS
	ldrsh R3, [R1,R4,LSL #1] ; on met dans r3 la valeur de l'echantillon courant
	;ldrsh pour les nombre signé (s) et avoir juste 16 bits(h)
	
	add R3, #32768
	mul R3, R3, R6
	;on pourrait faire un RLS de 16 à la place
	sdiv R3,R3,R7

	add R4,#1 ; on indente la valeur de l'index
	str R4, [R2] ; on met en memoire la nouvelle valeur de l'index
	
	str R3, [R0] ; on met la valeur de l'echantillon dans sortie son
	mov R0, R3 ;car r0 = registre de base pour les parametres donc on lui donne la valeur de sortie son
	bl PWM_Set_Value_TIM3_Ch3
	
FINSI
	;on a fini de traiter les échantillons -> ne fait rien 
	pop {pc,R4-R7}

	endp	
	END



	