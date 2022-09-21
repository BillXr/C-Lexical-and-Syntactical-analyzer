all:
	bison -d simple-parser.y
	flex simple-parser.l
	gcc simple-parser.tab.c lex.yy.c -o simple-parser
	./simple-parser input.txt output.txt

clean:
	rm simple-parser.tab.c simple-parser.tab.h lex.yy.c simple-parser
