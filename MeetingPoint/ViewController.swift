//
//  ViewController.swift
//  MeetingPoint
//
//  Created by Alphonse on 13/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//
import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var newName: UILabel!
    @IBOutlet weak var UsersTable: UITableView!
    
    var ref: DatabaseReference!
    var dbHandle: DatabaseHandle!
    var users = [[String:AnyObject]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
//        ref.childByAutoId().setValue("Alphonse")
        let shortCode = generateShortCode(length: 5)
        myLabel.text = shortCode
        let sessionRef = ref.child(shortCode)
        
        sessionRef.childByAutoId().setValue([
            "name": "Alphonse",
            "lat": 0.5,
            "lon": 42
            ])
        
        sessionRef.childByAutoId().setValue([
            "name": "Manon",
            "lat": 0.5,
            "lon": 45
            ])
//        ref.child("someid/name").observeSingleEvent(of: .value) { (snapshot) in
//            let name = snapshot.value as? String
//            self.myLabel.text = name
//        }
        dbHandle = sessionRef.observe(.childAdded, with: { (snapshot) in
            let newChild = snapshot.value as? [String : AnyObject] ?? [:]
            print(newChild)
//            let name = newChild["name"] as? String
            self.users.append(newChild)
            self.UsersTable.reloadData()
//            if let child = newChild {
//                self.users.append(child)
//
//                self.UsersTable.reloadData()
//            }
//            self.newName.text = newChild["name"] as? String
            // ...
        })
        
//        sessionRef.observe(.childRemoved, with: { (snapshot) in
//            let newChild = snapshot.value as? [String : AnyObject] ?? [:]
//
//            let name = newChild["name"] as? String
//
//            if let userName = name {
//                self.users = self.users.filter { $0 == userName }
//                self.UsersTable.reloadData()
//            }
//            //            self.newName.text = newChild["name"] as? String
//            // ...
//        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        cell.user = users[indexPath.row]
        
        return cell
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


}

