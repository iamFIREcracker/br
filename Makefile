.PHONY: all install

PREFIX?=/usr/local

all: br

install:
	cp br $(PREFIX)/bin/
