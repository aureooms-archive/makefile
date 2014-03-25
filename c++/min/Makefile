$(VERBOSE).SILENT:
.SECONDARY:

#PROJECT SPECIFIC

INCLUDE_PATH = -Icustom/include/path
LIBS = -lcustomlib
TYPE = [run|lib]

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

FLAGS = -Wall -W

ifeq ($(prof),true)
	ROOT := $(ROOT)prof/
	FLAGS += -pg
endif

ifeq ($(dbg),true)
	ROOT := $(ROOT)dbg/
	FLAGS += -g
endif

ifeq ($(syntax),true)
	FLAGS += -fsyntax-only
endif

FLAGS += -O3

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
LIBDIR = lib
OUTPUT_NAMES = $(patsubst $(SRC)/%.cpp,$(ROOT)$(TYPE)/%,$(shell find $(SRC) -regex .*\\.cpp | sed 's/ /\\ /g'))
OBJFILES = $(patsubst $(SRC)/%,$(ROOT)$(OUTPUTDIR)/%,$(patsubst %.cpp,%.o,$(shell find $(SRC) | grep \\.cpp$$)))
DEP = g++ -MM -MF
DEPFILES = $(patsubst $(ROOT)$(OUTPUTDIR)/%,$(ROOT)$(DEPENDENCYDIR)/%,$(patsubst %.o,%.d,$(OBJFILES)))

REQUIRED_DIRS = $(shell find $(SRC) -type d | sed s:^$(SRC):$(ROOT)$(OUTPUTDIR):)
REQUIRED_DIRS += $(shell find $(SRC) -type d | sed s:^$(SRC):$(ROOT)$(DEPENDENCYDIR):)
ifeq ($(TYPE),lib)
	REQUIRED_DIRS += $(ROOT)$(LIBDIR)
else
	REQUIRED_DIRS += $(ROOT)$(TYPE)
endif
_MKDIRS := $(shell for d in $(REQUIRED_DIRS); \
             do                               \
               [ -d $$d ] || mkdir -p $$d;  \
             done)

ifneq ($(words $(MAKECMDGOALS)),1)
.DEFAULT_GOAL = all
%:
	@$(MAKE) $@ --no-print-directory -rRf $(firstword $(MAKEFILE_LIST))
else


all: prepare $(OUTPUT_NAMES)

ifneq ($(MAKECMDGOALS),clean)
-include $(DEPFILES)
endif

ifndef PRINT_PROGRESS
T := $(shell $(MAKE) $(MAKECMDGOALS) prof=$(prof) dbg=$(dbg) --dry-run \
      -rRf $(firstword $(MAKEFILE_LIST)) \
      PRINT_PROGRESS="echo COUNTTHIS" BUILD="test x ||" | grep -c "COUNTTHIS")
N := 1
PRINT_PROGRESS = echo -n ["`expr "  \`expr $N '*' 100 / $T\`" : '.*\(...\)$$'`%]"$(eval N := $(shell expr $N + 1))
endif

$(ROOT)$(TYPE)/%: $(ROOT)$(OUTPUTDIR)/%.o
	@echo "$(ACTION_COLOR)"linking $@"$(NO_COLOR)"
	$(TOOL) $@ $^ $(TOOL_OPT)

$(ROOT)$(OUTPUTDIR)/%.o: $(ROOT)$(DEPENDENCYDIR)/%.d $(SRC)/%.cpp
	$(PRINT_PROGRESS) $(CXX) -c $(word 2,$^) -o $@" "
	$(CXX) -c $(word 2,$^) -o $@ 2> temp.log || touch temp.errors
	if [ -e temp.errors ]; then echo "$(ERROR_STRING)" && cat temp.log && echo -n "$(NO_COLOR)"; elif [ -s temp.log ]; then echo "$(WARN_STRING)" && cat temp.log && echo -n "$(NO_COLOR)"; else echo "$(OK_STRING)$(NO_COLOR)"; fi;
	if [ -e temp.errors ]; then rm -f temp.errors temp.log && false; else rm -f temp.errors temp.log; fi;

$(ROOT)$(DEPENDENCYDIR)/%.d: $(SRC)/%.cpp
	echo "$(ACTION_COLOR)"generating $@"$(NO_COLOR)"
	$(DEP) $@ -MT $(patsubst $(ROOT)$(DEPENDENCYDIR)/%,$(ROOT)$(OUTPUTDIR)/%,$(patsubst %.d,%.o,$@)) -std=c++11 $(INCLUDE_PATH) $(FLAGS) -c $<

prepare:
	rm -f temp.errors temp.log
		
clean:
	@echo "$(ACTION_COLOR)"rm -rf $(DEPFILES) $(OBJFILES) temp.errors temp.log $(REQUIRED_DIRS)"$(NO_COLOR)"
	rm -rf $(DEPFILES) $(OBJFILES) temp.errors temp.log $(REQUIRED_DIRS)


endif