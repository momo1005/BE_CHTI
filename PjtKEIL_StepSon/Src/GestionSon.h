#ifndef GESTIONSON_H
#define GESTIONSON_H

// Fonction permettant de mettre à l'echelle des echantillon de son avant de faire un pwm
extern void CallbackSon(void);

//Remet a 0 l'index de parcours des echantillons afin de commencer le son
extern void StartSon(void);

#endif /* GESTIONSON_H */
