#ifndef INCLUDE_TABTYPE_H
#define INCLUDE_TABTYPE_H


#include <stdlib.h>
#include <stdbool.h>

typedef struct TabType* TabType;

#include "Type.h"

TabType 	createTabType();						//cretate (avec type primitif)
void 		freeTabType(TabType* pSurTabType);		//delete

void		addTypeInTabType(TabType t, Type i);	//ajoute un type
Type 		getTypeInTabType(TabType t, Text nom);	//lit un type (null si not find)
Type 		getTypeInTabTypeWithChar(TabType t, const char* nom); 

#endif //INCLUDE_TABTYPE_H