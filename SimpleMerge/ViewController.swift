//
//  ViewController.swift
//  SimpleMerge
//
//  Created by Harry Shamansky on 11/23/14.
//  Copyright (c) 2014 Harry Shamansky. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var csvArray: [[String]] = []
    
    @IBOutlet var toNameField: NSTextField!
    @IBOutlet var toEmailField: NSTextField!
    @IBOutlet var ccNameField: NSTextField!
    @IBOutlet var ccEmailField: NSTextField!
    @IBOutlet var bccNameField: NSTextField!
    @IBOutlet var bccEmailField: NSTextField!
    @IBOutlet var subjectField: NSTextField!
    @IBOutlet var messageBodyBox: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // importCSV steps through the CSV and replaces headerKeys and mergeData values
    func importCSV(paths: [AnyObject]) {

        // clear previous
        csvArray = []
        
        // parse the file using CHCSVParser
        if let arr = NSArray(contentsOfCSVURL: paths.first as? NSURL) as? [[String]] {
            csvArray = arr
        } else {
            let alert = NSAlert()
            alert.messageText = "Error Parsing CSV"
            alert.informativeText = "Be sure that the file is a valid CSV file."
            alert.runModal()
            return
        }
    }
    
    func merge(send: Bool) {
        
        // die if there's no data
        if csvArray.count == 0 {
            let alert = NSAlert()
            alert.messageText = "CSV Not Found"
            alert.informativeText = "Make sure you've loaded valid comma-separated values before attempting to merge."
            alert.runModal()
            return
        }
        
        let headerKeys = csvArray.first!
        
        
        // for each row in the CSV
        for row in csvArray[1..<csvArray.count] {
            
            var template: String = messageBodyBox.string!
            var toName: String = toNameField.stringValue
            var toEmail: String = toEmailField.stringValue
            var ccName: String = ccNameField.stringValue
            var ccEmail: String = ccEmailField.stringValue
            var bccName: String = bccNameField.stringValue
            var bccEmail: String = bccEmailField.stringValue
            var subject: String = subjectField.stringValue
            
            // look for headers in all the textFields
            for (index, header) in enumerate(headerKeys) {
                template = template.stringByReplacingOccurrencesOfString("%\(header)%", withString: row[index], options: NSStringCompareOptions.LiteralSearch, range: nil)
                toName = toName.stringByReplacingOccurrencesOfString("%\(header)%", withString: row[index], options: NSStringCompareOptions.LiteralSearch, range: nil)
                toEmail = toEmail.stringByReplacingOccurrencesOfString("%\(header)%", withString: row[index], options: NSStringCompareOptions.LiteralSearch, range: nil)
                ccName = ccName.stringByReplacingOccurrencesOfString("%\(header)%", withString: row[index], options: NSStringCompareOptions.LiteralSearch, range: nil)
                ccEmail = ccEmail.stringByReplacingOccurrencesOfString("%\(header)%", withString: row[index], options: NSStringCompareOptions.LiteralSearch, range: nil)
                bccName = bccName.stringByReplacingOccurrencesOfString("%\(header)%", withString: row[index], options: NSStringCompareOptions.LiteralSearch, range: nil)
                bccEmail = bccEmail.stringByReplacingOccurrencesOfString("%\(header)%", withString: row[index], options: NSStringCompareOptions.LiteralSearch, range: nil)
                subject = subject.stringByReplacingOccurrencesOfString("%\(header)%", withString: row[index], options: NSStringCompareOptions.LiteralSearch, range: nil)
                
            }
            
            // build the AppleScript
            // TODO: Format this more nicely. Swift currently does not have multiline strings.
            var appleScriptString: String = "tell application \"Mail\"\nset newMessage to make new outgoing message with properties {subject:\"\(subject)\", content:\"\(template)\" & return} \ntell newMessage\nset visible to \(!send)\nmake new to recipient at end of to recipients with properties {name: \"\(toName)\", address:\"\(toEmail)\"}\nmake new cc recipient at end of cc recipients with properties {name: \"\(ccName)\", address:\"\(ccEmail)\"}\nmake new bcc recipient at end of cc recipients with properties {name: \"\(bccName)\", address:\"\(bccEmail)\"}\n"
            
            if send {
                appleScriptString += "send\n"
            }
            
            appleScriptString += "end tell\nend tell"
            
            // execute the AppleScript
            let script = NSAppleScript(source: appleScriptString)
            script!.executeAndReturnError(nil)
        }

        
    }
    

}

