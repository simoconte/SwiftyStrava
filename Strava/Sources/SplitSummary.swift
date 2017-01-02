//
//  SplitSummary.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 02/01/2017.
//  Copyright © 2017 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

class SplitSummary: Mappable {
    var averageSpeed: Float?
    var distance: Float?
    var elapsedTime: Int?
    var elevationDifference: Float?
    var paceZone: Int?
    var movingTime: Int?
    var split: Float?
    
    required public init?(map: Map){}
    
    public func mapping(map: Map) {
        averageSpeed <- map["average_speed"]
        distance <- map["distance"]
        elapsedTime <- map["elapsed_time"]
        elevationDifference <- map["elevation_difference"]
        paceZone <- map["pace_zone"]
        movingTime <- map["moving_time"]
        split <- map["split"]
    }
}
