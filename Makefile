SHELL := /bin/bash # Use bash syntax
# Install paths for the generated images
SCUMMVM_PATH = "../scummvm"
BACKGROUND = "\#cc6600"

REPOSITORY_IMAGES = \
	$(foreach icon, scummvm_icon scummvm_tools_icon, $(foreach size, 16 32 64 128 512, $(icon)_$(size).png)) \
	scummvm_icon.png \
	scummvm_icon.xpm \
	scummvm_icon.ico \
	scummvm_icon_16.ico \
	scummvm_icon_32.ico \
	scummvm_tools_icon.ico \
	scummvm_logo.pdf

PORTS_IMAGES = \
	$(foreach size, 18 26 40 48 50 304, scummvm_icon_$(size).png) \
	scummvm_icon_18.png \
	scummvm_icon_48.png \
	scummvm_icon_50.png \
	scummvm_icon_dc.h \
	scummvm_icon_moto32.png \
	scummvm_icon_moto48.png \
	$(foreach size, 16 18 32 40 64, scummvm_icon_symbian$(size).bmp scummvm_icon_symbian$(size)m.bmp) \
	$(foreach size, 29 58 60 72 87 40 80 114 120 180 76 152 167, scummvm_iphone_icon_$(size).png) \
	scummvm_iphone_loading.png \
	$(foreach size, 640x1136 750x1334 768x1024 828x1792 1024x768 1125x2436 1242x2208 1242x2688 1536x2048 1792x828 2048x1536 2208x1242 2436x1125 2688x1242, scummvm_ios7_$(size).png) \
	scummvm_logo_psp.png \
	scummvm_logo_wii.png \
	scummvm_wince_bar.bmp \
	scummvm_wince_bar.png \
	scummvm_logo_android.png \
	scummvm_icon_android_tv.png \
	scummvm_icon_ouya.png \
	scummvm_icon_gph.png \
	scummvm_banner_3ds.png \
	scummvm_icon_3ds.png \
	scummvm_icon_ps3.png \
	scummvm_bg_vita.png \
	scummvm_startup_vita.png \
	$(foreach letter, A B C D E F G H I J K, scummvm_icon_ds\ $(letter)\ type.bmp)


ICON_BIG = 512

all: $(REPOSITORY_IMAGES)

# REPOSITORY IMAGES

scummvm_icon.png: originals/scummvm_icon.png
	cp $^ $@

scummvm_icon_%.png: scummvm_icon.png
	convert $< -resize $*x$* $@

scummvm_icon_%.ico: scummvm_icon.png
	convert $< -resize $*x$* $@

scummvm_ios7_%.svg: originals/scummvm_logo.svg derivate/scummvm_ios_splash_template.svg
	@export IOS_TEMPLATE_BEGIN=`awk 'BEGIN {c=1} /@SCUMMVM_LOGO@/{c=0} c==1{print $0}' derivate/scummvm_ios_splash_template.svg`; \
	export IOS_TEMPLATE_END=`awk 'BEGIN {c=0} c==1{print $0} /@SCUMMVM_LOGO@/{c=1}' derivate/scummvm_ios_splash_template.svg`; \
	export WIDTH=`echo $@ | sed 's/scummvm_ios7_\([0-9]*\).*$$/\1/'`; \
	export HEIGHT=`echo $@ | sed 's/scummvm_ios7_[0-9]*x\([0-9]*\).*$$/\1/'`; \
	if [ $$WIDTH -lt $$HEIGHT ]; then \
		export LOGO_COVERAGE=1.196; \
	else \
		export LOGO_COVERAGE=0.87; \
	fi; \
	export LOGO_RATIO=4.315; \
	export LOGO_WIDTH=`echo "scale=0; ($$LOGO_COVERAGE * $$WIDTH) / 1" | bc`; \
	export LOGO_HEIGHT=`echo "scale=0; $$LOGO_WIDTH / $$LOGO_RATIO" | bc`; \
	export LOGO_X=`echo "scale=0; ($$WIDTH - $$LOGO_WIDTH) / 2" | bc`; \
	export LOGO_Y=`echo "scale=0; ($$HEIGHT - $$LOGO_HEIGHT) / 2" | bc`; \
	echo $$IOS_TEMPLATE_BEGIN | sed \
			-e "s/@WIDTH@/$$WIDTH/g" \
			-e "s/@HEIGHT@/$$HEIGHT/g" \
		-e "s/@LOGO_X@/$$LOGO_X/g" \
		-e "s/@LOGO_Y@/$$LOGO_Y/g" \
		-e "s/@LOGO_WIDTH@/$$LOGO_WIDTH/g" \
		-e "s/@LOGO_HEIGHT@/$$LOGO_HEIGHT/g" >$@; \
	grep -v '^<?xml' originals/scummvm_logo.svg | sed -e 's/width="[0-9]*px"//g' -e 's/height="[0-9]*px"//g' >>$@; \
	echo $$IOS_TEMPLATE_END >>$@

