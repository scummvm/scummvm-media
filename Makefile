REPOSITORY_IMAGES=$(foreach icon, scummvm_icon scummvm_tools_icon, $(foreach size, 16 32 128, $(icon)_$(size).png)) scummvm_icon.png scummvm_icon.xpm scummvm_icon.ico scummvm_icon_16.ico scummvm_icon_32.ico
PORTS_IMAGES=scummvm_icon_18.png scummvm_icon_48.png scummvm_icon_50.png scummvm_icon_dc.h scummvm_icon_moto32.png scummvm_icon_moto48.png $(foreach size, 16 18 32 40 64, scummvm_icon_symbian$(size).bmp scummvm_icon_symbian$(size)m.bmp) scummvm_iphone_icon.png scummvm_iphone_loading.png scummvm_logo_psp.png scummvm_logo_wii.png scummvm_logo_wiki.png scummvm_web_link.png scummvm_wince_bar.bmp scummvm_wince_bar.png
ICON_BIG=512

all: $(REPOSITORY_IMAGES)

# REPOSITORY IMAGES

scummvm_icon.png: originals/scummvm_icon.svg
	inkscape -e $@ -w $(ICON_BIG) -h $(ICON_BIG) $<

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

# PORT SPECIFIC IMAGES

scummvm_icon_dc.h: scummvm_icon_dc.ico
	echo "static const unsigned char scummvm_icon[] = {" > $@
	xxd -i < $< >> $@
	echo "};" >> $@

#FIXME: Doesn't show transparency, we create it with The GIMP until we find an automatic way to do it
#scummvm_icon_dc.ico: scummvm_icon.png
	@#convert $< -resize 32x32 -colors 16 $@

scummvm_icon_moto32.png: scummvm_icon.png
	convert $< -resize 32x24 -gravity Center -background none -extent 32x24 $@

scummvm_icon_moto48.png: scummvm_icon.png
	convert $< -resize 48x32 -gravity Center -background none -extent 48x32 $@

scummvm_icon_symbian16.bmp: scummvm_icon.png
	convert $< -resize 16x16 -background black -flatten ppm:- | ppmtobmp - -bpp 24 > $@

scummvm_icon_symbian16m.bmp: scummvm_icon.png
	convert $< -resize 16x16 -alpha extract -threshold 0 -negate ppm:- | ppmtobmp - -bpp 4 > $@

scummvm_icon_symbian18.bmp: scummvm_icon.png
	convert $< -resize 18x18 -background black -flatten ppm:- | ppmtobmp - -bpp 24 > $@

scummvm_icon_symbian18m.bmp: scummvm_icon.png
	convert $< -resize 18x18 -alpha extract -threshold 0 ppm:- | ppmtobmp - -bpp 4 > $@

scummvm_icon_symbian32.bmp: scummvm_icon.png
	convert $< -resize 32x32 -background black -flatten -colors 256 ppm:- | ppmtobmp - -bpp 8 > $@

scummvm_icon_symbian32m.bmp: scummvm_icon.png
	convert $< -resize 32x32 -alpha extract -threshold 0 -negate ppm:- | ppmtobmp - -bpp 4 > $@

scummvm_icon_symbian40.bmp: scummvm_icon.png
	convert $< -resize 40x40 -background white -flatten ppm:- | ppmtobmp - -bpp 24 > $@

scummvm_icon_symbian40m.bmp: scummvm_icon.png
	convert $< -resize 40x40 -alpha extract -threshold 0 ppm:- | ppmtobmp - -bpp 4 > $@

scummvm_icon_symbian64.bmp: scummvm_icon.png
	convert $< -resize 64x64 -background white -flatten ppm:- | ppmtobmp - -bpp 24 > $@

scummvm_icon_symbian64m.bmp: scummvm_icon.png
	convert $< -resize 64x64 -alpha extract -threshold 0 ppm:- | ppmtobmp - -bpp 4 > $@

scummvm_iphone_icon.png: derivate/scummvm_iphone_icon.svg scummvm_icon.png
	inkscape -e $@ $<

scummvm_iphone_loading.png: derivate/scummvm_iphone_loading.svg scummvm_logo.png
	inkscape -e $@ $<

scummvm_logo_psp.png: scummvm_logo.png
	convert $< -resize 150 $@

scummvm_logo_wii.png: scummvm_logo.png
	convert $< -resize 128x48 -gravity Center -background none -extent 128x48 $@

scummvm_logo_wiki.png: scummvm_logo.png
	convert $< -resize 210x65 -gravity Center -background none -extent 200x58 $@

