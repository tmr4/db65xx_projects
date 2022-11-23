E = c:\cc65
W = $(MAKEDIR)
R = $W\Release
O = $R\obj
S = $W\src
L = $R\listing
TARGET = $R\int_io.bin
SOURCES = $S\acia.s \
	$S\delay.s \
	$S\int_io.s \
	$S\isr.s \
	$S\via.s
OBJECTS = $O\acia.o \
	$O\delay.o \
	$O\int_io.o \
	$O\isr.o \
	$O\via.o

all : $(TARGET)

$(TARGET) : $(OBJECTS) $(SOURCES) $R\Makefile $R\int_io.cfg
	$E\ca65 --cpu 65816 -g -l $L\acia.lst -o $O\acia.o $S\acia.s
	$E\ca65 --cpu 65816 -g -l $L\delay.lst -o $O\delay.o $S\delay.s
	$E\ca65 --cpu 65816 -g -l $L\int_io.lst -o $O\int_io.o $S\int_io.s
	$E\ca65 --cpu 65816 -g -l $L\isr.lst -o $O\isr.o $S\isr.s
	$E\ca65 --cpu 65816 -g -l $L\via.lst -o $O\via.o $S\via.s
	$E\ld65 -o $(TARGET) -m $L\int_io.map -Ln $L\int_io.sym -C $R\int_io.cfg --dbgfile $L\int_io.dbg $(OBJECTS)
	copy "$L\int_io.dbg" "$R\int_io.dbg"
