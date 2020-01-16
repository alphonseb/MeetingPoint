//
//  ViewController.swift
//  MeetingPoint
//
//  Created by Alphonse on 13/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//
import UIKit
import FirebaseDatabase
import CoreLocation

class JoinStepTwoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var newName: UILabel!
    @IBOutlet weak var UsersTable: UITableView!
    
    var sessionCode: String!
    var dbHandle: DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Demander les permissions
        myLabel.text = sessionCode
        
        dbHandle = Store.sessionRef.child("users").observe(.childAdded, with: { (snapshot) in
            let newChild = snapshot.value as? [String : AnyObject] ?? [:]
                self.addToUsers(newChild)
            if (!(newChild["isOrganizer"] as? Bool ?? false)) {
                Store.event.otherMembers.append(newChild["name"] as? String ?? "Anonymous")
            }
        })
        
        Store.sessionRef.child("event").observeSingleEvent(of: .value) { (snapshot) in
            if (snapshot.exists()) {
                let sessionEvent = snapshot.value as? [String:AnyObject] ?? [:]
                Store.event = Event()
                Store.event.date = sessionEvent["date"] as? Double
                Store.event.description = sessionEvent["description"] as? String
                Store.event.organizerName = sessionEvent["organizerName"] as? String
            }
        }
        
        Store.sessionRef.child("started").observe(.value) { (snapshot) in
            if (snapshot.exists()) {
                if (snapshot.value as? Bool ?? false) {
                    if let loaderView = self.storyboard?.instantiateViewController(withIdentifier: "loaderView") as? LoaderViewController {
                        
                        self.navigationController?.present(loaderView, animated: true, completion: {
                            if let mapView = self.storyboard?.instantiateViewController(withIdentifier: "resultMap") as? ResultMapViewController {
                                
                                self.navigationController?.pushViewController(mapView, animated: true)
                                
                            }
                        })
                    }
                }
            }
        }
    }
    
    func addToUsers (_ user: [String:AnyObject]) {
        Store.users.append(user)
        self.UsersTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Store.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        cell.user = Store.users[indexPath.row]
        
        return cell
    }
    
    
}
