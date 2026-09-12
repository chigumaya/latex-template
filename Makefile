TARGET= main.pdf print.pdf
SRC=	main.tex intro.tex chapter1.tex outro.tex
INCLUDE=	$(shell grep '\(\\includegraphics\|\\lstinputlisting\)' $(SRC) | sed -n 's/.*{\(.*\)}.*/\1/p')

LATEXMK= docker run --rm -v .:/workdir texlive/texlive:latest latexmk
REVID=	$(shell git rev-parse --short main 2>/dev/null || echo xxxxxx)

SUBDIRS= cover

main: $(SUBDIRS) main.pdf
print: $(SUBDIRS) print.pdf
all: $(SUBDIRS) $(TARGET)
main.pdf: $(SRC) $(INCLUDE) revid.tex cover/cover.png
print.pdf: print.tex $(SRC) $(INCLUDE) revid.tex cover/print.png

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
