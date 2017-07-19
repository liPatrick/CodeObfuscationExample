//
//  ActivateViewController.swift
//  NoteTaker
//
//  Created by Daniel Bessonov on 6/28/17.
//  Copyright © 2017 Shane Doyle. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RegisterViewController : UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var licenseKeyTextField: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    // hash string with sha256
    func fds4df(string: String) -> Data? {
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil; }
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData
    }
    
    // generate random String with length of N
    func generateRandomKey(length: Int) -> String {
        let letters : NSString = "0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    func bytes2String(_ array: [UInt8]) -> String {
        return String(data: Data(bytes: array, count: array.count), encoding: .utf8) ?? ""
    }
    
    func djenu(val : String) -> Data {
        var initial = fds4df(string: val + secret)! as Data
        var backToString = initial.map { String(format: "%02x", $0) }.joined()
        for i in 0..<4 {
            initial = fds4df(string: backToString as String)! as Data
            backToString = initial.map { String(format: "%02x", $0) }.joined()
        }
        return initial as Data
    }
 
    @IBAction func lsdfk3b(_ sender: Any) {
        
        var obfuscator = Obfuscator(withSalt: "dkisf")
        var msg: [UInt8] = [55, 30, 10, 16, 3, 23, 24]
        var msg2: [UInt8] = [61, 4, 28, 83, 7, 22, 14, 73, 29, 9, 19, 75, 31, 22, 20, 2, 2, 12, 23]
        var rst1 = obfuscator.reveal(key: msg)
        var rst2 = obfuscator.reveal(key: msg2)
        
        
        
        var msg3: [UInt8] = [33, 25, 27, 28, 20]
        var msg4: [UInt8] = [61, 4, 28, 1, 70, 8, 2, 10,22, 8, 23, 14, 73, 24, 3, 29, 75, 13, 28, 3, 23, 75, 7, 28, 18, 68, 6, 8, 7, 5, 12, 74]
        var rst3 = obfuscator.reveal(key: msg3)
        var rst4 = obfuscator.reveal(key: msg4)
        //var result1 = obfuscator.reveal(key: message1)
        
        
        if(self.nameTextField.text != "") {
            let hash = djenu(val: self.nameTextField.text!)
            let hashString = hash.map { String(format: "%02x", $0) }.joined()
            print(hashString)
            if(hashString == licenseKeyTextField!.text!) {
                emojiEnabled = true
                
                let alert = UIAlertController(title: rst1, message: rst2, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                    self.performSegue(withIdentifier: "goBackToHome", sender: self)
                }))
                self.present(alert, animated: true, completion: nil)
                
                
            }
            else {
                print(hashString)
                let alert = UIAlertController(title: rst3, message: rst4, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}

