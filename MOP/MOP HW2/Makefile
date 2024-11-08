# Mainīgais faila nosaukumam:
TARGET=md2
OBJ=$(TARGET)_main.o $(TARGET).o

# Mainīgie kompilatoriem:
CC= arm-linux-gnueabi-gcc
AS= arm-linux-gnueabi-as

# Flagi komandām
CCFLAGS= -O0 -Wall # Bez optimizācijas, visi brīdinājumi
ASFLAGS= -alh=$*.lis -L

# Izpildāmo komandu bloku definēšana
all:	build test

# Build komandas:
# Objektfailu iegūšana (1/2)
%.o:	%.c # Tiks meklēts .c paplašinājuma fails
		$(CC) $(CCFLAGS) -c -o$@ $<

# Objektfailu iegūšana (2/2)
%.o:	%.s # Tiks meklēts .s paplašinājuma fails
		$(AS) $(ASFLAGS) -o $@ $<

# Objektfailu linkošana
build:	$(OBJ) # Nepieciešamie faili (ja nav, tad veidos tos)
		$(CC) -o $(TARGET) $(OBJ)

# Testēšanas komanda
test:	clean build
		qemu-arm -L /usr/arm-linux-gnueabi ./$(TARGET) < infile.txt

# Tīrīšanas komanda (izdzēš liekos objektfailus)
clean:
		rm -f *.o
		rm -f *.lis
		rm -f $(TARGET)

fulltest: clean build
		qemu-arm -L /usr/arm-linux-gnueabi ./$(TARGET) < ebtest1.txt
		qemu-arm -L /usr/arm-linux-gnueabi ./$(TARGET) < ebtest2.txt
		qemu-arm -L /usr/arm-linux-gnueabi ./$(TARGET) < ebtest3.txt
		qemu-arm -L /usr/arm-linux-gnueabi ./$(TARGET) < ebtest4.txt
		qemu-arm -L /usr/arm-linux-gnueabi ./$(TARGET) < ebtest5.txt
		qemu-arm -L /usr/arm-linux-gnueabi ./$(TARGET) < ebtest6.txt
		qemu-arm -L /usr/arm-linux-gnueabi ./$(TARGET) < ebtest7.txt
		qemu-arm -L /usr/arm-linux-gnueabi ./$(TARGET) < ebtest8.txt
		qemu-arm -L /usr/arm-linux-gnueabi ./$(TARGET) < ebtest9.txt