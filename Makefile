GENERATED_IMAGES=scummvm_icon_big.png scummvm_16.png scummvm_32.png scummvm_128.png scummvm.xpm

icons: $(GENERATED_IMAGES)

scummvm_icon_big.png: scummvm_icon.svg
	inkscape -e $@ -w 256 -h 256 $<

scummvm_%.png: scummvm_icon_big.png
	convert $< -resize $*x$* $@

scummvm.xpm: scummvm_icon_big.png
	convert $< -resize 32x32 $@

clean:
	rm -f $(GENERATED_IMAGES)

.PHONY: icons clean