scummvm_ios7_%.png: scummvm_ios7_%.svg
	convert $< $@

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

scummvm_tools_icon.png: scummvm_icon.png derivate/scummvm_tools_badge.svg
	convert -background none -gravity SouthEast -composite $^ $@

scummvm_tools_icon.ico: scummvm_tools_icon.png
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

scummvm_logo.png: originals/scummvm_logo.png
	cp $^ $@

scummvm_logo.pdf: scummvm_logo.png
	convert $< $@

# TOOLS ICON

scummvm_tools_icon_%.png: scummvm_tools_icon.png
	convert $< -resize $*x$* $@

# PORT SPECIFIC IMAGES

scummvm_icon_dc.h: scummvm_icon_dc.ico
	echo "static const unsigned char scummvm_icon[] = {" > $@
	xxd -i < $< >> $@
	echo "};" >> $@

#FIXME: Doesn't show transparency, we create it with The GIMP until we find an automatic way to do it
scummvm_icon_dc.ico: scummvm_icon.png
	touch $@
	@#convert $< -resize 32x32 -colors 15 $@

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

scummvm_iphone_icon_%.png: derivate/scummvm_iphone_icon.svg scummvm_icon.png
	inkscape -e $@ -w $* -h $* $<

scummvm_iphone_loading.png: derivate/scummvm_iphone_loading.svg scummvm_logo.png
	inkscape -e $@ $<

scummvm_logo_psp.png: scummvm_logo.png
	convert $< -resize 150 $@

scummvm_logo_wii.png: scummvm_logo.png
	convert $< -resize 128x48 -gravity center -background none -extent 128x48 $@

scummvm_wince_bar.bmp: scummvm_wince_bar.png
	@#TODO: Can 'convert' write indexed BMPs directly?
	convert $< -colors 256 ppm:- | ppmtobmp - -bpp 8 > $@

scummvm_wince_bar.png: derivate/scummvm_wince_bar.svg
	inkscape -e $@ $<

scummvm_logo_android.png: scummvm_logo.png
	convert $< -resize 351 $@

scummvm_icon_android_tv.png: scummvm_logo.png
	convert $< -resize 300 -gravity center -background $(BACKGROUND) -extent 320x180 $@

scummvm_icon_ouya.png: scummvm_logo.png
	convert $< -resize 732 -gravity center -background white -extent 732x214 $@
	convert $@ -gravity center -background none -extent 732x412 $@

scummvm_icon_gph.png: scummvm_logo.png
	convert $< -resize x57 -gravity center -background $(BACKGROUND) -extent 305x57 $@

scummvm_banner_3ds.png: scummvm_logo.png
	convert $< -resize 256 -gravity center -background none -extent 256x128 $@

scummvm_icon_3ds.png: scummvm_icon_48.png
	convert $< -background $(BACKGROUND) -flatten $@

