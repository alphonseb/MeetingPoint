//
//  Event.swift
//  MeetingPoint
//
//  Created by Alphonse on 15/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import Foundation

class Event {
    var title: String!
    var date: Double!
    var description: String!
    var organizerName: String!
    var otherMembers = [String]()
    var point: NearbyPoint!
}
