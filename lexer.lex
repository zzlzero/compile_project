%{
#include "lexer.h"

void output(const char* type, char* text);
int row = 1;
int col = 1;
int num = 0;
%}
%option     nounput
%option     noyywrap

WHITESPACE  [\ \t\r]+
COMMENT    \(\*.*\*\)
RESERVED     ("AND"|"ARRAY"|"BEGIN"|"BY"|"DIV"|"DO"|"ELSE"|"ELSIF"|"END"|"EXIT"|"FOR"|"IF"|"IN"|"IS"|"LOOP"|"MOD"|"NOT"|"OF"|"OR"|"OUT"|"PROCEDURE"|"PROGRAM"|"READ"|"RECORD"|"RETURN"|"THEN"|"TO"|"TYPE"|"VAR"|"WHILE"|"WRITE")
DIGIT       [0-9]
DIGITS         {DIGIT}+
INTEGER     {DIGITS}
HEXDIGIT    [0-9A-Fa-f]
REAL        {DIGIT}+"."{DIGIT}*

STRING      \"([^"\n])*\"
LETTER      [a-zA-Z]
ID          {LETTER}({LETTER}|{DIGIT})*
DELIMETER   (":"|";"|","|"."|"("|")"|"["|"]"|"{"|"}"|"[<"|">]"|'\')
OPERATOR    (":="|"+"|"-"|"*"|"/"|"<"|"<="|">"|">="|"="|"<>")

%%

<<EOF>>         {
                        printf("\nNumber of tokens: %d", num);
                        return T_EOF;
                }


{COMMENT}       col += strlen(yytext);

{RESERVED}       output("reserved", yytext);

{STRING}  {
    if(yyleng-2 < 256) output( "string",yytext);

   else  perror("String too long");
}

{OPERATOR}      output("operator ", yytext);

{DELIMETER}     output("delimeter", yytext);

{ID}            output("identifer", yytext);

{INTEGER}       {
                        if(strlen(yytext) > 9 && atoi(yytext) == -1)
                        {
                                output("ERROR: Integer out of range", yytext);
                                return 1;
                        }
                        output("integer  ", yytext);
                }

{REAL}          output("real     ", yytext);


\n   {
        row++; 
        col = 1;
        }   


.               col++;

%%

void output(const char* type, char* text){

        printf("%d\t%d\t%s\t%s\n",  row, col, type, text);
        col += strlen(text);
        num++;

        return;
}

    