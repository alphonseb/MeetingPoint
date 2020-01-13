//
//  JoinSessionViewController.swift
//  MeetingPoint
//
//  Created by Alphonse on 13/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import UIKit
import FirebaseDatabase

class JoinSessionViewController: UIViewController {
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var SessionField: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
    }
    
    func generateShortCode(length: Int) -> String {
        var result = ""
        let base62chars = [Character]("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
        let maxBase : UInt32 = 62
        let minBase : UInt16 = 32
        
        for _ in 0..<length {
            let random = Int(arc4random_uniform(UInt32(min(minBase, UInt16(maxBase)))))
            result.append(base62chars[random])
        }
        return result
    }
    
    @IBAction func join(_ sender: Any) {
        if let session = SessionField.text {
            let sessionRef = ref.child(session)
            
            if let name = NameField.text {
                sessionRef.childByAutoId().setValue([
                    "name": name,
                    "id": generateShortCode(length: 10),
                    "lat": 0.5,
                    "lon": 42
                    ])
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