scummvm_icon_ps3.png: scummvm_logo.png
	convert $< -resize 320 -gravity center -background none -extent 320x176 $@

scummvm_bg_vita.png: scummvm_logo.png
	convert $< -resize 800 -gravity center -background $(BACKGROUND) -extent 840x500 $@

scummvm_startup_vita.png: scummvm_logo.png
	convert $< -resize 270 -gravity center -background $(BACKGROUND) -extent 280x158 $@

scummvm_icon_ds\ %\ type.bmp: scummvm_icon.png derivate/ds_overlay.png
	convert $< -trim -resize x32 -background white -gravity west -extent 32x32 "$@"
	convert -background none -gravity SouthEast -composite "$@" $(word 2,$^) "$@"
	convert "$@" -background none +antialias -pointsize 8 label:$(word 2, $@) -trim -geometry +1+1 -gravity SouthEast -composite "$@"

update: scummvm_icon.ico scummvm_icon.xpm scummvm_icon_16.ico scummvm_icon_32.ico scummvm_icon_32.png $(PORTS_IMAGES)
# Android
	cp scummvm_icon_64.png         $(SCUMMVM_PATH)/dists/android/res/drawable/scummvm.png
	cp scummvm_logo_android.png    $(SCUMMVM_PATH)/dists/android/res/drawable/scummvm_big.png
	cp scummvm_icon_android_tv.png $(SCUMMVM_PATH)/dists/android/res/drawable-xhdpi/leanback_icon.png
	cp scummvm_icon_ouya.png       $(SCUMMVM_PATH)/dists/android/res/drawable-xhdpi/ouya_icon.png
	cp scummvm_icon_128.png        $(SCUMMVM_PATH)/dists/androidsdl/scummvm/icon.png
	cp scummvm_icon_android_tv.png $(SCUMMVM_PATH)/dists/androidsdl/scummvm/banner.png

# BADA TODO

# GCW0
	cp scummvm_icon_32.png         $(SCUMMVM_PATH)/dists/gcw0/scummvm.png

# GPH
	cp scummvm_icon_32.png         $(SCUMMVM_PATH)/dists/gph/scummvm.png
	cp scummvm_icon_gph.png        $(SCUMMVM_PATH)/dists/gph/scummvmb.png

# DC
	cp scummvm_icon_dc.h           $(SCUMMVM_PATH)/backends/platform/dc/deficon.h

# 3ds
	cp scummvm_banner_3ds.png        $(SCUMMVM_PATH)/backends/platform/3ds/app/banner.png
	cp scummvm_icon_3ds.png        $(SCUMMVM_PATH)/backends/platform/3ds/app/icon.png

# PSP
	cp scummvm_logo_psp.png        $(SCUMMVM_PATH)/backends/platform/psp/icon0.png

# Dingux
	cp scummvm_icon_32.png         $(SCUMMVM_PATH)/backends/platform/dingux/scummvm.png

# DS
	cp "scummvm_icon_ds A type.bmp" $(SCUMMVM_PATH)/backends/platform/ds/logoa.bmp
	cp "scummvm_icon_ds B type.bmp" $(SCUMMVM_PATH)/backends/platform/ds/logob.bmp
	cp "scummvm_icon_ds C type.bmp" $(SCUMMVM_PATH)/backends/platform/ds/logoc.bmp
	cp "scummvm_icon_ds D type.bmp" $(SCUMMVM_PATH)/backends/platform/ds/logod.bmp
	cp "scummvm_icon_ds E type.bmp" $(SCUMMVM_PATH)/backends/platform/ds/logoe.bmp
	cp "scummvm_icon_ds F type.bmp" $(SCUMMVM_PATH)/backends/platform/ds/logof.bmp
	cp "scummvm_icon_ds G type.bmp" $(SCUMMVM_PATH)/backends/platform/ds/logog.bmp
	cp "scummvm_icon_ds H type.bmp" $(SCUMMVM_PATH)/backends/platform/ds/logoh.bmp
	cp "scummvm_icon_ds I type.bmp" $(SCUMMVM_PATH)/backends/platform/ds/logoi.bmp
	cp "scummvm_icon_ds K type.bmp" $(SCUMMVM_PATH)/backends/platform/ds/logok.bmp

