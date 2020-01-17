//
//  LoaderViewController.swift
//  MeetingPoint
//
//  Created by Alphonse on 15/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class LoaderViewController: UIViewController {
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        
        Store.sessionRef.child("result/isFull").observe(.value) { (snapshot) in
            if (snapshot.exists()) {
                let isFull = snapshot.value as? Bool ?? false
                
                if (isFull) {
                    Store.sessionRef.child("result").observeSingleEvent(of: .value, with: { (snapshot) in
                        if (snapshot.exists()) {
                            let result = snapshot.value as? [String:AnyObject] ?? [:]
                            
                            //Meeting Point
                            let resultMeetingPoint = result["point"] as? [String:AnyObject] ?? [:]
                            Store.meetingPoint = MeetingPoint()
                            Store.meetingPoint.name = resultMeetingPoint["name"] as? String
                            
                            let durations = resultMeetingPoint["durations"] as? [String:AnyObject] ?? [:]
                            for (key, duration) in durations {
                                Store.meetingPoint.times[key] = duration as? Double ?? 0
                                // {"name":"test_name", "id":"uyghiuh", "coordinate": {"lat":48.851831,"lon":2.419619}}
                            }
                            let coordinates = resultMeetingPoint["coordinate"]  as? [String:AnyObject] ?? [:]
                            let location = CLLocation(latitude: (coordinates["lat"] as? CLLocationDegrees)!, longitude: (coordinates["lon"] as? CLLocationDegrees)!)
                            Store.meetingPoint.coordinate = location.coordinate
                            
                            // Places
                            let resultPlaces = result["places"] as? [String:AnyObject] ?? [:]
                            for (key, place) in resultPlaces {
                                let point = place as? [String:AnyObject] ?? [:]
                                let pointCoordinates = point["coordinate"] as? [String:AnyObject] ?? [:]
                                let location = CLLocation(latitude: (pointCoordinates["lat"] as? CLLocationDegrees)!, longitude: (pointCoordinates["lon"] as? CLLocationDegrees)!)
                                let nearbyPoint = NearbyPoint(name: (point["name"] as? String)!, coordinate: location.coordinate, description: "Ce bar à cocktail propose des boissons classiques ou originales dans un cadre soigné aux lumières tamisées.")
                                nearbyPoint.imageUrl = URL(string: point["photo_link"] as? String ?? "")
                                nearbyPoint.adress = point["adress"] as? String
                                nearbyPoint.priceLevel = point["price_level"] as? Int
                                nearbyPoint.rating = point["rating"] as? Double
                                nearbyPoint.id = key
                                
                                Store.nearbyPoints.append(nearbyPoint)
                            }
                            
                            self.dismiss(animated: true)
                        }
                    })
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
