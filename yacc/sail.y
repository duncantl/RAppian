/* from https://www.geeksforgeeks.org/introduction-to-yacc/ */

%{
   #include <ctype.h>
   #include <stdio.h>
   #define YYSTYPE double /* double type for yacc stack */
%}

// %token-table

%token  END_OF_INPUT
%token BANG
%token EQ
%token NEQ
%token COLON

%%

//  comment
prog : END_OF_INPUT {}
     | expr  {}
     | call  {}
     ;

flot_const : [0-9]*[.][0-9]+;

int_const : [0-9]+;


exprlist : expr ',' expr
         | exprlist ',' expr
         ;

arglist : '(' exprlist ')'
         ;

namedarg : name ':' expr

expr : INT_CONST {}
     | FLOAT_CONST {}
     | STR_CONST {}
     | NULL_CONST {}
     |  '{' exprlist '}'  {}
     | call {}
     | namedarg {}
     | expr arith_op expr {}
    ;

arith_op :  '+' {}
         ;

value :  domain BANG name {}
      ;

call :  value '(' arglist ')'   {}
    ;
// comment : "/*"  "*/"


%%


#include "lex.yy.c"


static int token(void)
{

}

static int yylex(void)
{

}


void yyerror(char * s)
/* yacc error handler */
{  
 fprintf (stderr, "%s\n", s);
}
  
int main(void)
{
 return yyparse();
}