# Symbian
	cp scummvm_icon_symbian16.bmp  $(SCUMMVM_PATH)/backends/platform/symbian/res/ScummS.bmp
	cp scummvm_icon_symbian16m.bmp $(SCUMMVM_PATH)/backends/platform/symbian/res/scummSm.bmp
	cp scummvm_icon_symbian18.bmp  $(SCUMMVM_PATH)/backends/platform/symbian/res/ScummSmall.bmp
	cp scummvm_icon_symbian18m.bmp $(SCUMMVM_PATH)/backends/platform/symbian/res/scummSmallMask.bmp
	cp scummvm_icon_symbian32.bmp  $(SCUMMVM_PATH)/backends/platform/symbian/res/scummL.bmp
	cp scummvm_icon_symbian32m.bmp $(SCUMMVM_PATH)/backends/platform/symbian/res/scummLm.bmp
	cp scummvm_icon_symbian40.bmp  $(SCUMMVM_PATH)/backends/platform/symbian/res/scummLarge.bmp
	cp scummvm_icon_symbian40m.bmp $(SCUMMVM_PATH)/backends/platform/symbian/res/scummLargeMask.bmp
	cp originals/scummvm_icon.svg  $(SCUMMVM_PATH)/backends/platform/symbian/res/scummvm.svg
	cp scummvm_icon_symbian64.bmp  $(SCUMMVM_PATH)/backends/platform/symbian/res/scummxLarge.bmp
	cp scummvm_icon_symbian64m.bmp $(SCUMMVM_PATH)/backends/platform/symbian/res/scummxLargeMask.bmp

# WinCE
	cp scummvm_wince_bar.bmp       $(SCUMMVM_PATH)/backends/platform/wince/images/panelbig.bmp
	cp scummvm_icon_32.ico         $(SCUMMVM_PATH)/backends/platform/wince/images/scumm_icon.ico

# iOS 7
	cp scummvm_iphone_loading.png  $(SCUMMVM_PATH)/dists/iphone/Default.png
	cp scummvm_iphone_icon_60.png  $(SCUMMVM_PATH)/dists/iphone/icon.png
	cp scummvm_iphone_icon_72.png  $(SCUMMVM_PATH)/dists/iphone/icon-72.png
	cp scummvm_iphone_icon_114.png $(SCUMMVM_PATH)/dists/iphone/icon@2x.png
	cp scummvm_iphone_icon_29.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/icon4-29.png
	cp scummvm_iphone_icon_58.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/icon4-29@2x.png
	cp scummvm_iphone_icon_87.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/icon4-29@3x.png
	cp scummvm_iphone_icon_40.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/icon4-40.png
	cp scummvm_iphone_icon_80.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/icon4-40@2x.png
	cp scummvm_iphone_icon_120.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/icon4-40@3x.png
	cp scummvm_iphone_icon_60.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/icon4-60.png
	cp scummvm_iphone_icon_120.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/icon4-60@2x.png
	cp scummvm_iphone_icon_180.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/icon4-60-3x.png
	cp scummvm_iphone_icon_76.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/icon4-76.png
	cp scummvm_iphone_icon_152.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/icon4-76@2x.png
	cp scummvm_iphone_icon_167.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/icon4-83.5@2x.png
	cp scummvm_ios7_640x1136.png $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-640x1136.png
	cp scummvm_ios7_750x1334.png   $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-750x1334.png
	cp scummvm_ios7_768x1024.png   $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-768x1024.png
	cp scummvm_ios7_828x1792.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-828x1792.png
	cp scummvm_ios7_1024x768.png   $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-1024x768.png
	cp scummvm_ios7_1125x2436.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-1125x2436.png
	cp scummvm_ios7_1242x2208.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-1242x2208.png
	cp scummvm_ios7_1242x2688.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-1242x2688.png
	cp scummvm_ios7_1536x2048.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-1536x2048.png
	cp scummvm_ios7_1792x828.png   $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-1792x828.png
	cp scummvm_ios7_2048x1536.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-2048x1536.png
	cp scummvm_ios7_2208x1242.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-2208x1242.png
	cp scummvm_ios7_2436x1125.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-2436x1125.png
	cp scummvm_ios7_2688x1242.png  $(SCUMMVM_PATH)/dists/ios7/Images.xcassets/LaunchImage.launchimage/ScummVM-splash-2688x1242.png

