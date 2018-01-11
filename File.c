#include "File.h"

//---------------------------------------------------------
struct File
{
	Cellule debut;
	Cellule fin;
	unsigned int size;
};
//---------------------------------------------------------
File 	 createFile(){
	File p = (File) malloc (sizeof(struct File));
	p->size = 0;
	p->debut = NULL;
	p->fin = NULL;
	return p;
}
//------------------------------------------------------
void 	 freeFile(File* pSurFile){
	clearFile(*pSurFile);
	free (*pSurFile);
	(*pSurFile) = NULL;
}
//------------------------------------------------------
void 	 addFile(File p , void* data){	
	Cellule n = createCellule(data,NULL);
	if(isCell(p->debut)){//ajout à la fin
		insertAfterCellule(p->fin,n);
		p->fin = n;
	}
	else{//ajout au debut
		p->debut = n;
		p->fin = n;
	}
	p->size ++;
}
//------------------------------------------------------
void*	 getHeadFile(File p){
	return getDataCellule(p->debut);
}
//------------------------------------------------------
void	 removeHeadFile(File p){
	Cellule c = p->debut;
	p->debut = getNextCellule(c);
	free(c);
	p->size -- ;
}
//------------------------------------------------------
bool     emptyFile(File p){
	return !isCell(p->debut);
}
//------------------------------------------------------
Iterator getIteratorFile(File p){
	return createIterator(p->debut);
}
//------------------------------------------------------
void	 clearFile(File p){
	while(!emptyFile(p)){
		removeHeadFile(p);
	}
}
//------------------------------------------------------
unsigned int getSizeFile(File p){
	return p->size;
}
//------------------------------------------------------
File 	cloneFile(File p){
	File r = createFile();
	Iterator i = getIteratorFile(p);
	while(hasNextIterator(i)){
		addFile(r,nextDataIterator(i));
	}
	freeIterator(&i);
	return r;
}