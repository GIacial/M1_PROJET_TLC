#include <stdio.h>
#include "File.h"


int main(){
	File p = createFile();
	int a = 5, b = 6 , c = 4 , d = 3;
	printf("Les nombres sont %d %d %d %d\n",a,b,c,d );
	printf("On empile tout\n" );
	addFile(p , &a);
	addFile(p , &b);
	addFile(p , &c);
	addFile(p , &d);
	printf("On parcours\n" );
	Iterator i = getIteratorFile(p);
	while(hasNextIterator(i)){
		int* t = (int*)nextDataIterator(i);
		printf("on a %d\n",*t );
	}
	freeIterator(&i);
	printf("On depile\n" );
	removeHeadFile(p);
	printf("On parcours\n" );
	i = getIteratorFile(p);
	while(hasNextIterator(i)){
		int* t = (int*)nextDataIterator(i);
		printf("on a %d\n",*t );
	}
	freeIterator(&i);
	printf("On ajoute %d\n",a );
	addFile(p,&a);
	printf("On parcours\n" );
	i = getIteratorFile(p);
	while(hasNextIterator(i)){
		int* t = (int*)nextDataIterator(i);
		printf("on a %d\n",*t );
	}
	freeIterator(&i);


	printf("On suppression\n" );
	freeFile(&p);

	return 0;
}