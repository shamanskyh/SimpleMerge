//
//  AppDelegate.swift
//  SimpleMerge
//
//  Created by Harry Shamansky on 11/23/14.
//  Copyright (c) 2014 Harry Shamansky. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var didLoadCSV: Bool = false

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    // MARK: Menu Items
    @IBAction func loadCSV(sender: NSMenuItem) {
        (NSApplication.sharedApplication().mainWindow?.windowController() as WindowController).addCSV(sender)
    }
    
    @IBAction func merge(sender: NSMenuItem) {
        (NSApplication.sharedApplication().mainWindow?.windowController() as WindowController).merge(sender)
    }
    
    @IBAction func mergeAndSend(sender: NSMenuItem) {
        (NSApplication.sharedApplication().mainWindow?.windowController() as WindowController).mergeAndSend(sender)
    }
    
    override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
        if didLoadCSV || menuItem.tag == 1 {
            return true
        } else {
            return false
        }
    }

}

