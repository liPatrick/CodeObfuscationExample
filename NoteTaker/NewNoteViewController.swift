//
//  NewNoteViewController.swift
//  NoteTaker
//
//  Created by Shane Doyle on 07/01/2017.
//  Copyright © 2017 Shane Doyle. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

extension UnicodeScalar {
    var isEmoji: Bool {
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        65024...65039, // Variation selector
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
        default: return false
        }
    }
    var isZeroWidthJoiner: Bool {
        return value == 8205
    }
}

extension String {
    
    var glyphCount: Int {
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    var containsOnlyEmoji: Bool {
        return !isEmpty
            && !unicodeScalars.contains(where: {
                !$0.isEmoji
                    && !$0.isZeroWidthJoiner
            })
    }
    
}

class NewNoteViewController: UIViewController {
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var peakLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var peakImageView: UIImageView!
    @IBOutlet weak var averageImageView: UIImageView!
    
    
    var audioURL : String = ""
    var audioRecorder : AVAudioRecorder!
    var timerInterval : TimeInterval = 0.5
    var audioPlayer : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: noteTitle.frame.height - 1, width: noteTitle.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        noteTitle.borderStyle = UITextBorderStyle.none
        noteTitle.layer.addSublayer(bottomLine)        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if(noteTitle.text!.containsEmoji) {
            if(emojiEnabled) {
                if (noteTitle.text != "") {
                    let data : NSData = noteTitle.text!.data(using: String.Encoding.nonLossyASCII) as! NSData
                    let cipherText = RNCryptor.encrypt(data: data as Data, withPassword: secret)
                    noteArray.append(NoteClass(data: cipherText as Data))
                }
            }
            else {
                let alert = UIAlertController(title: "Error", message: "You cannot save emojis! Please register a license key!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            if (noteTitle.text != "") {
                let data : NSData = noteTitle.text!.data(using: String.Encoding.nonLossyASCII) as! NSData
                let password = "Secret password"
                let cipherText = RNCryptor.encrypt(data: data as Data, withPassword: password)
                noteArray.append(NoteClass(data: cipherText as Data))
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
