LEX = lex
YACC = yacc -d
CC = gcc
LIBS = -ll -ly

ttcc: y.tab.o lex.yy.o
	$(CC) -o ttcc y.tab.o lex.yy.o $(LIBS)

lex.yy.o: lex.yy.c y.tab.h

y.tab.c y.tab.h: ttcc.y
	$(YACC) -v ttcc.y

lex.yy.c: ttcc.l
	$(LEX) ttcc.l

clean:
	rm -rf *.o lex.yy.c *.tab.*