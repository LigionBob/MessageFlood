INSTALL_TARGET_PROCESSES = MobileSMS

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MessageFlood

MessageFlood_FILES = Tweak.x
MessageFlood_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
