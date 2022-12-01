E = c:\cc65
W = $(MAKEDIR)
R = $W\Release
O = $R\obj
S = $W\src
L = $R\listing
TARGET = $R\hello.bin
CTARGETS = $S\hello.s
CSOURCES = $S\hello.c
OBJECTS = $O\hello.o

.SUFFIXES:
.SUFFIXES: .c .s .o

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

all : $(TARGET) $(CTARGETS)

$(CTARGETS) : $(CSOURCES) $R\Makefile

$(TARGET) : $(OBJECTS) $(CSOURCES) $R\Makefile $R\hello.cfg
	$E\ld65 -o $@ -m $L\$(@B).map -Ln $L\$(@B).sym -C $R\hello.cfg --dbgfile $L\$(@B).dbg $(OBJECTS) $R\hello.lib
	copy "$L\$(@B).dbg" "$R\$(@B).dbg"

{$S}.s{$O}.o:
	$E\ca65 --cpu 65C02 -g -l $L\$(@B).lst -o $@ $<

{$S}.c{$S}.s:
	$E\cc65 --cpu 65C02 -g -o $@ $<
