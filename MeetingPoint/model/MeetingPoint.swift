//
//  MeetingPoint.swift
//  MeetingPoint
//
//  Created by Alphonse on 15/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import Foundation
import CoreLocation

class MeetingPoint {
    var name: String!
    var times = [String:Double]()
    var lines: [String]!
    var coordinate: CLLocationCoordinate2D!
}
