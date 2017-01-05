//
//  Segment.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 24/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper

public class Segment: SegmentSummary {
    var createdAt: Date?
    var updatedAt: Date?
    var totalElevationGain: Float = 0
    var segmentMap: [String: AnyObject?]? // Includes a summary polyline
    var effortCount: Int = 0
    var athleteCount: Int = 0
    var starCount: Int = 0
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        createdAt <- (map["created_at"], StravaDateTransform())
        updatedAt <- (map["updated_at"], StravaDateTransform())
        totalElevationGain <- map["total_elevation_gain"]
        segmentMap <- map["map"]
        effortCount <- map["effort_count"]
        athleteCount <- map["athlete_count"]
        starCount <- map["star_count"]
    }
}
