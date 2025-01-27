%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;

void yyerror(const char *s);

int temp_counter = 1;
int result;

void print_temp_code(const char *op, int left_temp, int right_temp, int t, int left_val, int right_val) {
    printf("t%d = ", t);
    if (left_temp > 0) printf("t%d ", left_temp);
    else printf("%d ", left_val);

    printf("%s ", op);

    if (right_temp > 0) printf("t%d;\n", right_temp);
    else printf("%d;\n", right_val);
}

int reverse_number(int num) {
    int reversed = 0;
    while (num != 0) {
        reversed = reversed * 10 + num % 10;
        num /= 10;
    }
    return reversed;
}

int is_multiple_of_10(int num) {
    return num % 10 == 0;
}
%}

%union {
    int num;          // Numeric values
    char *id;         // Identifiers
    struct {
        int value;
        int temp;
    } attributes;
}

%token <num> NUMBER
%token <id> IDENTIFIER
%token ADD SUBTRACT MULTIPLY DIVIDE ASSIGN LPAREN RPAREN SEMICOLON

%type <attributes> statement expression term factor

%right ASSIGN
%left ADD SUBTRACT
%left MULTIPLY DIVIDE

%%

program:
    statements
    ;

statements:
    statements statement
    |
    ;

statement:
    IDENTIFIER ASSIGN expression SEMICOLON {
        printf("%s = t%d;\n", $1, $3.temp ? $3.temp : $3.value);
        free($1);
        result = $3.value;
        printf("Result: %d\n", result);
        printf("-------------------\n");
        printf("Enter an expression:\n");
        temp_counter = 1;  // Reset counter
        result = 0;
    }
    ;

expression:
    expression MULTIPLY term {
        int temp_value = $1.value * $3.value;
        if (is_multiple_of_10(temp_value)) {
            $$ = (typeof($$)){.value = temp_value, .temp = temp_counter++};
        } else {
            $$ = (typeof($$)){.value = reverse_number(temp_value), .temp = temp_counter++};
        }
        print_temp_code("*", $1.temp, $3.temp, $$.temp, $1.value, $3.value);
    }
    | expression DIVIDE term {
        int temp_value = $1.value / $3.value;
        if (is_multiple_of_10(temp_value)) {
            $$ = (typeof($$)){.value = temp_value, .temp = temp_counter++};
        } else {
            $$ = (typeof($$)){.value = reverse_number(temp_value), .temp = temp_counter++};
        }
        print_temp_code("/", $1.temp, $3.temp, $$.temp, $1.value, $3.value);
    }
    | term {
        $$ = $1;
    }
    ;

term:
    factor ADD term {
        int temp_value = $1.value + $3.value;
        if (is_multiple_of_10(temp_value)) {
            $$ = (typeof($$)){.value = temp_value, .temp = temp_counter++};
        } else {
            $$ = (typeof($$)){.value = reverse_number(temp_value), .temp = temp_counter++};
        }
        print_temp_code("+", $1.temp, $3.temp, $$.temp, $1.value, $3.value);
    }
    | factor SUBTRACT term {
        int temp_value = $1.value - $3.value;
        if (is_multiple_of_10(temp_value)) {
            $$ = (typeof($$)){.value = temp_value, .temp = temp_counter++};
        } else {
            $$ = (typeof($$)){.value = reverse_number(temp_value), .temp = temp_counter++};
        }
        print_temp_code("-", $1.temp, $3.temp, $$.temp, $1.value, $3.value);
    }
    | factor {
        $$ = $1;
    }
    ;

factor:
    NUMBER {
        if (is_multiple_of_10($1)) {
            $$ = (typeof($$)){.value = $1, .temp = 0};
        } else {
            $$ = (typeof($$)){.value = reverse_number($1), .temp = 0};
        }
    }
    | LPAREN expression RPAREN {
        $$ = $2;
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter an expression:\n");
    if (!yyparse()) {
        printf("Parsing complete.\n");
    }
    return 0;
}
