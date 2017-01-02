//
//  SegmentEffortSummary.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 12/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public class SegmentEffortSummary: StravaObject {
    var name: String?
    var activity: StravaObject?
    var athlete: StravaObject?
    var elapsedTime: Int = 0
    var movingTime: Int = 0
    var startDate: Date?
    var startDateLocal: Date?
    var distance: Float = 0
    var startIndex: Int = -1
    var endIndex: Int = -1
    var averageCadence: Float?
    var averageWatts: Float?
    var deviceWatts: Bool = false
    var averageHeartRate: Float?
    var maxHeartRate: Float?
    var segment: SegmentSummary?
    var KOMRank: Int?
    var PRRank: Int?
    var hidden: Bool = false
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        activity <- map["activity"]
        athlete <- map["athlete"]
        elapsedTime <- map["elapsed_time"]
        movingTime <- map["moving_time"]
        startDate <- map["start_date"]
        startDateLocal <- map["start_date_local"]
        distance <- map["distance"]
        startIndex <- map["start_index"]
        endIndex <- map["end_index"]
        averageCadence <- map["average_cadence"]
        averageWatts <- map["average_watts"]
        deviceWatts <- map["device_watts"]
        averageHeartRate <- map["average_heartrate"]
        maxHeartRate <- map["max_heartrate"]
        segment <- map["segment"]
        KOMRank <- map["kom_rank"]
        PRRank <- map["pr_rank"]
        hidden <- map["hidden"]
    }
}
