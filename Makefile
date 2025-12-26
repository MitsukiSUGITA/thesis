UNAME = $(shell uname)

ifeq ($(UNAME),Darwin)
	VIEWER	= /usr/bin/open
else
	VIEWER  = /usr/bin/xdg-open
endif

TEX=lualatex
#TEX=luajittex --fmt=luajitlatex.fmt
DVI2PDF=dvipdfmx
BIBTEX=pbibtex
TEX_FLAGS= --shell-escape -interaction=batchmode

TARGET=thesis

COUNT=3

MAIN = main.tex
SOURCE = $(wildcard *.tex)

.SUFFIXES: .tex .pdf
.PHONY: all semi-clean clean preview

all: $(TARGET).pdf semi-clean

$(TARGET).pdf: $(SOURCE)
	@for i in `seq 1 $(COUNT)`; \
	do \
		$(TEX) $(TEX_FLAGS) $(MAIN); \
		if [ ! -e "$(MAIN:.tex=.blg)" ]; then \
			echo ""; \
			$(BIBTEX) $(basename $(MAIN)); \
		fi \
	done
	@mv $(MAIN:.tex=.pdf) $(TARGET).pdf

uplatex: $(SOURCE)
	cp $(MAIN) tmp.tex
	sed -i'' -e 's|%\\uplatextrue|\\uplatextrue|' tmp.tex
	@for i in `seq 1 $(COUNT)`; \
	do \
		uplatex $(TEX_FLAGS) tmp.tex; \
		if [ ! -e "$(SOURCE:.tex=.blg)" ]; then \
			echo -e '\n'; \
			$(BIBTEX) tmp; \
		fi \
	done
	$(DVI2PDF) tmp.dvi
	mv tmp.pdf $(TARGET).pdf
	rm tmp.*

semi-clean:
	-@rm -f *.aux *.log *.out *.lof *.lot *.toc *.fls *.blg *.xml *.bcf *blx.bib *.spl

clean: semi-clean
	-@rm -f $(TARGET).pdf $(TEXFILES)

preview:
	$(VIEWER) $(TARGET).pdf
