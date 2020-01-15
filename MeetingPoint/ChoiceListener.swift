//
//  ChoiceListener.swift
//  MeetingPoint
//
//  Created by Alphonse on 15/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class ChoiceListener {
    typealias choiceCompletion = (Bool)->()
    
    func listen(completionHandler: @escaping choiceCompletion) {
        Store.sessionRef.child("event/choosenPoint").observe(.value) { (snapshot) in
            if (snapshot.exists()) {
                let choosenPoint = snapshot.value as? [String:AnyObject] ?? [:]
                Store.event.title = choosenPoint["name"] as? String
                let coordinates = choosenPoint["coordinate"] as? [String:AnyObject] ?? [:]
                let location = CLLocation(latitude: (coordinates["lat"] as? CLLocationDegrees)!, longitude: (coordinates["lon"] as? CLLocationDegrees)!)
                var infos = [String]()
                let snapshotInfos = choosenPoint["infos"] as? [String:AnyObject] ?? [:]
                for (key, info) in snapshotInfos {
                    infos.append((info as? String)!)
                }
                Store.event.point = NearbyPoint(name: choosenPoint["name"] as? String ?? "No name", coordinate: location.coordinate, description: choosenPoint["description"] as? String ?? "No description", infos: infos)
                Store.event.point.imageUrl = choosenPoint["imageUrl"] as? URL ?? URL(string: "")
                
                // TODO : Save to Core Data
                
                completionHandler(true)
            }
        }
    }
}
