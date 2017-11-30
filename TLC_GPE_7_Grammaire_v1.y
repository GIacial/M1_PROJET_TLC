%{
	
#include "lex.yy.c"

%}
%token KW_CLASS 
%token IDENF
%token KW_EXTEND
%token KW_DATA
%token TYP_PRIMITIF
%token SEP_INSTRUCT
%token KW_FUNCTION
%token PAR_OUV
%token PAR_FER
%token KW_RETURN
%token FUNC_OUV
%token FUNC_FERM
%token OP_PLUS
%token OP_MOINS
%token OP_MULTI
%token OP_DIV
%token OP_AFF
%token OP_FUNC
%token OP_INF
%token OP_INF_EQ
%token OP_SUP
%token OP_SUP_EQ
%token OP_DIFF
%token OP_EQ
%token OP_AND
%token OP_OR
%token KW_ENDCLASS
%token VAL_BOOL
%token VAL_INT
%token VAL_FLOAT
%token SEP_PARAM

%start s
%%
s 	: IDENF												{printf("OG\n");YYACCEPT;}
	;



%%

int yyerror(char* s){
		printf("ERROR %s \n", s);
		return 0;
	}
int main(){
	int parseError = yyparse();
	printf("CODE PARSE %d \n",parseError);
	return 0;
}