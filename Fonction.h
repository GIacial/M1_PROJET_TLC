#ifndef INCLUDE_FONCTION_H
#define INCLUDE_FONCTION_H

#include <stdlib.h>
#include <stdbool.h>
#include "Text.h"
#include "File.h"

typedef struct Fonction * Fonction;

#include "Var.h"

Fonction 	createFonction(Text nom , File param, Type retour);
void		freeFonction(Fonction* pSurFonction);

bool		isMeFonction(Fonction f , Text nom , File param);


#endif