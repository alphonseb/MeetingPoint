//
//  PlaceAnnotation.swift
//  MeetingPoint
//
//  Created by Alphonse on 15/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var point: NearbyPoint!
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, nearbyPoint: NearbyPoint?) {
        self.coordinate = coordinate
        if let point = nearbyPoint {
            self.point = point
        }
    }
}
