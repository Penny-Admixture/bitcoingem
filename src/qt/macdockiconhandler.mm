// Copyright (c) 2011-2013 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include "macdockiconhandler.h"

#include <AppKit/AppKit.h>
#include <objc/runtime.h>

#if QT_VERSION < 0x050000
extern void qt_mac_set_dock_menu(QMenu *);
#endif

static MacDockIconHandler *s_instance = NULL;

bool dockClickHandler(id self, SEL _cmd, ...) {
    Q_UNUSED(self)
    Q_UNUSED(_cmd)

    Q_EMIT s_instance->dockIconClicked();

    // Return NO (false) to suppress the default macOS actions
    return false;
}

void setupDockClickHandler() {
    Class delClass = (Class)[[[NSApplication sharedApplication] delegate] class];
    SEL shouldHandle = sel_registerName("applicationShouldHandleReopen:hasVisibleWindows:");
    class_replaceMethod(delClass, shouldHandle, (IMP)dockClickHandler, "B@:");
}


MacDockIconHandler::MacDockIconHandler() : QObject()
{


    setupDockClickHandler();

}

MacDockIconHandler *MacDockIconHandler::instance()
{
    if (!s_instance)
        s_instance = new MacDockIconHandler();
    return s_instance;
}

void MacDockIconHandler::cleanup()
{
    delete s_instance;
}

/**
 * Force application activation on macOS. With Qt 5.5.1 this is required when
 * an action in the Dock menu is triggered.
 * TODO: Define a Qt version where it's no-longer necessary.
 */
void ForceActivation()
{
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}
