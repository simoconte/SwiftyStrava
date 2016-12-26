//
//  Stats.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 12/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

open class Total: Mappable {
    var count: Int = 0
    var distance: Int = 0
    var movingTime: Int = 0
    var elapsedTime: Int = 0
    var elevationGain: Int = 0
    
    required public init?(map: Map){}
    
    public func mapping(map: Map) {
        count <- map["count"]
        distance <- map["distance"]
        movingTime <- map["moving_time"]
        elapsedTime <- map["elapsed_time"]
        elevationGain <- map["elevation_gain"]
    }
}

open class Stats: Mappable {
    var biggestRideDistance: Double = 0
    var biggestClimbElevationGain: Double = 0
    // Last 4 weeks
    var recentRideTotals: Total?
    var recentRunTotals: Total?
    var recentSwimTotals: Total?
    
    // Year to date
    var yearToDateRideTotals: Total?
    var yearToDateRunTotals: Total?
    var yearToDateSwimTotals: Total?
    
    // All totals
    var allRideTotals: Total?
    var allRunTotals: Total?
    var allSwimTotals: Total?
    
    required public init?(map: Map){}
    
    public func mapping(map: Map) {
        biggestRideDistance <- map["biggest_ride_distance"]
        biggestClimbElevationGain <- map["biggest_climb_elevation_gain"]
        recentRideTotals <- map["recent_ride_totals"]
        recentRunTotals <- map["recent_run_totals"]
        recentSwimTotals <- map["recent_swim_totals"]
        yearToDateRideTotals <- map["ytd_ride_totals"]
        yearToDateRunTotals <- map["ytd_run_totals"]
        yearToDateSwimTotals <- map["ytd_swim_totals"]
        allRideTotals <- map["all_ride_totals"]
        allRunTotals <- map["all_run_totals"]
        allSwimTotals <- map["all_swim_totals"]
    }
}
