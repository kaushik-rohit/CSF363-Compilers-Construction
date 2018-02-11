LEX=flex
CC=gcc
INC_DIR = ../Beautifier
CFLAGS=-c -Wall -I$(INC_DIR)

beautify: beautify.o symbol_table.o
		  $(CC) -o $@  $(LDFLAGS) $^
				
beautify.o: beautify.c
			$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $^

symbol_table.o: symbol_table.c
			$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $^
				
beautify.c: beautifier.l
			$(LEX) $(LFLAGS) -o $@ $^
				
clean:
		$(RM) *.o
