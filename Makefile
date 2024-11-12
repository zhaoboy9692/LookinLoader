THEOS_DEVICE_IP = 127.0.0.1
THEOS_DEVICE_PORT = 2222
THEOS_DEVICE_PASSWORD=alpine
ARCHS  = arm64 arm64e
TARGET = iphone:14.5:9.0
ADDITIONAL_OBJCFLAGS = -fobjc-arc
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LookinLoader
LookinLoader_FILES = Tweak.xm
LookinLoader_FRAMEWORKS = UIKit
LookinLoader_CFLAGS = -fobjc-arc -Wdeprecated-declarations -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
