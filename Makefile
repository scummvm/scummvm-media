GENERATED_IMAGES=$(foreach icon, scummvm_icon scummvm_tools_icon, $(foreach size, 16 32 128, $(icon)_$(size).png)) scummvm_icon.png scummvm_icon.xpm scummvm_icon.ico scummvm_icon_16.ico scummvm_icon_32.ico
ICON_BIG=512

all: $(GENERATED_IMAGES)

# MAIN ICON

#TODO: Update the SVG
#scummvm_icon_$(ICON_BIG).png: originals/scummvm_icon.svg
#	inkscape -e $@ -w $(ICON_BIG) -h $(ICON_BIG) $<

scummvm_icon_%.png: scummvm_icon.png
	convert $< -resize $*x$* $@

scummvm_icon_%.ico: scummvm_icon.png
	convert $< -resize $*x$* $@

scummvm_icon.xpm: scummvm_icon.png
	convert $< -resize 32x32 $@

scummvm_icon.ico: scummvm_icon.png
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

# TOOLS ICON

scummvm_tools_icon_%.png: scummvm_tools_icon.png
	convert $< -resize $*x$* $@

# LOGO

# For the PSP:
#convert scummvm_logo.png -resize 150 icon0.png

clean:
	rm -f $(GENERATED_IMAGES)

.PHONY: all clean
