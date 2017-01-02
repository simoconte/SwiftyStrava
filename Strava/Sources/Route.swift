//
//  Route.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 24/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper


public class Route: RouteSummary {
    var segments: [Segment] = [Segment]()
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        segments <- map["segments"]
    }
}

