TARGET= main.pdf print.pdf
SRC=	main.tex intro.tex readme.tex outro.tex
INCLUDE=	$(shell grep '\(\\includegraphics\|\\lstinputlisting\)' $(SRC) | sed -n 's/.*{\(.*\)}.*/\1/p')

LATEXMK= docker run --rm -v .:/workdir texlive/texlive:latest latexmk
REVID=	$(shell git rev-parse --short main 2>/dev/null || echo xxxxxx)

SUBDIRS= cover

main: main.pdf
print: print.pdf
all: $(TARGET)
main.pdf:  $(SUBDIRS) $(SRC)           $(INCLUDE) revid.tex cover/cover.png
print.pdf: $(SUBDIRS) $(SRC) print.tex $(INCLUDE) revid.tex cover/print.png

revid.tex::
	echo '\\def\\revid{$(REVID)}' > tmp.$@
	cmp tmp.$@ $@ 2>/dev/null && rm tmp.$@ || mv tmp.$@ $@

.PHONY: all main print clean $(SUBDIRS)
$(SUBDIRS):
	make -C $@
clean:
	rm revid.tex
	$(LATEXMK) -C

.SUFFIXES: .tex .pdf
.tex.pdf:
	$(LATEXMK) $<
