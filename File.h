#ifndef INCLUDE_FILE_H
#define INCLUDE_FILE_H

#include <stdlib.h>
#include <stdbool.h>
#include "Iterator.h"

//type
struct File;
typedef struct File * File;

//fonction
File 	 createFile();						//permet de créé une file
void 	 freeFile(File* pSurFile);			//permet de free la file
void 	 addFile(File p , void* data);		//ajoute data à la file
void*	 getHeadFile(File p);				//la donné à la tete de la file
void	 removeHeadFile(File p);				//eneleve la tete
bool     emptyFile(File p);					//permet de savoir si la file est vide
Iterator getIteratorFile(File p);				//donne un iterator sur la file
void	 clearFile(File p);						//vide la file
unsigned int getSizeFile(File p);				//donne la taille de la file
File 	cloneFile(File p);						//copie la file

#endif //INCLUDE_FILE_H