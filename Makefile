all: mzload.tar.gz

SRCS = $(shell ls *.m *.txt *.md)

mzload.tar.gz: $(SRCS)
	tar cvzf $@ $^
