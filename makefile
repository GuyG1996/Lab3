CFLAGS = -m32 -Wall -ansi -c -nostdlib -fno-stack-protector -g
LDFLAGS = -m elf_i386
EXECUTABLE = start

all: $(EXECUTABLE)

$(EXECUTABLE): start.o util.o 
	ld $(LDFLAGS) -g start.o util.o -o $(EXECUTABLE)

start.o: start.s
	nasm -f elf32 -g start.s -o start.o

util.o: util.h util.c 
	gcc $(CFLAGS) util.c -o util.o

clean:
	rm -f $(EXECUTABLE) *.o