%{
    /* Declarations */
#include <stdio.h>
#include <string.h>

extern int yylex(void);
extern void yyerror(const char *);

extern int yylineno;
extern char* yytext;

%}

%define parse.error verbose

%union{
    double dval;
    char* sval;
}

%token INT VOID
%token IF
%token FOR CONTINUE
%token<dval> NUM
%token<sval> ID STRING

%token LE GE EQ NE
%token OR AND

%right '=' ADDASS
%right INC
%left '+' '-'
%left '*' '/'
%left '<' '>' LE GE EQ NE OR AND

%%
    /* Rules using BNF */
/* Start state */
program:
      Declaration
    | Function
    ;

/* Declaration */
Declaration:
	  Type Assignment ';'
    | Assignment ';'
    | FunctionCall ';'
    | Array ';'
    | Type Array ';'
    | error
    ;

/* Assignment */
Assignment: 
	  Id
	| Num
    | STRING            { printf("<STRING, %s> ", $1); }
    | Array
	| '-' Id
	| '-' Num
    | Id AssignmentOp Assignment
	| Id AssignmentOp FunctionCall
	| Array AssignmentOp Assignment
	| Id ',' Assignment
	| Num ',' Assignment
	| Array ',' Assignment
	| Id '+' Assignment
	| Id '-' Assignment
	| Id '*' Assignment
	| Id '/' Assignment
    | Id INC
	| Array '+' Assignment
	| Array '-' Assignment
	| Array '*' Assignment
	| Array '/' Assignment
    | Array INC
	| Num '+' Assignment
	| Num '-' Assignment
	| Num '*' Assignment
	| Num '/' Assignment
	| '\'' Assignment '\''	
	| '(' Assignment ')'
	| '-' '(' Assignment ')'
    | 
	;

AssignmentOp:
      '='
    | ADDASS
    ;

Array:
      Id ArrayDm
    ;

ArrayDm:
      '['']'ArrayDm
    | '['Assignment']'ArrayDm
    |
    ;

FunctionCall:
	  Id'('')'
    | Id'('Assignment')'
    ;

/* Function */
Function:
	  Type Id '(' ArgumentListOpt ')' CompoundStmt      { printf(": <Function>"); } 
    ;

ArgumentListOpt:
      ArgumentList
    |
    ;

ArgumentList:
	  Argument
    | ArgumentList ',' Argument
    ;

Argument:
	  Type Array
    ;

/* Compound statement */
CompoundStmt:
	  '{' StmtList '}'
    ;

StmtList:
	  StmtList Stmt
    |
    ;

Stmt:
      For
    | If
    | Declaration
    | CONTINUE ';'
    | ';'
    ;

For:
      FOR '(' Condition ';' Condition ';' Condition ')' CompoundStmt      { printf(": <For-statement>"); } 
    | FOR '(' Condition ';' Condition ';' Condition ')' Stmt              { printf(": <For-statement>"); } 
    ;

If:
      IF '(' Condition ')' CompoundStmt               { printf(": <If-statement>"); } 
    | IF '(' Condition ')' Stmt                       { printf(": <If-statement>"); } 
    ;

/* Condition */
Condition:
      Condition EQ Condition
    | Condition NE Condition
    | Condition LE Condition
    | Condition GE Condition
    | Condition '<' Condition
    | Condition '>' Condition
    | Condition OR Condition
    | Condition AND Condition
    | Assignment
    ;

/* Type */
Type:
      INT       { printf("<Type, %s> ", yytext); }
    | VOID      { printf("<Type, %s> ", yytext); }
    ;

Id:
      ID { printf("<ID, %s> ", $1); }
    ;

Num:
      NUM { printf("<NUM, %d> ", $1); }

    /* Program */
%%
void yyerror(const char *s) 
{
    printf("line #%4d | %s >> ( %s )\n", yylineno, s, yytext);
}

int main()
{
    if(!yyparse())
    {
        printf("\n\nParsed.\n");
        return 0;
    }
    else
    {
        printf("\n\nNot parsed.\n");
        return 1;
    }
}