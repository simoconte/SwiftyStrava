//
//  StravaPhoto.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 06/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public class StravaPhoto: Photo {
    var uniqueId: String?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        uniqueId <- map["unique_id"]
    }
}
