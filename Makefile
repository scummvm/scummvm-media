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

scummvm_logo_psp.png: scummvm_logo.png
	convert scummvm_logo.png -resize 150 scummvm_logo_psp.png

scummvm_logo_wii.png: scummvm_logo.png
	convert scummvm_logo.png -resize 128x48 -gravity Center -background none -extent 128x48 scummvm_logo_wii.png

update-trunk: scummvm_icon.ico scummvm_icon.xpm scummvm_icon_18.png scummvm_icon_32.ico scummvm_icon_32.png scummvm_icon_48.png scummvm_logo_psp.png scummvm_logo_wii.png
	cp scummvm_icon_32.png  ../../scummvm/trunk/backends/platform/gp2x/build/scummvm.png
	cp scummvm_icon_32.png  ../../scummvm/trunk/backends/platform/gp2xwiz/build/scummvm.png
	cp scummvm_logo_psp.png ../../scummvm/trunk/backends/platform/psp/icon0.png
	cp scummvm_icon_32.ico  ../../scummvm/trunk/backends/platform/wince/images/scumm_icon.ico
	cp scummvm_icon_48.png  ../../scummvm/trunk/dists/motomagx/mgx/icon.png
	cp scummvm_icon_48.png  ../../scummvm/trunk/dists/motomagx/mpkg/scummvm_usr.png
	cp scummvm_icon_32.png  ../../scummvm/trunk/dists/motomagx/pep/scummvm_big_usr.png
	cp scummvm_icon_18.png  ../../scummvm/trunk/dists/motomagx/pep/scummvm_small_usr.png
	cp scummvm_logo_wii.png ../../scummvm/trunk/dists/wii/icon.png
	cp scummvm_icon.ico     ../../scummvm/trunk/icons/scummvm.ico
	cp scummvm_icon.xpm     ../../scummvm/trunk/icons/scummvm.xpm

clean:
	rm -f $(GENERATED_IMAGES)

.PHONY: all clean update-trunk
