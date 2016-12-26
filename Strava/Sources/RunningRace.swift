//
//  RunningRace.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 19/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

open class RunningRace: RunningRaceSummary {
    var routeIds: [Int64] = []
    var websiteURL: String?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        routeIds <- map["route_ids"]
        websiteURL <- map["website_url"]
    }
}
