//
//  SegmentEffort.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 24/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper

open class SegmentEffort: StravaObject {
    var name: String = ""
    var activity: StravaObject?
    var athlete: StravaObject?
    var elapsedTime: Int = 0
    var movingTime: Int = 0
    var startDate: Date?
    var startDateLocal: Date?
    var distance: Float = 0
    var startIndex: Int = 0
    var endIndex: Int = 0
    var averageCadence: Float?
    var averageWatts: Float? // Rides only
    var deviceWatts: Bool? // Rides only
    var averageHeartrate: Int? // BPM, Missing if not provided
    var maxHeartrate: Int? // BPM, Missing if not provided
    var segment: SegmentSummary?
    var komRank: Int = 0 // 1-10 rank on segment at time of upload
    var prRank: Int = 0 // 1-3 personal record on segment at time of upload
    var hidden: Bool = false
    
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        activity <- map["activity"]
        athlete <- map["athlete"]
        elapsedTime <- map["elapsed_time"]
        movingTime <- map["moving_time"]
        startDate <- (map["start_date"], StravaDateTransform())
        startDateLocal <- (map["start_date_local"], StravaDateTransform())
        distance <- map["distance"]
        startIndex <- map["start_index"]
        endIndex <- map["end_index"]
        averageCadence <- map["average_cadence"]
        averageWatts <- map["average_watts"]
        deviceWatts <- map["device_watts"]
        averageHeartrate <- map["average_heartrate"]
        maxHeartrate <- map["max_heartrate"]
        segment <- map["segment"]
        komRank <- map["kom_rank"]
        prRank <- map["pr_rank"]
        hidden <- map["hidden"]
    }
}
