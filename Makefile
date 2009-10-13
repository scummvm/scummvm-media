REPOSITORY_IMAGES=$(foreach icon, scummvm_icon scummvm_tools_icon, $(foreach size, 16 32 128, $(icon)_$(size).png)) scummvm_icon.png scummvm_icon.xpm scummvm_icon.ico scummvm_icon_16.ico scummvm_icon_32.ico
PORTS_IMAGES=scummvm_icon_18.png scummvm_icon_48.png scummvm_logo_psp.png scummvm_logo_wii.png scummvm_logo_wince.bmp
ICON_BIG=512

all: $(REPOSITORY_IMAGES)

# MAIN ICON

#TODO: Update the SVG
#scummvm_icon_$(ICON_BIG).png: originals/scummvm_icon.svg
#	inkscape -e $@ -w $(ICON_BIG) -h $(ICON_BIG) $<

scummvm_icon_%.png: scummvm_icon.png
	convert $< -resize $*x$* $@

scummvm_icon_%.ico: scummvm_icon.png
	convert $< -resize $*x$* $@

scummvm_icon.xpm: scummvm_icon.png
	convert $< -resize 32x32 -depth 4 xpm:- | sed -e 's/static /static const /' -e 's/xpm__/scummvm_icon/' > $@

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
	convert $< -resize 150 $@

scummvm_logo_wii.png: scummvm_logo.png
	convert $< -resize 128x48 -gravity Center -background none -extent 128x48 $@

scummvm_logo_wince.bmp: scummvm_logo.png
	@#TODO: Can 'convert' write indexed BMPs directly?
	convert $< -resize 320x40 -gravity East -background black -extent 320x40 -colors 256 ppm:- | ppmtobmp - -bpp 8 > $@

update-trunk: scummvm_icon.ico scummvm_icon.xpm scummvm_icon_32.ico scummvm_icon_32.png $(PORTS_IMAGES)
	cp scummvm_icon_32.png       ../../scummvm/trunk/backends/platform/gp2x/build/scummvm.png
	cp scummvm_icon_32.png       ../../scummvm/trunk/backends/platform/gp2xwiz/build/scummvm.png
	cp scummvm_logo_psp.png      ../../scummvm/trunk/backends/platform/psp/icon0.png
	cp scummvm_logo_wince.bmp    ../../scummvm/trunk/backends/platform/wince/images/panelbig.bmp
	cp scummvm_icon_32.ico       ../../scummvm/trunk/backends/platform/wince/images/scumm_icon.ico
	cp scummvm_icon_48.png       ../../scummvm/trunk/dists/motomagx/mgx/icon.png
	cp scummvm_icon_48.png       ../../scummvm/trunk/dists/motomagx/mpkg/scummvm_usr.png
	cp scummvm_icon_32.png       ../../scummvm/trunk/dists/motomagx/pep/scummvm_big_usr.png
	cp scummvm_icon_18.png       ../../scummvm/trunk/dists/motomagx/pep/scummvm_small_usr.png
	cp scummvm_logo_wii.png      ../../scummvm/trunk/dists/wii/icon.png
	cp scummvm_icon.ico          ../../scummvm/trunk/icons/scummvm.ico
	cp scummvm_icon.xpm          ../../scummvm/trunk/icons/scummvm.xpm

clean-ports:
	rm -f $(PORTS_IMAGES)

clean:
	rm -f $(REPOSITORY_IMAGES)

.PHONY: all clean update-trunk
