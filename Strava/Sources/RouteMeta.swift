//
//  RouteMeta.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 03/01/2017.
//  Copyright © 2017 Oleksandr Glagoliev. All rights reserved.
//

import UIKit

import ObjectMapper

class RouteMeta: StravaObject {
    var routeMap: StravaObject?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        routeMap <- map["map"]
    }
}
