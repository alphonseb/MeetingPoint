//
//  PointsService.swift
//  MeetingPoint
//
//  Created by Alphonse on 14/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PointsService {
    
    typealias PointsCompletionHandler = (LocationResult) -> ()
    
    func getPoints (completionHandler: @escaping PointsCompletionHandler) {
        AF.request("https://app.alphonsebouy.fr/meeteasy", method: .post, parameters: ["lol": "haha"], encoder: JSONParameterEncoder.default).response { (response) in
            let json = JSON(response.data)
            var result = LocationResult()
            
            
            completionHandler(result)
        }
    }
}
