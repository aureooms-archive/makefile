
RUN = name of the runnable
WHICH = where to put it (usually /usr/bin/program_name)

all:

install:
	ln -s $(CURDIR)/$(RUN) $(WHICH)

uninstall:
	rm $(WHICH)

clean: