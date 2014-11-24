//
//  ViewController.swift
//  SimpleMerge
//
//  Created by Harry Shamansky on 11/23/14.
//  Copyright (c) 2014 Harry Shamansky. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var headerKeys: [String] = []
    var mergeData: [[String : String]] = []
    
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
        headerKeys = []
        mergeData = []
        
        // grab the file
        let fullText: String = String(contentsOfURL: (paths.first! as NSURL), encoding: NSUTF8StringEncoding, error: nil)!
        
        var finishedHeaders: Bool = false
        var currentTerm: String = ""
        var currentDict: [String : String] = [:]
        var index: Int = 0
        
        // step through the text character by character
        for c in fullText {
            if c == "," {   // if comma
                if finishedHeaders {
                    currentDict[headerKeys[index++]] = currentTerm
                    currentTerm = ""
                } else {
                    headerKeys.append(currentTerm)
                    currentTerm = ""
                }
            } else if c == "\n" || c == "\r\n" || c == "\r" {   // if newline
                if finishedHeaders {
                    currentDict[headerKeys[index++]] = currentTerm
                    mergeData.append(currentDict)
                    currentDict = [:]
                    currentTerm = ""
                    index = 0
                } else {
                    finishedHeaders = true
                    headerKeys.append(currentTerm)
                    currentTerm = ""
                    index = 0
                }
            } else {    // mid-word: continue building the current term
                currentTerm.append(c)
            }
        }
        
        // grab the last term (without trailing newline)
        // and add the message to the mergeData
        currentDict[headerKeys[index]] = currentTerm
        mergeData.append(currentDict)
    }
    
    func merge(send: Bool) {
        
        // die if there's no data
        if mergeData.count == 0 {
            let alert = NSAlert()
            alert.messageText = "CSV Not Found"
            alert.informativeText = "Make sure you've loaded valid comma-separated values before attempting to merge."
            alert.runModal()
            return
        }
        
        // for each row in the CSV
        for messageDict in mergeData {
            
            var template: String = messageBodyBox.string!
            var toName: String = toNameField.stringValue
            var toEmail: String = toEmailField.stringValue
            var ccName: String = ccNameField.stringValue
            var ccEmail: String = ccEmailField.stringValue
            var bccName: String = bccNameField.stringValue
            var bccEmail: String = bccEmailField.stringValue
            var subject: String = subjectField.stringValue
            
            // look for headers in all the textFields
            for header in headerKeys {
                template = template.stringByReplacingOccurrencesOfString("%\(header)%", withString: messageDict[header]!, options: NSStringCompareOptions.LiteralSearch, range: nil)
                toName = toName.stringByReplacingOccurrencesOfString("%\(header)%", withString: messageDict[header]!, options: NSStringCompareOptions.LiteralSearch, range: nil)
                toEmail = toEmail.stringByReplacingOccurrencesOfString("%\(header)%", withString: messageDict[header]!, options: NSStringCompareOptions.LiteralSearch, range: nil)
                ccName = ccName.stringByReplacingOccurrencesOfString("%\(header)%", withString: messageDict[header]!, options: NSStringCompareOptions.LiteralSearch, range: nil)
                ccEmail = ccEmail.stringByReplacingOccurrencesOfString("%\(header)%", withString: messageDict[header]!, options: NSStringCompareOptions.LiteralSearch, range: nil)
                bccName = bccName.stringByReplacingOccurrencesOfString("%\(header)%", withString: messageDict[header]!, options: NSStringCompareOptions.LiteralSearch, range: nil)
                bccEmail = bccEmail.stringByReplacingOccurrencesOfString("%\(header)%", withString: messageDict[header]!, options: NSStringCompareOptions.LiteralSearch, range: nil)
                subject = subject.stringByReplacingOccurrencesOfString("%\(header)%", withString: messageDict[header]!, options: NSStringCompareOptions.LiteralSearch, range: nil)
                
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

