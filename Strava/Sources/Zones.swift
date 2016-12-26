//
//  Zones.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 12/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper


open class ZoneInterval: Mappable {
    var min: Int = 0
    var max: Int = -1
    
    required public init?(map: Map){}
    
    public func mapping(map: Map) {
        min <- map["min"]
        max <- map["max"]
    }
}

open class Zones: Mappable {
    var customZones: Bool = false
    var heartRateZones: [ZoneInterval] = []
    var powerZones: [ZoneInterval] = []
    
    required public init?(map: Map){}
    
    public func mapping(map: Map) {
        customZones <- map["heart_rate.custom_zones"]
        heartRateZones <- map["heart_rate.zones"]
        powerZones <- map["power.zones"]
    }
}
