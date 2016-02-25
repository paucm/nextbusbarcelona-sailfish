# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = next-bus-barcelona

CONFIG += sailfishapp

SOURCES += src/next-bus-barcelona.cpp

OTHER_FILES += qml/next-bus-barcelona.qml \
    qml/cover/CoverPage.qml \
    rpm/next-bus-barcelona.changes.in \
    rpm/next-bus-barcelona.spec \
    rpm/next-bus-barcelona.yaml \
    translations/*.ts \
    next-bus-barcelona.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/next-bus-barcelona-es.ts
TRANSLATIONS += translations/next-bus-barcelona-en.ts
TRANSLATIONS += translations/next-bus-barcelona-ca.ts

DISTFILES += \
    qml/SearchPage.qml \
    qml/StopPage.qml \
    qml/TmbService.js \
    qml/CoverPage.qml \
    qml/Database.js \
    qml/BusyModal.qml

