SVGCONV= rsvg-convert
CONVERT= magick

all: cover.png print.png
cover.png: cover.svg
	$(SVGCONV) $< | $(CONVERT) - -crop 1480x2100+30+30 $@
print.png: cover.svg
	$(SVGCONV) $< | $(CONVERT) - -colorspace gray $@
