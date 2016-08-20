

.PHONY: all clean


all : KursgleicheDDE00001


clean :
	-rm -v *.lps *.compiled *.o *.ppu *.bak *.or KursgleicheDDE00001


## some *.pas depend on their *.lfm:
KursDDE00001.pas \
KursDDE00002.pas \
KursDDE00003.pas \
KursDDE00004.pas \
KursDDE00005.pas \
KursDDE00006.pas \
KursDDE00007.pas \
KursDDE00008.pas \
KursDDE00009.pas \
KursDDE00010.pas \
KursDDE00011.pas \
 : %.pas : %.lfm # grep -l -F '{$R *.lfm}' *.pas | sed 's/$/ \\/g'
	test -e $@ # there must be a rule or deps will not be tested!

## *.lpi contains project dependencies:
KursgleicheDDE00001 : \
 KursDDE00001.pas \
 KursDDE00002.pas \
 KursDDE00003.pas \
 KursDDE00004.pas \
 KursDDE00005.pas \
 KursDDE00006.pas \
 KursDDE00007.pas \
 KursDDE00008.pas \
 KursDDE00009.pas \
 KursDDE00010.pas \
 KursDDE00011.pas \
 UStiftWindr2.pas # grep pas KursgleicheDDE00001.lpi  | sort | grep -o '".*"' | xargs

KursgleicheDDE00001 : KursgleicheDDE00001.lpi
	lazbuild $< # http://wiki.freepascal.org/lazbuild
