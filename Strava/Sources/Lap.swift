//
//  Lap.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 10/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper
import AlamofireObjectMapper

public class Lap: StravaObject {
    var activity: StravaObject?
    var athlete: StravaObject?
    var averageCadence: Float = 0
    var averageSpeed: Float = 0
    var distance: Float = 0
    var elapsedTime: TimeInterval = 0
    var endIndex: Int = 0
    var lapIndex: Int = 0
    var maxSpeed: Float = 0
    var movingTime: TimeInterval = 0
    var name: String?
    var split: Int = 1
    var startDate: Date?
    var startDateLocal: Date?
    var startIndex: Int = 0
    var totalElevationGain: Float = 0
    
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        activity <- map["activity"]
        athlete <- map["athlete"]
        averageCadence <- map["average_cadence"]
        averageSpeed <- map["average_speed"]
        distance <- map["distance"]
        elapsedTime <- map["elapsed_time"]
        endIndex <- map["end_index"]
        id <- map["id"]
        lapIndex <- map["lap_index"]
        maxSpeed <- map["max_speed"]
        movingTime <- map["moving_time"]
        name <- map["name"]
        resourceState <- map["resource_state"]
        split <- map["split"]
        startDate <- map["start_date"]
        startDateLocal <- map["start_date_local"]
        startIndex <- map["start_index"]
        totalElevationGain <- map["total_elevation_gain"]
    }
}
