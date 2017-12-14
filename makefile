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
compil:flex bison
	@echo compil
#	@gcc -o lex.exe  lex.yy.c -lfl
	@gcc -o bison.exe TLC_GPE_7_Grammaire_v1.tab.c lex.yy.c -ll -ly -lfl

#lance les serie de test
test:compil
	@echo on fait tous les test
	@./all_test.script

#clean
.PHONY: clean
clean:
	@echo MENAGE
	@rm *exe -f
	@rm *.c -f
	@rm *.h -f	
	@rm ResTest/Exemple/*.txt -f
	
