all: mzload.tar.gz

SRCS = $(shell ls *.m *.txt)

mzload.tar.gz: $(SRCS)
	tar cvzf $@ $^
