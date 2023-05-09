CFLAGS = -m32 -Wall -ansi -c -nostdlib -fno-stack-protector
LDFLAGS = -m elf_i386
EXECUTABLE = task1A

all: $(EXECUTABLE)

$(EXECUTABLE): start.o util.o main.o
	ld $(LDFLAGS) start.o main.o util.o -o $(EXECUTABLE)

start.o: start.s
	nasm -f elf32 start.s -o start.o

util.o: util.c util.h
	gcc $(CFLAGS) util.c -o util.o

main.o: main.c util.h
	gcc $(CFLAGS) main.c -o main.o

clean:
	rm -f $(EXECUTABLE) *.o