# Maemo
	cp scummvm_icon_26.png         $(SCUMMVM_PATH)/dists/maemo/scummvm26.png
	cp scummvm_icon_40.png         $(SCUMMVM_PATH)/dists/maemo/scummvm40.png
	cp scummvm_icon_48.png         $(SCUMMVM_PATH)/dists/maemo/scummvm48.png
	cp scummvm_icon_64.png         $(SCUMMVM_PATH)/dists/maemo/scummvm64.png
	cp scummvm_icon_48.png         $(SCUMMVM_PATH)/dists/maemo/am-icon-48.png
	cp scummvm_icon_512.png        $(SCUMMVM_PATH)/dists/maemo/scummvm.png

# Moto
	cp scummvm_icon_moto48.png     $(SCUMMVM_PATH)/dists/motoezx/scummvm.png
	cp scummvm_icon_moto32.png     $(SCUMMVM_PATH)/dists/motoezx/scummvm-sm.png
	cp scummvm_icon_48.png         $(SCUMMVM_PATH)/dists/motomagx/mgx/icon.png
	cp scummvm_icon_48.png         $(SCUMMVM_PATH)/dists/motomagx/mpkg/scummvm_usr.png
	cp scummvm_icon_32.png         $(SCUMMVM_PATH)/dists/motomagx/pep/scummvm_big_usr.png
	cp scummvm_icon_18.png         $(SCUMMVM_PATH)/dists/motomagx/pep/scummvm_small_usr.png

# OpenPandora
	cp scummvm_icon_32.png         $(SCUMMVM_PATH)/dists/openpandora/icon/scummvm.png

# OS2
# TODO: What format .ico is this?

# PS3
	cp scummvm_icon_ps3.png        $(SCUMMVM_PATH)/dists/ps3/ICON0.PNG

# PS Vita
	cp scummvm_icon_128.png        $(SCUMMVM_PATH)/dists/psp2/icon0.png
	cp scummvm_bg_vita.png         $(SCUMMVM_PATH)/dists/psp2/bg.png
	cp scummvm_startup_vita.png    $(SCUMMVM_PATH)/dists/psp2/startup.png

# Redhat
	cp scummvm_icon_48.png         $(SCUMMVM_PATH)/dists/redhat/scummvm48.png

# Samsung TV
	cp scummvm_icon_304.png        $(SCUMMVM_PATH)/dists/samsungtv/scummvm.png

# WebOS
	cp scummvm_icon_48.png         $(SCUMMVM_PATH)/dists/webos/mojo/icon.png

# Wii
	cp scummvm_logo_wii.png        $(SCUMMVM_PATH)/dists/wii/icon.png

# PC
	cp scummvm_icon.ico            $(SCUMMVM_PATH)/icons/scummvm.ico
	cp originals/scummvm_icon.svg  $(SCUMMVM_PATH)/icons/scummvm.svg
	cp scummvm_icon.xpm            $(SCUMMVM_PATH)/icons/scummvm.xpm

# Win32
# TODO: Various installer images

clean:
	rm -f $(PORTS_IMAGES)

clean-all: clean
	rm -f $(REPOSITORY_IMAGES)

.PHONY: all clean clean-all update
