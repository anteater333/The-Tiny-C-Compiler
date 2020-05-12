%option noinput
%option noyywrap

    /* Definitions */
%{
#include "y.tab.h"
%}

alpha [a-zA-Z_]
digit [0-9]

    /* Rules using Regex */
%%
    /* Preprocessor */
#{alpha}+.*\n   {           yylineno = yylineno + 1; printf("\n"); }

\n   {                      yylineno = yylineno + 1; printf("\n"); }
[ \t]                       printf("%s", yytext);
    /* Data types */
"int"                       return (INT);
"void"                      return (VOID);
    /* Conditional statement */
"if"                        printf("%s ", yytext); return (IF);
    /* Control statement */
"for"                       printf("%s ", yytext); return (FOR);
"continue"                  printf("%s ", yytext); return (CONTINUE);
    /* Number & ID */
{digit}+                    {
                                int temp;
                                sscanf(yytext, "%d", &temp);
                                yylval.dval = temp;
                                return (NUM);
                            }
{alpha}({alpha}|{digit})*   {
                                char temp;
                                sscanf(yytext, "%s", &temp);
                                yylval.sval = &temp;
                                return (ID);
                            }
    /* String */
\"(\\.|[^\\""]|\n)*\"       {
                                char temp;
                                sscanf(yytext, "%s", &temp);
                                yylval.sval = &temp;
                                return (STRING);
                            }

    /* Operators */
","                         printf("%s ", yytext); return (',');
"="                         printf("%s ", yytext); return ('=');
"+"                         printf("%s ", yytext); return ('+');
"-"                         printf("%s ", yytext); return ('-');
"*"                         printf("%s ", yytext); return ('*');
"/"                         printf("%s ", yytext); return ('/');
"++"                        printf("%s ", yytext); return INC;
"+="                        printf("%s ", yytext); return ADDASS;

"<="                        printf("%s ", yytext); return LE;
">="                        printf("%s ", yytext); return GE;
"=="                        printf("%s ", yytext); return EQ;
"!="                        printf("%s ", yytext); return NE;
"||"                        printf("%s ", yytext); return OR;
"&&"                        printf("%s ", yytext); return AND;

"("                         printf("%s ", yytext); return ('(');
")"                         printf("%s ", yytext); return (')');
"["                         printf("%s ", yytext); return ('[');
"]"                         printf("%s ", yytext); return (']');
"<"                         printf("%s ", yytext); return ('<');
">"                         printf("%s ", yytext); return ('>');
"|"                         printf("%s ", yytext); return ('|');
"&"                         printf("%s ", yytext); return ('&');
"!"                         printf("%s ", yytext); return ('!');
"{"                         printf("%s ", yytext); return ('{');
"}"                         printf("%s ", yytext); return ('}');

    /* Semicolon */
";"                         return (';');

    /* Ignore bad characters */
.                               ;
    /* Subroutines */
%%