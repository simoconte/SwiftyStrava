//
//  Gear.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 07/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public class Gear: GearSummary {
    var brandName: String?
    var modelName: String?
        
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        brandName <- map["brand_name"]
        modelName <- map["model_name"]
    }
}
