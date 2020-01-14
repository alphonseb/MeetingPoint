//
//  JoinSessionViewController.swift
//  MeetingPoint
//
//  Created by Alphonse on 13/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreLocation

class JoinSessionViewController: UIViewController {
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var SessionField: UITextField!
    
    lazy var locationManager = CLLocationManager()
    
    var ref: DatabaseReference!
    var coordinates: CLLocationCoordinate2D!
    var sessionRef: DatabaseReference!
    var userRef: DatabaseReference!
    var userId: String!
    var kickAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        userId = self.generateShortCode(length: 10)
        
        locationManager.delegate = self
        
        kickAlert = UIAlertController(title: "Kick", message: "Le créateur de la session ne vous a pas accepté", preferredStyle: .alert)
        
        kickAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action:UIAlertAction) in
            if let homeView = self.storyboard?.instantiateViewController(withIdentifier: "home") as? HomeViewController {
                self.navigationController?.pushViewController(homeView, animated: true)
            }
        }))
        
        // Vérifier la permission
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation() // On demande à récupérer une seule position
            
            //locationManager.startUpdatingLocaiton() // Pour récupérer plusieurs postion
        } else {
            locationManager.requestWhenInUseAuthorization() // pop-up
        }
        
        sessionRef.observe(.childRemoved) { (snapshot) in
            let removedUser = snapshot.value as? [String:AnyObject] ?? [:]
            if (removedUser["id"] as? String == self.userId) {
                
            }
        }
        
        userRef.observe(.childAdded) { (snapshot) in
            if (snapshot.key == "accepted") {
                let value = snapshot.value as? Bool
                if let accepted = value {
                    if (accepted) {
                        print("accepted by session creator")
                    }
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setCoordinates(_ coordinates: CLLocationCoordinate2D) {
        self.coordinates = coordinates
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
            self.sessionRef = ref.child(session)
            self.userRef = sessionRef.childByAutoId()
            
            if let name = NameField.text {
                self.userRef.setValue([
                    "name": name,
                    "id": self.userId,
                    "coordinates": [
                        "lat": self.coordinates.latitude,
                        "lon": self.coordinates.longitude
                    ]
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

extension JoinSessionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // L'utilisateur vient d'autoriser la loc
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let coordinate = location.coordinate
            
            self.setCoordinates(coordinate)
            
            print("latitude: \(coordinate.latitude), longitude: \(coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
    }
}
