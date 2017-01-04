//
//  RouteSummary.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 24/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper

public enum RouteType: Int {
    case ride = 1
    case run = 2
}

public enum RouteSubType: Int {
    case road = 1
    case MTB
    case CX
    case trail
    case mixed
}

public class RouteSummary: StravaObject {
    var name: String?
    var description: String?
    var athlete: StravaObject?
    var distance: Float = 0 // Meters
    var elevationGain: Float = 0 // Meters
    var mapObject: AnyObject?
    var type: RouteType?
    var subType: RouteSubType?
    var isPrivate: Bool = true
    var starred: Bool = false
    var timestamp: TimeInterval?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        description <- map["description"]
        athlete <- map["athlete"]
        distance <- map["distance"]
        elevationGain <- map["elevation_gain"]
        mapObject <- map["map"]
        type <- map["type"]
        subType <- map["sub_type"]
        isPrivate <- map["private"]
        starred <- map["starred"]
        timestamp <- map["timestamp"]
    }
}
