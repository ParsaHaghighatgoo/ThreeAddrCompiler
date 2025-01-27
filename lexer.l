%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
%}

DIGIT    [0-9]
ID       [a-zA-Z_][a-zA-Z_0-9]*

%%

{DIGIT}+ {
    yylval.attributes.value = atoi(yytext);
    yylval.attributes.temp = 0;             
    return NUMBER;
}

{ID} {
    yylval.id = strdup(yytext);
    return IDENTIFIER;
}

"+"      { return ADD; }
"-"      { return SUBTRACT; }
"*"      { return MULTIPLY; }
"/"      { return DIVIDE; }
"="      { return ASSIGN; }
"("      { return LPAREN; }
")"      { return RPAREN; }
";"      { return SEMICOLON; }
[ \t\n]+ {}  // Ignore whitespace
. {
    printf("Unexpected character: %s\n", yytext);
}

%%

int yywrap() {
    return 1;  // Signal end of input
}
