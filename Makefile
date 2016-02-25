all: mzload.tar.gz

SRCS = $(shell ls *.m)

mzload.tar.gz: $(SRCS)
	tar cvzf $@ $^
