
INTERLEAVE ?= 6

PRGS64 = bin/timeload64sys bin/timeload64vec
PRGS128 = bin/timeload128sys bin/timeload128vec
TESTS64 = bin/mem64check50k bin/mem64check62k
TESTS128 = bin/mem128check50k bin/mem128check57k

all: img

clean:
	rm -f *.o

img: images/timeload64.d64 images/timeload128.d64 \
     images/timeload64i$(INTERLEAVE).d64 images/timeload128i$(INTERLEAVE).d64 \
     images/timeload.d71 images/timeload.d81

bin/timeload64sys: timeload64sys.s
	cl65 -C c64-asm.cfg -t c64 -o $@ $^

bin/timeload64vec: timeload64vec.s
	cl65 -C c64-asm.cfg -t c64 -o $@ $^

bin/timeload128sys: timeload128sys.s
	cl65 -C c128-asm.cfg -t c128 -o $@ $^

bin/timeload128vec: timeload128vec.s
	cl65 -C c128-asm.cfg -t c128 -o $@ $^

images/timeload64.d64: $(PRGS64) $(TESTS64)
	c1541 -format "timeload64,xx" d64 "$@"
	for i in $^; do c1541 "$@" -write $$i; done

images/timeload128.d64: $(PRGS128) $(TESTS128)
	c1541 -format "timeload128,xx" d64 "$@"
	for i in $^; do c1541 "$@" -write $$i; done

images/timeload.d71: $(PRGS64) $(PRGS128) $(TESTS64) $(TESTS128)
	c1541 -format "timeload,xx" d71 "$@"
	for i in $^; do c1541 "$@" -write $$i; done

images/timeload.d81: $(PRGS64) $(PRGS128) $(TESTS64) $(TESTS128)
	c1541 -format "timeload,xx" d81 "$@"
	for i in $^; do c1541 "$@" -write $$i; done

images/timeload64i$(INTERLEAVE).d64: $(PRGS64) $(TESTS64)
	mkd64 -o $@ -m cbmdos -d TIMELOAD64 -i 'I$(INTERLEAVE)' \
	-f timeload64sys -n TIMELOAD64SYS -i$(INTERLEAVE) -w \
	-f timeload64vec -n TIMELOAD64VEC -i$(INTERLEAVE) -w \
	-f mem64check50k -n MEM64CHECK50K -i$(INTERLEAVE) -w \
	-f mem64check62k -n MEM64CHECK62K -i$(INTERLEAVE) -w \

images/timeload128i$(INTERLEAVE).d64: $(PRGS128) $(TESTS128)
	mkd64 -o $@ -m cbmdos -d TIMELOAD128 -i 'I$(INTERLEAVE)' \
	-f timeload128sys -n TIMELOAD128SYS -i$(INTERLEAVE) -w \
	-f mem128check50k -n MEM128CHECK50K -i$(INTERLEAVE) -w \
	-f mem128check57k -n MEM128CHECK57K -i$(INTERLEAVE) -w \

