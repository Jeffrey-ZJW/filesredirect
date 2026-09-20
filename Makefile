ARCHS = arm64
TARGET = iphone:clang:latest:12.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = filesredirect
filesredirect_FILES = Tweak.x
filesredirect_FRAMEWORKS = Foundation
filesredirect_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/tweak.mk
