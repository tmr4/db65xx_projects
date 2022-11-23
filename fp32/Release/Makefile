E = c:\cc65
W = $(MAKEDIR)
R = $W\Release
O = $R\obj
S = $W\src
L = $R\listing
TARGET = $R\fp32.bin
SOURCES = $S\fp32.s  $S\main.s
OBJECTS = $O\fp32.o  $O\main.o

all : $(TARGET)

$(TARGET) : $(OBJECTS) $(SOURCES) $R\Makefile $R\fp32.cfg
	$E\ca65 --cpu 65816 -g -l $L\fp32.lst -o $O\fp32.o $S\fp32.s
	$E\ca65 --cpu 65816 -g -l $L\main.lst -o $O\main.o $S\main.s
	$E\ld65 -o $(TARGET) -m $L\fp32.map -Ln $L\fp32.sym -C $R\fp32.cfg --dbgfile $L\fp32.dbg $(OBJECTS)
	copy "$L\fp32.dbg" "$R\fp32.dbg"
