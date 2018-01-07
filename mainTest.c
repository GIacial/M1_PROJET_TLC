#include <stdio.h>
#include "Pile.h"


int main(){
	Pile p = createPile();
	int a = 5, b = 6 , c = 4 , d = 3;
	printf("Les nombres sont %d %d %d %d\n",a,b,c,d );
	printf("On empile tout\n" );
	addPile(p , &a);
	addPile(p , &b);
	addPile(p , &c);
	addPile(p , &d);
	printf("On parcours\n" );
	Iterator i = getIteratorPile(p);
	while(hasNextIterator(i)){
		int* t = (int*)nextDataIterator(i);
		printf("on a %d\n",*t );
	}
	freeIterator(&i);
	printf("On depile\n" );
	removeHeadPile(p);
	printf("On parcours\n" );
	i = getIteratorPile(p);
	while(hasNextIterator(i)){
		int* t = (int*)nextDataIterator(i);
		printf("on a %d\n",*t );
	}
	freeIterator(&i);
	printf("On ajoute %d\n",a );
	addPile(p,&a);
	printf("On parcours\n" );
	i = getIteratorPile(p);
	while(hasNextIterator(i)){
		int* t = (int*)nextDataIterator(i);
		printf("on a %d\n",*t );
	}
	freeIterator(&i);


	printf("On suppression\n" );
	freePile(&p);

	return 0;
}