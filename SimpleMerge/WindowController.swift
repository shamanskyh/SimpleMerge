//
//  WindowController.swift
//  SimpleMerge
//
//  Created by Harry Shamansky on 11/23/14.
//  Copyright (c) 2014 Harry Shamansky. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    @IBOutlet var mergeButton: NSToolbarItem!
    @IBOutlet var mergeSendButton: NSToolbarItem!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.

    }
    
    override func validateToolbarItem(theItem: NSToolbarItem) -> Bool {
        // disable the merge buttons if CSV hasn't loaded yet
        
        if (NSApplication.sharedApplication().delegate as! AppDelegate).didLoadCSV || theItem.tag == 1 {
            return true
        } else {
            return false
        }
    }
    
    
    // MARK: Toolbar Items
    
    // addCSV loads Cocoa's open panel and passes the URL of the CSV file to the ViewController
    @IBAction func addCSV(sender: AnyObject?) {
        let fileTypes = ["csv"]
        
        let oPanel = NSOpenPanel()
        var startingDir: String? = NSUserDefaults.standardUserDefaults().objectForKey("StartingDirectory") as? String
        
        if (startingDir == nil) {
            startingDir = NSHomeDirectory()
        }
        
        oPanel.allowsMultipleSelection = false
        oPanel.allowedFileTypes = fileTypes
        
        oPanel.beginSheetModalForWindow(self.window!, completionHandler: { (returnCode: Int) in
            if returnCode == NSOKButton {
                (self.contentViewController as! ViewController).importCSV(oPanel.URLs)
                (NSApplication.sharedApplication().delegate as! AppDelegate).didLoadCSV = true
                self.validateToolbarItem(self.mergeButton)
                self.validateToolbarItem(self.mergeSendButton)
            }
        })
    }
    
    
    // merge calls the ViewController's merge method
    @IBAction func merge(sender: AnyObject?) {
        (self.contentViewController as! ViewController).merge(false)
    }
    
    // mergeAndSend calls the ViewController's mergeAndSend method
    @IBAction func mergeAndSend(sender: AnyObject?) {
        (self.contentViewController as! ViewController).merge(true)
    }
    
}
