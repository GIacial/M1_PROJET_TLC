#ifndef INCLUDE_TYPE_H
#define INCLUDE_TYPE_H

#include <stdlib.h>
#include <stdbool.h>
#include "File.h"
#include "Text.h"

typedef struct Type * Type;

#include "Fonction.h"
#include "Var.h"
#include "N_Uplet.h"

Type 		createType(File varia , File func , Text name , Type mere , bool primitif);								//cree le type (il va free vos truc avec son free)
void 		freeType(Type* pSurType);							//free le type

bool		isMyNameType(Type t , Text name);					//dit si c'est le nom du type
bool		isMyNameTypeWithChar(Type t , const char* name);
Var         createVarWithType(Type t,Text nomVar);				//cree une var avec ce type
bool		isPrimitifType(Type t);									//permet de savoir si c'est un type primitif

N_Uplet 		appFonctionType(Type t, Text nom ,File param,Var val);			//app une fonction
bool		isMyFonctionType(Type t,Text nom ,File param );					//verif que c'est bien une fonction du type
bool		isMyParentType(Type t , Type p);						//regarde si t herite de p

#endif