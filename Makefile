GENERATED_IMAGES=scummvm_icon_big.png scummvm_16.png scummvm_32.png scummvm_128.png scummvm.xpm scummvm.ico

icons: $(GENERATED_IMAGES)

scummvm_icon_big.png: scummvm_icon.svg
	inkscape -e $@ -w 256 -h 256 $<

scummvm_%.png: scummvm_icon_big.png
	convert $< -resize $*x$* $@

scummvm.xpm: scummvm_icon_big.png
	convert $< -resize 32x32 $@

scummvm.ico: scummvm_icon_big.png
	convert $< \
		\( -clone 0 -resize 32x32 -colors 16 \) \
		\( -clone 0 -resize 16x16 -colors 16 \) \
		\( -clone 0 -resize 48x48 -colors 256 \) \
		\( -clone 0 -resize 32x32 -colors 256 \) \
		\( -clone 0 -resize 16x16 -colors 256 \) \
		\( -clone 0 -resize 128x128 \) \
		\( -clone 0 -resize 48x48 \) \
		\( -clone 0 -resize 32x32 \) \
		\( -clone 0 -resize 16x16 \) \
		-delete 0 \
		$@

clean:
	rm -f $(GENERATED_IMAGES)

.PHONY: icons clean
