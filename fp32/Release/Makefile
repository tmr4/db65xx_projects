E = c:\cc65
W = $(MAKEDIR)
R = $W\Release
O = $R\obj
S = $W\src
L = $R\listing
TARGET = $R\fp32.bin
SOURCES = $S\fp32.s  $S\main.s
OBJECTS = $O\fp32.o  $O\main.o

.SUFFIXES: .s .o

all : $(TARGET)

{$S}.s{$O}.o:
	$E\ca65 --cpu 65816 -g -l $L\$(@B).lst -o $@ $<

$(TARGET) : $(OBJECTS) $(SOURCES) $R\Makefile $R\$(@B).cfg
	$E\ld65 -o $(TARGET) -m $L\$(@B).map -Ln $L\$(@B).sym -C $R\$(@B).cfg --dbgfile $L\$(@B).dbg $(OBJECTS)
	copy "$L\$(@B).dbg" "$R\$(@B).dbg"
