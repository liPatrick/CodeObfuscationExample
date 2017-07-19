//
//  NoteTakerViewController.swift
//  NoteTaker
//
//  Created by Daniel Bessonov on 19/12/2016.
//  Copyright © 2016 Daniel Bessonov. All rights reserved.
//

import UIKit
import CoreData

class NoteTakerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 57
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // hash string with sha256
    func sha256(string: String) -> Data? {
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil; }
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.allowsSelection = false
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let text = noteArray[indexPath.row]
        let cell = UITableViewCell()
        do {
            let originalData = try RNCryptor.decrypt(data: text.name, withPassword: secret)
            var convertedString = (String(data: originalData, encoding: String.Encoding.utf8))!.mutableCopy() as! NSMutableString
            CFStringTransform(convertedString, nil, "Any-Hex/Java" as NSString, true)
            if(String(convertedString) == String(data: originalData, encoding: String.Encoding.utf8)) {
                cell.textLabel!.text = String(data: originalData, encoding: String.Encoding.utf8)!
            }
            else {
                cell.textLabel!.text = String(convertedString)
            }
        }
        catch {
            print(error)
        }
        let font = UIFont(name: "Avenir-Book", size: 16)
        let color = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.4)
        cell.textLabel?.font = font
        cell.textLabel?.textColor = color
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            noteArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
