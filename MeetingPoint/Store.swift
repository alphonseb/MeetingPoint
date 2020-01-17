//
//  Store.swift
//  MeetingPoint
//
//  Created by Alphonse on 14/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import Foundation
import Firebase
struct Store {
    static var users = [[String:AnyObject]]()
    static var event: Event!
    static var sessionRef: DatabaseReference!
    static var meetingPoint: MeetingPoint!
    static var nearbyPoints = [NearbyPoint]()
    static var isOrganizer = false
    static var homeEventDisplayed = false
}
