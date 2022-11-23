E = c:\cc65
W = $(MAKEDIR)
R = $W\Release
O = $R\obj
S = $W\src
L = $R\listing
TARGET = $R\hello_world.bin
SOURCES = $S\hello_world.s
OBJECTS = $O\hello_world.o

all : $(TARGET)

$(TARGET) : $(OBJECTS) $(SOURCES) $R\Makefile $R\hello_world.cfg
	$E\ca65 --cpu 65816 -g -l $L\hello_world.lst 	-o $O\hello_world.o 	$S\hello_world.s
	$E\ld65 -o $(TARGET) -m $L\hello_world.map -Ln $L\hello_world.sym -C $R\hello_world.cfg --dbgfile $L\hello_world.dbg $(OBJECTS)
	copy "$L\hello_world.dbg" "$R\hello_world.dbg"
