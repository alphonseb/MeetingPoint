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
    @IBOutlet weak var joiningLabel: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var joinButton: UIButton!
    
    lazy var locationManager = CLLocationManager()
    
    var ref: DatabaseReference!
    var coordinates: CLLocationCoordinate2D!
    var userRef: DatabaseReference!
    var userId: String!
    var kickAlert: UIAlertController!
    var emptyAlert: UIAlertController!
    var noSessionAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        userId = self.generateShortCode(length: 10)
        
        locationManager.delegate = self
        
        joinButton.layer.cornerRadius = 6
        joinButton.layer.borderWidth = 1
        joinButton.layer.borderColor = UIColor.clear.cgColor
        
        emptyAlert = UIAlertController(title: "Attention", message: "Vous devez saisir obligatoirement votre prénom et le numéro de la session", preferredStyle: .alert)
        
        emptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action:UIAlertAction) -> Void in
        }))
        
        noSessionAlert = UIAlertController(title: "Session inconnue", message: "Cette session n'existe pas, vérifiez votre code de session et réessayez", preferredStyle: .alert)
        
        noSessionAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.joiningLabel.isHidden = true
            self.joinButton.isHidden = false
            self.loader.stopAnimating()
        }))
        
        kickAlert = UIAlertController(title: "Kick", message: "Le créateur de la session ne vous a pas accepté", preferredStyle: .alert)
        
        kickAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action:UIAlertAction) in
            if let homeView = self.storyboard?.instantiateViewController(withIdentifier: "home") as? HomeViewController {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }))
        
        // Vérifier la permission
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation() // On demande à récupérer une seule position
            
            //locationManager.startUpdatingLocaiton() // Pour récupérer plusieurs postion
        } else {
            locationManager.requestWhenInUseAuthorization() // pop-up
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
        // check if fields not empty
        if (NameField.text?.isEmpty ?? true || SessionField.text?.isEmpty ?? true) {
            self.present(self.emptyAlert, animated: true, completion: nil)
        } else {
            joiningLabel.isHidden = false
            joinButton.isHidden = true
            loader.startAnimating()
            if let session = SessionField.text {
                Store.sessionRef = ref.child(session)
                
                Store.sessionRef.observeSingleEvent(of: .value) { (snapshot) in
                    if (!snapshot.exists()) {
                        self.present(self.noSessionAlert, animated: true, completion: nil)
                    } else {
                        self.addUser(session)
                    }
                }
            }
        }
    }
    
    func addUser (_ session: String) {
        self.userRef = Store.sessionRef.child("users").childByAutoId()
        
        if let name = NameField.text {
            self.userRef.setValue([
                "name": name,
                "id": self.userId!,
                "coordinate": [
                    "lat": self.coordinates.latitude,
                    "lon": self.coordinates.longitude
                ]
                ])
        }
        
        Store.sessionRef.child("users").observe(.childRemoved) { (snapshot) in
            let removedUser = snapshot.value as? [String:AnyObject] ?? [:]
            if (removedUser["id"] as? String == self.userId) {
                self.present(self.kickAlert, animated: true, completion: nil)
            }
        }
        
        userRef.observe(.childAdded) { (snapshot) in
            if (snapshot.key == "accepted") {
                let value = snapshot.value as? Bool
                if let accepted = value {
                    if (accepted) {
                        if let joinStepTwoView = self.storyboard?.instantiateViewController(withIdentifier: "joinStepTwo") as? JoinStepTwoViewController {
                            
                            joinStepTwoView.sessionCode = session
                            self.navigationController?.pushViewController(joinStepTwoView, animated: true)
                        }
                    }
                }
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
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
    }
}
