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

class CreateSessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var newName: UILabel!
    @IBOutlet weak var UsersTable: UITableView!
    
    lazy var locationManager = CLLocationManager()
    
    var ref: DatabaseReference!
    var dbHandle: DatabaseHandle!
    var sessionStarted = false
    var userName: String!
    var userId: String!
    var date: Date!
    var requestAlert: UIAlertController!
    var newJoiner: [String:AnyObject]!
    var newJoinerRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Demander les permissions
        locationManager.delegate = self
        
        userId = generateShortCode(length: 10)
        
        requestAlert = UIAlertController(title: "Demande d'ajout", message: "héhé souhaite rejoindre la session.", preferredStyle: .alert)
        
        requestAlert.addAction(UIAlertAction(title: "Ajouter", style: .default, handler: {(action:UIAlertAction) in
            self.newJoinerRef.child("accepted").setValue(true)
            self.addToUsers(self.newJoiner)
        }))
        
        requestAlert.addAction(UIAlertAction(title: "Refuser", style: .destructive, handler: {(action:UIAlertAction) in
            self.newJoinerRef.removeValue { error, _ in
                
                print(error)
            }
        }))
        
            // Vérifier la permission
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation() // On demande à récupérer une seule position
            
            //locationManager.startUpdatingLocaiton() // Pour récupérer plusieurs postion
        } else {
            locationManager.requestWhenInUseAuthorization() // pop-up
        }
    }
    
    func startSession(_ coordinate: CLLocationCoordinate2D) {
        if (!sessionStarted) {
            ref = Database.database().reference()
            //        ref.childByAutoId().setValue("Alphonse")
            let shortCode = generateShortCode(length: 5)
            myLabel.text = shortCode
            let sessionRef = ref.child(shortCode)
            
            sessionRef.childByAutoId().setValue([
                "name": userName!,
                "id": userId!,
                "coordinates": [
                    "lat": coordinate.latitude,
                    "lon": coordinate.longitude
                ]
                ])
            self.sessionStarted = true
            //        ref.child("someid/name").observeSingleEvent(of: .value) { (snapshot) in
            //            let name = snapshot.value as? String
            //            self.myLabel.text = name
            //        }
            dbHandle = sessionRef.observe(.childAdded, with: { (snapshot) in
                let newChild = snapshot.value as? [String : AnyObject] ?? [:]
                
                
                if (newChild["id"] as? String == self.userId) {
                    self.addToUsers(newChild)
                } else {
                    self.newJoinerRef = snapshot.ref
                    self.newJoiner = newChild
                    self.present(self.requestAlert, animated: true, completion: nil)
                }
                
            })
            
            sessionRef.observe(.childRemoved, with: { (snapshot) in
                let newChild = snapshot.value as? [String : AnyObject] ?? [:]
                
                Store.users = Store.users.filter { $0["id"] as? String != newChild["id"] as? String }
                self.UsersTable.reloadData()
            })
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

extension CreateSessionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // L'utilisateur vient d'autoriser la loc
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let coordinate = location.coordinate
            
            self.startSession(coordinate)
            
            print("latitude: \(coordinate.latitude), longitude: \(coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
    }
}
