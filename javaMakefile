JFLAGS = -g
JC = javac
LINK = jar cvfm

OUTPUT_NAME = dist/run.jar
SRC = src
CLASS = class
SOURCES = $(shell find $(SRC) | grep \\.java$$)
CLASSES = $(patsubst $(SRC)/%,$(CLASS)/%,$(patsubst %.java,%.class,$(SOURCES)))
MANIFEST = MANIFEST.MF

REQUIRED_DIRS = $(CLASS) dist
_MKDIRS := $(shell for d in $(REQUIRED_DIRS); \
             do                               \
               [ -d $$d ] || mkdir -p $$d;  \
             done)

.SUFFIXES: .java .class

default: all

all: $(OUTPUT_NAME)

$(OUTPUT_NAME): $(CLASSES)
	$(LINK) $(OUTPUT_NAME) $(MANIFEST) -C $(CLASS) .

$(CLASS)/%.class: $(SRC)/%.java
	$(JC) $(JFLAGS) $^ -d $(CLASS) -classpath $(SOURCES)

clean:
	$(RM) -r $(REQUIRED_DIRS)