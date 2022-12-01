E = c:\cc65
W = $(MAKEDIR)
R = $W\Release
O = $R\obj
S = $W\src
L = $R\listing
TARGET = $R\chess.bin
SOURCES = $S\chess.s
OBJECTS = $O\chess.o

.SUFFIXES: .s .o

!IF !EXIST($O)
!IF [cmd /c mkdir $O] == 0
!MESSAGE Created $O
!ENDIF
!ENDIF

!IF !EXIST($L)
!IF [cmd /c mkdir $L] == 0
!MESSAGE Created $L
!ENDIF
!ENDIF

all : $(TARGET)

{$S}.s{$O}.o:
	$E\ca65 --cpu 65816 -g -l $L\$(@B).lst -o $@ $<

$(TARGET) : $(OBJECTS) $(SOURCES) $R\Makefile $R\$(@B).cfg
	$E\ld65 -o $(TARGET) -m $L\$(@B).map -Ln $L\$(@B).sym -C $R\$(@B).cfg --dbgfile $L\$(@B).dbg $(OBJECTS)
	copy "$L\$(@B).dbg" "$R\$(@B).dbg"
