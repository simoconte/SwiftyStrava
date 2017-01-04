//
//  MapSummary.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 04/01/2017.
//  Copyright © 2017 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

class MapSummary: StravaObject {

    var summaryPoliline: AnyObject?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        summaryPoliline <- map["summary_polyline"]
    }
}
