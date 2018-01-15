#include "TabType.h"
#include "File.h"
//------------------------------------------------------------
struct TabType
{
	File data;
};
//------------------------------------------------------------
TabType 	createTabType(){
	TabType t = (TabType) malloc(sizeof(struct TabType));
	t->data = createFile();
	//ajout des primitif
	addFile(t->data,createType(createFile(),createFile(),createText("int"),NULL,true));
	addFile(t->data,createType(createFile(),createFile(),createText("bool"),NULL,true));
	addFile(t->data,createType(createFile(),createFile(),createText("float"),NULL,true));
	return t;
}
//------------------------------------------------------------
void 		freeTabType(TabType* pSurTabType){
	Iterator i = getIteratorFile((*pSurTabType)->data);
	while(hasNextIterator(i)){
		Type t = (Type)nextDataIterator(i);
		freeType(&t);
	}
	freeIterator(&i);
	freeFile(&(*pSurTabType)->data);
	free(*pSurTabType);
	(*pSurTabType) = NULL;
}
//------------------------------------------------------------
void		addTypeInTabType(TabType t, Type i){
	addFile(t->data,i);
}
//------------------------------------------------------------
Type 		getTypeInTabType(TabType t, Text nom){
	Iterator i = getIteratorFile(t->data);
	Type res = NULL;
	while(res == NULL && hasNextIterator(i)){
		Type t = (Type)nextDataIterator(i);
		if(isMyNameType(t,nom)){
			res = t;
		}
	}
	return res;

}
//------------------------------------------------------------