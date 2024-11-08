# Mainīgais faila nosaukumam:
TARGET=md1
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
test:	build
		qemu-arm -L /usr/arm-linux-gnueabi ./$(TARGET)

# Tīrīšanas komanda (izdzēš liekos objektfailus)
clean:
		rm -f *.o
		rm -f *.lis
		rm -f $(TARGET)