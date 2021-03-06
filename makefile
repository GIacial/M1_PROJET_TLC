CFLAG= -D_XOPEN_SOURCE -Wall -Wextra -pedantic -Wconversion -pthread

#compile + lance
brun:compil
	@echo Lancement de l executable bison
	@./bison.exe

#fait le .h et .c de bison
bison:
	@echo bison analyse
	@bison -d -v TLC_GPE_7_Grammaire_v1.y 

#genere les lexemes
flex:
	@echo flex analyse 
	@flex TLC_Gpe_7_Grammaire.l

# fait .exe
compil:flex bison PileList Semantique Master
	@echo compil
#	@gcc -o lex.exe  lex.yy.c -lfl
	@gcc -o bison.exe TLC_GPE_7_Grammaire_v1.tab.c lex.yy.c -ll -ly -lfl Cellule.o Iterator.o Pile.o File.o Type.o Var.o Fonction.o Text.o PileVar.o TabType.o Outils.o Couple.o  N_Uplet.o NoeudArbre.o

#lance les serie de test
test:compil
	@echo on fait tous les test
	@./all_test.script
#-------------------------------------------------------------------------------
#fichier c
allC:PileList
	@echo fin compilation des fichier c de code

#-------------------------------------------------------------------------------
#main de test
test.exe: PileList mainTest.c Semantique Master
	@echo compilation de $@
	@gcc -o $@ $(CFLAG) mainTest.c Cellule.o Iterator.o Pile.o File.o Type.o Var.o Fonction.o Text.o PileVar.o TabType.o Outils.o
#-------------------------------------------------------------------------------
#fichier des table de type et var
Master:PileVar.o TabType.o Outils.o Couple.o N_Uplet.o NoeudArbre.o
	@echo fin compilation master composant

PileVar.o: PileVar.c PileVar.h Var.h Text.h Pile.h Iterator.h
	@echo compilation de $@
	@gcc -c $(CFLAG) $<

TabType.o: TabType.c TabType.h Type.h File.h 
	@echo compilation de $@
	@gcc -c $(CFLAG) $<

Outils.o:Outils.c Outils.h Type.h Var.h Fonction.h
	@echo compilation de $@
	@gcc -c $(CFLAG) $<

Couple.o:Couple.c Couple.h
	@echo compilation de $@
	@gcc -c $(CFLAG) $<

N_Uplet.o:N_Uplet.c N_Uplet.h File.h Iterator.h Var.h
	@echo compilation de $@
	@gcc -c $(CFLAG) $<

NoeudArbre.o:NoeudArbre.c NoeudArbre.h N_Uplet.h
	@echo compilation de $@
	@gcc -c $(CFLAG) $<
#-------------------------------------------------------------------------------
#fichier des types semantiques
Semantique:Type.o Var.o Fonction.o Text.o
	@echo fin compilation des types semantiques

Type.o:Type.c Type.h Fonction.h Var.h File.h Text.h  N_Uplet.h
	@echo compilation de $@
	@gcc -c $(CFLAG) $<

Fonction.o:Fonction.c Fonction.h Type.h Var.h Text.h File.h  N_Uplet.h
	@echo compilation de $@
	@gcc -c $(CFLAG) $<

Var.o:Var.c Var.h Type.h Fonction.h Text.h File.h N_Uplet.h
	@echo compilation de $@
	@gcc -c $(CFLAG) $<

Text.o: Text.c Text.h
	@echo compilation de $@
	@gcc -c $(CFLAG) $<
#-------------------------------------------------------------------------------
#fichier des pile list

PileList:Cellule.o Iterator.o Pile.o File.o
	@echo fin compilation des piles et listes

Cellule.o: Cellule.c Cellule.h
	@echo compilation de $@
	@gcc -c $(CFLAG) $<

Iterator.o: Iterator.c Iterator.h Cellule.h
	@echo compilation de $@
	@gcc -c $(CFLAG) $<

Pile.o: Pile.c Pile.h Iterator.h Cellule.h
	@echo compilation de $@
	@gcc -c $(CFLAG) $<

File.o: File.c File.h Iterator.h Cellule.h
	@echo compilation de $@
	@gcc -c $(CFLAG) $<
#-------------------------------------------------------------------------------

#clean
.PHONY: clean
clean:
	@echo MENAGE
	@rm *.exe -f
	@rm *.o -f
	@rm ResTest/Exemple/*.txt -f
	@rm ResTest/Exemple/EchecTests/*.txt -f
	
