$(VERBOSE).SILENT:

#PROJECT SPECIFIC

INCLUDE_PATH = h ~/custom/lib/header/path
LIBS = -libnames
OUTPUTNAME = run
TYPE = [lib|run]
SRC = src/path/name

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

ROOT =
FLAGS = -Wall -W

ifeq ($(prof),true)
	ROOT = prof/
	FLAGS += -pg
endif

ifeq ($(O),1)
	FLAGS += -O1
endif
ifeq ($(O),2)
	FLAGS += -O2
endif
ifeq ($(O),3)
	FLAGS += -O3
endif

AR = ar -rcs
CXX = g++ -std=c++11 $(INCLUDE_PATH) $(FLAGS)
TOOL = $(CXX) -o
TOOL_OPT = $(LIBS)
ifeq ($(TYPE),lib)
	TOOL = $(AR)
	TOOL_OPT = 
endif

ifndef SRC
	SRC = src
endif
OUTPUTDIR = o
DEPENDENCYDIR = d
OBJFILES = $(patsubst $(SRC)/%,$(ROOT)$(OUTPUTDIR)/%,$(patsubst %.cpp,%.o,$(shell find $(SRC) | grep \\.cpp$$)))
DEP = g++ -MM -MF
DEPFILES = $(patsubst $(ROOT)$(OUTPUTDIR)/%,$(ROOT)$(DEPENDENCYDIR)/%,$(patsubst %.o,%.d,$(OBJFILES)))

REQUIRED_DIRS = $(shell find $(SRC) -type d | sed s/^$(SRC)/$(ROOT)$(OUTPUTDIR)/)
REQUIRED_DIRS += $(shell find $(SRC) -type d | sed s/^$(SRC)/$(ROOT)$(DEPENDENCYDIR)/)
_MKDIRS := $(shell for d in $(REQUIRED_DIRS); \
             do                               \
               [ -d $$d ] || mkdir -p $$d;  \
             done)

SKIP = false
ifeq (me a sandwich,$(MAKECMDGOALS))
	SKIP = true
endif
ifeq (it so,$(MAKECMDGOALS))
	SKIP = true
endif
ifeq (sense,$(MAKECMDGOALS))
	SKIP = true
endif
ifeq (love,$(MAKECMDGOALS))
	SKIP = true
endif

ifneq ($(SKIP), true)
ifneq ($(words $(MAKECMDGOALS)),1)
.DEFAULT_GOAL = all
%:
	@$(MAKE) $@ --no-print-directory -rRf $(firstword $(MAKEFILE_LIST))
else


all: prepare $(OUTPUTNAME)

ifneq ($(MAKECMDGOALS),clean)
-include $(DEPFILES)
endif

ifndef PRINT_PROGRESS
T := $(shell $(MAKE) $(MAKECMDGOALS) prof=$(prof) --dry-run \
      -rRf $(firstword $(MAKEFILE_LIST)) \
      PRINT_PROGRESS="echo COUNTTHIS" BUILD="test x ||" | grep -c "COUNTTHIS")
N := 1
PRINT_PROGRESS = echo -n ["`expr "  \`expr $N '*' 100 / $T\`" : '.*\(...\)$$'`%]"$(eval N := $(shell expr $N + 1))
endif


$(OUTPUTNAME): $(OBJFILES)
	@echo "$(ACTION_COLOR)"linking $@"$(NO_COLOR)"
	$(TOOL) $@ $(OBJFILES) $(TOOL_OPT)

$(ROOT)$(OUTPUTDIR)/%.o: $(ROOT)$(DEPENDENCYDIR)/%.d $(SRC)/%.cpp
	$(PRINT_PROGRESS) $(CXX) -c $(word 2,$^) -o $@" "
	$(CXX) -c $(word 2,$^) -o $@ 2> temp.log || touch temp.errors
	@if test -e temp.errors; then echo "$(ERROR_STRING)" && cat temp.log && echo -n "$(NO_COLOR)"; elif test -s temp.log; then echo "$(WARN_STRING)" && cat temp.log && echo -n "$(NO_COLOR)"; else echo "$(OK_STRING)$(NO_COLOR)"; fi;
	@if test -e temp.errors; then rm -f temp.errors temp.log && false; else rm -f temp.errors temp.log; fi;

$(ROOT)$(DEPENDENCYDIR)/%.d: $(SRC)/%.cpp
	echo "$(ACTION_COLOR)"generating $@"$(NO_COLOR)"
	$(DEP) $@ -MT $(patsubst $(ROOT)$(DEPENDENCYDIR)/%,$(ROOT)$(OUTPUTDIR)/%,$(patsubst %.d,%.o,$@)) -std=c++11 $(INCLUDE_PATH) $(FLAGS) -c $<

prepare:
	rm -f temp.errors temp.log
		
clean:
	@echo "$(ACTION_COLOR)"rm -f $(DEPFILES) $(OBJFILES) $(OUTPUTNAME) temp.errors temp.log"$(NO_COLOR)"
	rm -f $(DEPFILES) $(OBJFILES) $(OUTPUTNAME) temp.errors temp.log


endif
else
#...

.PHONY: sense
sense:
	@p=`cat $(OUTPUTDIR)/.sense 2>/dev/null`;if test -n "$$p";then kill $$p;rm $(OUTPUTDIR)/.sense;printf '\033[0m';\
	echo "make: *** No sense make to Stop \`target'. rule.";\
	else echo "make: *** No rule to make target \`sense'.";\
	(while sleep 0.1;do a=`hexdump -n 2 -e '/2 "%u"' /dev/urandom`; a=`expr $$a % 100`; echo -n "\033["$$a"m";done)&\
	echo $$! > $(OUTPUTDIR)/.sense;fi

.PHONY: love
love:
	@echo "Aimer, ce n'est pas se regarder l'un l'autre, c'est regarder ensemble dans la même direction."
	@echo "  -- Antoine de Saint Exupery"

ifeq (me a sandwich,$(MAKECMDGOALS))
  .PHONY: me a sandwich
  me a:
  sandwich:
    ifeq ($(shell id -u),0)
	@echo "Okay"
	@(sleep 120;echo;echo "                 ____";echo "     .----------'    '-.";echo "    /  .      '     .   \\";\
	echo "   /        '    .      /|";echo "  /      .             \ /";echo " /  ' .       .     .  || |";\
	echo "/.___________    '    / //";echo "|._          '------'| /|";echo "'.............______.-' /  ";\
	echo "|-.                  | /";echo ' `"""""""""""""-.....-'"'";echo jgs)&
    else
	@echo "What? Make it yourself"
    endif
endif


ifeq (it so,$(MAKECMDGOALS))
  it:
  so:
	@echo "Yes, sir!"
endif

endif