scummvm_web_link.png: derivate/scummvm_web_link.svg
	inkscape -e $@ $<

scummvm_wince_bar.bmp: scummvm_wince_bar.png
	@#TODO: Can 'convert' write indexed BMPs directly?
	convert $< -colors 256 ppm:- | ppmtobmp - -bpp 8 > $@

scummvm_wince_bar.png: derivate/scummvm_wince_bar.svg
	inkscape -e $@ $<

update: scummvm_icon.ico scummvm_icon.xpm scummvm_icon_32.ico scummvm_icon_32.png $(PORTS_IMAGES)
	cp scummvm_icon_dc.h           ../../scummvm/trunk/backends/platform/dc/deficon.h
	cp scummvm_icon_32.png         ../../scummvm/trunk/backends/platform/gp2x/build/scummvm.png
	cp scummvm_icon_32.png         ../../scummvm/trunk/backends/platform/gp2xwiz/build/scummvm.png
	cp scummvm_logo_psp.png        ../../scummvm/trunk/backends/platform/psp/icon0.png
	cp scummvm_icon_symbian16.bmp  ../../scummvm/trunk/backends/platform/symbian/res/ScummS.bmp
	cp scummvm_icon_symbian16m.bmp ../../scummvm/trunk/backends/platform/symbian/res/scummSm.bmp
	cp scummvm_icon_symbian18.bmp  ../../scummvm/trunk/backends/platform/symbian/res/ScummSmall.bmp
	cp scummvm_icon_symbian18m.bmp ../../scummvm/trunk/backends/platform/symbian/res/scummSmallMask.bmp
	cp scummvm_icon_symbian32.bmp  ../../scummvm/trunk/backends/platform/symbian/res/scummL.bmp
	cp scummvm_icon_symbian32m.bmp ../../scummvm/trunk/backends/platform/symbian/res/scummLm.bmp
	cp scummvm_icon_symbian40.bmp  ../../scummvm/trunk/backends/platform/symbian/res/scummLarge.bmp
	cp scummvm_icon_symbian40m.bmp ../../scummvm/trunk/backends/platform/symbian/res/scummLargeMask.bmp
	cp originals/scummvm_icon.svg  ../../scummvm/trunk/backends/platform/symbian/res/scummvm.svg
	cp scummvm_icon_symbian64.bmp  ../../scummvm/trunk/backends/platform/symbian/res/scummxLarge.bmp
	cp scummvm_icon_symbian64m.bmp ../../scummvm/trunk/backends/platform/symbian/res/scummxLargeMask.bmp
	cp scummvm_wince_bar.bmp       ../../scummvm/trunk/backends/platform/wince/images/panelbig.bmp
	cp scummvm_icon_32.ico         ../../scummvm/trunk/backends/platform/wince/images/scumm_icon.ico
	cp scummvm_iphone_loading.png  ../../scummvm/trunk/dists/iphone/Default.png
	cp scummvm_iphone_icon.png     ../../scummvm/trunk/dists/iphone/icon.png
	cp scummvm_icon_moto48.png     ../../scummvm/trunk/dists/motoezx/scummvm.png
	cp scummvm_icon_moto32.png     ../../scummvm/trunk/dists/motoezx/scummvm-sm.png
	cp scummvm_icon_48.png         ../../scummvm/trunk/dists/motomagx/mgx/icon.png
	cp scummvm_icon_48.png         ../../scummvm/trunk/dists/motomagx/mpkg/scummvm_usr.png
	cp scummvm_icon_32.png         ../../scummvm/trunk/dists/motomagx/pep/scummvm_big_usr.png
	cp scummvm_icon_18.png         ../../scummvm/trunk/dists/motomagx/pep/scummvm_small_usr.png
	cp scummvm_logo_wii.png        ../../scummvm/trunk/dists/wii/icon.png
	cp scummvm_icon.ico            ../../scummvm/trunk/icons/scummvm.ico
	cp originals/scummvm_icon.svg  ../../scummvm/trunk/icons/scummvm.svg
	cp scummvm_icon.xpm            ../../scummvm/trunk/icons/scummvm.xpm
	cp scummvm_web_link.png        ../../web/trunk/images/scummvm-link.png
	cp scummvm_icon_50.png         ../../web-planet/avatars/scummvm.png

clean:
	rm -f $(PORTS_IMAGES)

clean-all: clean
	rm -f $(REPOSITORY_IMAGES)

.PHONY: all clean clean-all update
