TARGET = iphone:latest:13.0
ARCHS = arm64

INSTALL_TARGET_PROCESSES = MobileSMS

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MessageFlood

MessageFlood_FILES = Tweak.x
MessageFlood_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
