TARGET= main.pdf print.pdf
SRC=	main.tex intro.tex chapter1.tex outro.tex
INCLUDE=	$(shell grep '\(\\includegraphics\|\\lstinputlisting\)' $(SRC) | sed -n 's/.*{\(.*\)}.*/\1/p')

LATEXMK= docker run --rm -v .:/workdir texlive/texlive:latest latexmk
REVID=	$(shell git rev-parse --short main 2>/dev/null || echo xxxxxx)

SUBDIRS= 

main: $(SUBDIRS) main.pdf
print: $(SUBDIRS) print.pdf
all: $(SUBDIRS) $(TARGET)
main.pdf: $(SRC) $(INCLUDE) revid.tex
print.pdf: print.tex $(SRC) $(INCLUDE) revid.tex

revid.tex::
	echo '\\def\\revid{$(REVID)}' > tmp.$@
	cmp tmp.$@ $@ && rm tmp.$@ || mv tmp.$@ $@

.PHONY: all main print clean $(SUBDIRS)
$(SUBDIRS):
	make -C $@
clean:
	$(LATEXMK) -C
	rm revid.tex

.SUFFIXES: .tex .pdf
.tex.pdf:
	$(LATEXMK) $<
