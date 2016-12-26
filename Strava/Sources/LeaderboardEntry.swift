//
//  LeaderboardEntry.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 18/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper

open class LeaderboardEntry: Mappable {
    var athleteName: String?
    var athleteId: String?
    var athleteGender: Gender?
    var averageHR: Float?
    var averageWatts: Float?
    var distance: Float?
    var elapsedTime: TimeInterval?
    var movingTime: TimeInterval?
    var startDate: Date?
    var startDateLocal: Date?
    var activityId: Int64?
    var effortId: Int64?
    var rank: Int = 0
    var athleteProfile: String?
    
    required public init?(map: Map){}
    
    public func mapping(map: Map) {
        athleteName <- map["athlete_name"]
        athleteId <- map["athlete_id"]
        athleteGender <- map["athlete_gender"]
        averageHR <- map["average_hr"]
        averageWatts <- map["average_watts"]
        distance <- map["distance"]
        elapsedTime <- map["elapsed_time"]
        movingTime <- map["moving_time"]
        startDate <- map["start_date"]
        startDateLocal <- map["start_date_local"]
        activityId <- map["activity_id"]
        effortId <- map["effort_id"]
        rank <- map["rank"]
        athleteProfile <- map["athlete_profile"]
    }
}
