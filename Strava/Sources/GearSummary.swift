//
//  GearSummary.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 07/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public class GearSummary: StravaObject {
    var primary: Bool = false
    var name: String = ""
    var distance: Float = 0.0
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        primary <- map["primary"] // Athlete’s default bike/shoes
        name <- map["name"] // Name athlete entered for bikes, generated from brand and model for shoes
        distance <- map["distance"] // Meters
    }
}
