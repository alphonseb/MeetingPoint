//
//  NearbyPoint.swift
//  MeetingPoint
//
//  Created by Alphonse on 15/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import Foundation
import CoreLocation

class NearbyPoint {
    var name: String!
    var coordinate: CLLocationCoordinate2D!
    var description: String!
    var infos: [String]!
    
    init(name: String, coordinate: CLLocationCoordinate2D, description: String, infos: [String]) {
        self.coordinate = coordinate
        self.name = name
        self.description = description
        self.infos = infos
    }
}
