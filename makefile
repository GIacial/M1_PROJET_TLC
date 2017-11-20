
frun:fall
	@echo Lancement de executable lex.exe
	@./lex.exe

fall:flex compil

flex:
	@echo flex analyse
	@flex TLC_Gpe_7_Grammaire.l

compil:
	@echo compil
	@gcc -o lex.exe  lex.yy.c -lfl

test:
	@echo on fait tous les test
	@./all_test.script