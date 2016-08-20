

.PHONY: all clean


all : KursgleicheDDE00001


clean :
	-rm -v *.lps *.compiled *.o *.ppu *.bak *.or KursgleicheDDE00001
#	-rm -v Kursdatei.ico Kursdreieck*.bmp Kursgleiche.avi
	-rm -rv RXfpc/


$(HOME)/.lazarus/ :
	lazarus # just hit "Start IDE" to init lazarus and then quit

RX%/ RX%/vclutils.pas : | $(HOME)/.lazarus/	
	svn co https://lazarus-ccr.svn.sourceforge.net/svnroot/lazarus-ccr/components/rx/trunk/ RXfpc # git seems out of date: https://github.com/fpc-svn/lazarus-ccr/tree/master/components/rx/trunk
	lazbuild RX$*/rxnew.lpk # needs $(HOME)/.lazarus/

## dep on parent-dir causes inf. recursion, needs MF in parent-dir
# %.ico : ../KursgleicheIMGs/%.ico
# 	ln -s $< $@

# %.bmp : ../KursgleicheIMGs/%.bmp
# 	ln -s $< $@

# %.avi : ../KursgleicheAVI/%.avi
# 	ln -s $< $@


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

UStiftWindr2.pas : RXfpc/vclutils.pas
	test -e $@ # fail if missing
	touch $@ # just to cause rebuild of KursgleicheDDE00001

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

## IMGs and ANIs
KursgleicheDDE00001 : \
 Kursdatei.ico \
 Kursdreieck1.bmp \
 Kursdreieck2.bmp \
 Kursdreieck3.bmp \
 Kursgleiche.avi

KursgleicheDDE00001 : KursgleicheDDE00001.lpi
	lazbuild $< # http://wiki.freepascal.org/lazbuild
