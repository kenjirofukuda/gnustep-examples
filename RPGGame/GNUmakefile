# @see https://www.gnustep.org/nicola/Tutorials/Renaissance/node4.html

include $(GNUSTEP_MAKEFILES)/common.make

APP_NAME = RPGGame
$(APP_NAME)_OBJC_FILES = Sources/RPGGame.m \
	Sources/GameView.m \
	Sources/Checker.m \
	Sources/Entity.m \
	Sources/Tile.m \
	Sources/Object.m \
	Sources/AssetSetter.m

$(APP_NAME)_HEADER_FILES = \
	Sources/GameView.h \
	Sources/Checker.h \
	Sources/Entity.h \
	Sources/Tile.h \
	Sources/Object.h \
	Sources/AssetSetter.h

$(APP_NAME)_RESOURCE_FILES = \
  Menu-GNUstep.gsmarkup \
  Menu-OSX.gsmarkup \
  Window.gsmarkup

$(APP_NAME)_RESOURCE_FILES += Resources/Walking-sprites
$(APP_NAME)_RESOURCE_FILES += Resources/Tiles
$(APP_NAME)_RESOURCE_FILES += Resources/Maps
$(APP_NAME)_RESOURCE_FILES += Resources/Objects

$(APP_NAME)_LOCALIZED_RESOURCE_FILES = \
  Window.strings
$(APP_NAME)_LANGUAGES = Italian

ifeq ($(FOUNDATION_LIB), apple)
  ADDITIONAL_INCLUDE_DIRS += -framework Renaissance
  ADDITIONAL_GUI_LIBS += -framework Renaissance
else
  ADDITIONAL_GUI_LIBS += -lRenaissance
endif

include $(GNUSTEP_MAKEFILES)/application.make

# openapp ./$(APP_NAME).app -NSLanguages '(Italian)'
