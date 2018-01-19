#ifndef INCLUDE_FONCTION_H
#define INCLUDE_FONCTION_H

#include <stdlib.h>
#include <stdbool.h>
#include "Text.h"
#include "File.h"

typedef struct Fonction * Fonction;

#include "Var.h"

Fonction 	createFonction(Text nom , File param, Type retour);		//cree la fonction
void		freeFonction(Fonction* pSurFonction);					//free la fonction

bool		isMeFonction(Fonction f , Text nom , File param );		//permet de savoir si c'est la meme fonction
Type 		getRTypeFonction(Fonction f);										//le type de retour
Var		exec(Fonction f,File param,Var v);										//execute le corps

#endif