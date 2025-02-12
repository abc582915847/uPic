//
//  CustomConfigView.swift
//  uPic
//
//  Created by Svend Jin on 2019/6/27.
//  Copyright © 2019 Svend Jin. All rights reserved.
//

import Cocoa

class CustomConfigView: ConfigView {
    
    var postConfigSheetController: CustomConfigSheetController?;
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        postConfigSheetController = (self.window?.contentViewController?.storyboard!.instantiateController(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CustomConfigSheetController").rawValue)
            as! CustomConfigSheetController)
        
    }
    
    
    deinit {
        postConfigSheetController?.removeFromParent()
    }

    override func createView() {
        
        guard let data = self.data as? CustomHostConfig else {
            return
        }
        
        let paddingTop = 50, paddingLeft = 6, gapTop = 10, gapLeft = 5, labelWidth = 75, labelHeight = 20,
                viewWidth = Int(self.frame.width), viewHeight = Int(self.frame.height),
                textFieldX = labelWidth + paddingLeft + gapLeft, textFieldWidth = viewWidth - paddingLeft - textFieldX

        var y = viewHeight - paddingTop
        // MARK: url
        let urlLabel = NSTextField(labelWithString: "\(data.displayName(key: "url")):")
        urlLabel.frame = NSRect(x: paddingLeft, y: y, width: labelWidth, height: labelHeight)
        urlLabel.alignment = .right
        urlLabel.lineBreakMode = .byClipping
        
        let urlField = NSTextField(frame: NSRect(x: textFieldX, y: y, width: textFieldWidth, height: labelHeight))
        urlField.identifier = NSUserInterfaceItemIdentifier(rawValue: "url")
        urlField.usesSingleLineMode = true
        urlField.lineBreakMode = .byTruncatingTail
        urlField.delegate = data
        urlField.stringValue = data.url ?? ""
        self.addSubview(urlLabel)
        self.addSubview(urlField)
        nextKeyViews.append(urlField)
        
        // MARK: Method
        y = y - gapTop - labelHeight
        let methodLabel = NSTextField(labelWithString: "\(data.displayName(key: "method")):")
        methodLabel.frame = NSRect(x: paddingLeft, y: y, width: labelWidth, height: labelHeight)
        methodLabel.alignment = .right
        methodLabel.lineBreakMode = .byClipping
        
        let methodButtonPopUp = NSPopUpButton(frame: NSRect(x: textFieldX, y: y, width: textFieldWidth, height: labelHeight))
        methodButtonPopUp.target = self
        methodButtonPopUp.action = #selector(methodChange(_:))
        methodButtonPopUp.identifier = NSUserInterfaceItemIdentifier(rawValue: "method")
        
        var selectMethod: NSMenuItem?
        for method in RequestMethods.allCases {
            let menuItem = NSMenuItem(title: method.rawValue, action: nil, keyEquivalent: "")
            menuItem.identifier = NSUserInterfaceItemIdentifier(rawValue: method.rawValue)
            methodButtonPopUp.menu?.addItem(menuItem)
            
            if data.method == method.rawValue {
                selectMethod = menuItem
            }
        }
        if selectMethod != nil {
            methodButtonPopUp.select(selectMethod)
        }
        
        self.addSubview(methodLabel)
        self.addSubview(methodButtonPopUp)
        nextKeyViews.append(methodButtonPopUp)
        
        
        // MARK: field
        y = y - gapTop - labelHeight
        let otherFieldsBtnWith = 100
        
        let fieldLabel = NSTextField(labelWithString: "\(data.displayName(key: "field")):")
        fieldLabel.frame = NSRect(x: paddingLeft, y: y, width: labelWidth, height: labelHeight)
        fieldLabel.alignment = .right
        fieldLabel.lineBreakMode = .byClipping

        let fieldField = NSTextField(frame: NSRect(x: textFieldX, y: y, width: textFieldWidth - otherFieldsBtnWith, height: labelHeight))
        fieldField.identifier = NSUserInterfaceItemIdentifier(rawValue: "field")
        fieldField.usesSingleLineMode = true
        fieldField.lineBreakMode = .byTruncatingTail
        fieldField.delegate = data
        fieldField.stringValue = data.field ?? ""
        
        
        let otherFieldsBtn = NSButton(title: "Other fields".localized, target: self, action: #selector(openCustomConfigSheet(_:)))
        otherFieldsBtn.frame = NSRect(x: textFieldX + Int(fieldField.frame.width) + gapLeft, y: y, width: otherFieldsBtnWith, height: labelHeight)
        otherFieldsBtn.imagePosition = .noImage
        
        self.addSubview(fieldLabel)
        self.addSubview(fieldField)
        self.addSubview(otherFieldsBtn)
        nextKeyViews.append(fieldField)
        nextKeyViews.append(otherFieldsBtn)
        
        
        // MARK: resultPath
        y = y - gapTop - labelHeight
        let resultLabel = NSTextField(labelWithString: "\(data.displayName(key: "resultPath")):")
        resultLabel.frame = NSRect(x: paddingLeft, y: y, width: labelWidth, height: labelHeight)
        resultLabel.alignment = .right
        resultLabel.lineBreakMode = .byClipping
        
        let resultField = NSTextField(frame: NSRect(x: textFieldX, y: y, width: textFieldWidth, height: labelHeight))
        resultField.identifier = NSUserInterfaceItemIdentifier(rawValue: "resultPath")
        resultField.usesSingleLineMode = true
        resultField.lineBreakMode = .byTruncatingTail
        resultField.delegate = data
        resultField.stringValue = data.resultPath ?? ""
        resultField.placeholderString = "The path to the URL field in Response JSON".localized
        resultField.toolTip = "The path to the URL field in Response JSON".localized
        self.addSubview(resultLabel)
        self.addSubview(resultField)
        nextKeyViews.append(resultField)
        
        // MARK: domain
        y = y - gapTop - labelHeight
        let settingsBtnWith = 40

        let domainLabel = NSTextField(labelWithString: "\(data.displayName(key: "domain")):")
        domainLabel.frame = NSRect(x: paddingLeft, y: y, width: labelWidth, height: labelHeight)
        domainLabel.alignment = .right
        domainLabel.lineBreakMode = .byClipping

        let domainField = NSTextField(frame: NSRect(x: textFieldX, y: y, width: textFieldWidth - settingsBtnWith, height: labelHeight))
        domainField.identifier = NSUserInterfaceItemIdentifier(rawValue: "domain")
        domainField.usesSingleLineMode = true
        domainField.lineBreakMode = .byTruncatingTail
        domainField.delegate = data
        domainField.stringValue = data.domain ?? ""
        domainField.placeholderString = "(optional),When filled, URL = domain + URL path value".localized
        domainField.toolTip = "(optional),When filled, URL = domain + URL path value".localized
        self.domainField = domainField

        let settingsBtn = NSButton(title: "", image: NSImage(named: NSImage.advancedName)!, target: self, action: #selector(openConfigSheet(_:)))
        settingsBtn.frame = NSRect(x: textFieldX + Int(domainField.frame.width) + gapLeft, y: y, width: settingsBtnWith, height: labelHeight)
        settingsBtn.imagePosition = .imageOnly

        self.addSubview(domainLabel)
        self.addSubview(domainField)
        self.addSubview(settingsBtn)
        nextKeyViews.append(domainField)
        nextKeyViews.append(settingsBtn)
        
        
        // MARK: help
        y = y - gapTop - labelHeight
        let helpBtn = NSButton(title: "", target: self, action: #selector(openTutorial(_:)))
        let helpBtnWidth = Int(helpBtn.frame.width)
        helpBtn.frame = NSRect(x: viewWidth - helpBtnWidth * 3 / 2, y: y, width: helpBtnWidth, height: Int(helpBtn.frame.height))
        helpBtn.bezelStyle = .helpButton
        helpBtn.setButtonType(.momentaryPushIn)
        helpBtn.toolTip = "https://blog.svend.cc/upic/tutorials/custom"
        self.addSubview(helpBtn)
        
    }
    
    @objc func methodChange(_ sender: NSPopUpButton) {
        if let menuItem = sender.selectedItem, let identifier = menuItem.identifier?.rawValue {
            self.data?.setValue(identifier, forKey: "method")
        }
    }
    
    @objc override func openConfigSheet(_ sender: NSButton) {
        if let configSheetController = configSheetController {
            let userInfo: [String: Any] = ["domain": self.data?.value(forKey: "domain") ?? "", "saveKey": self.data?.value(forKey: "saveKey") ?? HostSaveKey.dateFilename.rawValue]
            self.window?.contentViewController?.presentAsSheet(configSheetController)
            configSheetController.setData(userInfo: userInfo as [String: AnyObject])
            self.addObserver()
        }
        
    }
    
    @objc override func saveHostSettings(notification: Notification) {
        self.removeObserver()
        guard let userInfo = notification.userInfo else {
            print("No userInfo found in notification")
            return
        }
        
        let domain = userInfo["domain"] as? String ?? ""
        let saveKey = userInfo["saveKey"] as? String ?? HostSaveKey.dateFilename.rawValue
        
        self.data?.setValue(domain, forKey: "domain")
        self.data?.setValue(saveKey, forKey: "saveKey")
        
        domainField?.stringValue = domain
    }
    
    @objc func openCustomConfigSheet(_ sender: NSButton) {
        guard let data = self.data as? CustomHostConfig else {
            return
        }
        
        if let postConfigSheetController = postConfigSheetController {
            self.window?.contentViewController?.presentAsSheet(postConfigSheetController)
            postConfigSheetController.setData(headerStr: data.headers ?? "", bodyStr: data.bodys ?? "")
            self.addCustomConfigObserver()
        }
    }
    
    func addCustomConfigObserver() {
        PreferencesNotifier.addObserver(observer: self, selector: #selector(saveExtensionsSettings), notification: .saveCustomExtensionSettings)
    }
    
    
    func removeCustomConfigObserver() {
        PreferencesNotifier.removeObserver(observer: self, notification: .saveCustomExtensionSettings)
    }
    
    @objc func saveExtensionsSettings(notification: Notification) {
        self.removeCustomConfigObserver()
        guard let userInfo = notification.userInfo else {
            print("No userInfo found in notification")
            return
        }
        
        let headers = userInfo["headers"] as? String ?? ""
        let bodys = userInfo["bodys"] as? String ??  ""
        
        self.data?.setValue(headers, forKey: "headers")
        self.data?.setValue(bodys, forKey: "bodys")
    }
}
