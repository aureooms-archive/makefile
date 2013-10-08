$(VERBOSE).SILENT:

FILENAME = test
STYLESHEET = perso

#DONOTTOUCH



OK_STRING=$(OK_COLOR)✔
ERROR_STRING=$(ERROR_COLOR)✖
WARN_STRING=$(WARN_COLOR)⚑

ifneq ($(nocolor),true)
	NO_COLOR=\033[0m
	OK_COLOR=\033[92m
	ERROR_COLOR=\033[91m
	WARN_COLOR=\033[93m
	ACTION_COLOR=\033[95m
endif


TEX = tex
STY = sty
BIB = bib
TEXFILES = $(shell find $(TEX) -regex .*\\.tex | sed 's/ /\\ /g')
STYFILES = $(shell find $(STY) -regex .*\\.sty | sed 's/ /\\ /g')
BIBFILES = $(shell find $(BIB) -regex .*\\.bib | sed 's/ /\\ /g')

RERUN = "(There were undefined references|Rerun to get (cross-references|the bars) right)"
UNDEFINED = "((Reference|Citation).*undefined)|(Label.*multiply defined)"
LATEX = xelatex -shell-escape -interaction=nonstopmode -halt-on-error
BIBTEX = bibtex
MAKEINDEX = makeindex


default: all

all: $(FILENAME).pdf

$(FILENAME).pdf: $(FILENAME).tex $(STYLESHEET).sty bib/touch.bbl

	echo -n "$(ACTION_COLOR)"link \#1"$(NO_COLOR) "
	$(LATEX) $(FILENAME).tex 1> temp.log || touch temp.errors
	if test -e temp.errors; then echo "$(ERROR_STRING)" && cat temp.log && echo -n "$(NO_COLOR)"; fi;
	if test -e temp.errors; then rm -f temp.errors temp.log && false; fi;
	if [ -e bib/touchtmp.bbl ]; then echo -n "\n$(ACTION_COLOR)"bibtex"$(NO_COLOR) " \
	&& $(BIBTEX) $(FILENAME) 1> temp.log && rm bib/touchtmp.bbl \
	|| (touch temp.errors && rm bib/touchtmp.bbl); fi
	if test -e temp.errors; then echo "$(ERROR_STRING)" && cat temp.log && echo -n "$(NO_COLOR)"; fi;
	if test -e temp.errors; then rm -f temp.errors temp.log && false; fi;
	if [ -e $(FILENAME).idx ]; then echo -n "\n$(ACTION_COLOR)"makeindex"$(NO_COLOR) " \
	&& $(MAKEINDEX) $(FILENAME) 2> temp.log || touch temp.errors; fi
	if test -e temp.errors; then echo "$(ERROR_STRING)" && cat temp.log && echo -n "$(NO_COLOR)"; fi;
	if test -e temp.errors; then rm -f temp.errors temp.log && false; fi;
	echo -n "\n$(ACTION_COLOR)"link \#2"$(NO_COLOR) "
	$(LATEX) $(FILENAME).tex 1> temp.log || touch temp.errors
	if test -e temp.errors; then echo "$(ERROR_STRING)" && cat temp.log && echo -n "$(NO_COLOR)"; fi;
	if test -e temp.errors; then rm -f temp.errors temp.log && false; fi;
	if egrep -q $(RERUN) $(FILENAME).log ; then echo -n "\n$(ACTION_COLOR)"link \#3"$(NO_COLOR) " \
	&& $(LATEX) $(FILENAME).tex 1> temp.log || touch temp.errors; fi
	if test -e temp.errors; then echo "$(ERROR_STRING)" && cat temp.log && echo -n "$(NO_COLOR)"; fi;
	if test -e temp.errors; then rm -f temp.errors temp.log && false; fi;
	if egrep -q $(RERUN) $(FILENAME).log ; then echo -n "\n$(ACTION_COLOR)"link \#4"$(NO_COLOR) " \
	&& $(LATEX) $(FILENAME).tex 1> temp.log || touch temp.errors; fi
	if test -e temp.errors; then echo "$(ERROR_STRING)" && cat temp.log && echo -n "$(NO_COLOR)"; elif test -s temp.log; then echo "$(WARN_STRING)" && cat temp.log && echo -n "$(NO_COLOR)"; else echo "$(OK_STRING)$(NO_COLOR)"; fi;
	if test -e temp.errors; then rm -f temp.errors temp.log && false; else rm -f temp.errors temp.log; fi;
	egrep -i $(UNDEFINED) $(FILENAME).log || true

$(FILENAME).tex: $(TEXFILES)
	echo "$(ACTION_COLOR)"tex files changed"$(NO_COLOR)"
	python texbuilder.py $(TEX) $(FILENAME).tex

$(STYLESHEET).sty: $(STYFILES)
	echo "$(ACTION_COLOR)"sty files changed"$(NO_COLOR)"
	python stybuilder.py $(STY) $(STYLESHEET).sty

bib/touch.bbl: $(BIBFILES)
	echo "$(ACTION_COLOR)"bib files changed"$(NO_COLOR)"
	touch bib/touch.bbl
	touch bib/touchtmp.bbl

clean:
	rm -f *.aux *.lof *.log *.bbl *.blg *.toc *.idx *.ilg *.ind *.lol *.out *.loa *.equ *.pyg *.alg *.lomintedobject *.loalgobject *.loe $(FILENAME).tex $(FILENAME).pdf $(STYLESHEET).sty *.asy bib/touch.bbl bib/touchtmp.bbl
