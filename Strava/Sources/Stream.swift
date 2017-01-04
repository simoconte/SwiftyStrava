//
//  Stream.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 26/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public enum StreamType: String {
    case time = "time"
    case coordinate = "latlng"
    case distance = "distance"
    case altitude = "altitude"
    case velocitySmooth = "velocity_smooth"
    case heartRate = "heartrate"
    case cadence = "cadence"
    case watts = "watts"
    case temp = "temp"
    case moving = "moving"
    case gradeSmooth = "grade_smooth"
}

public enum Resolution: String {
    case low = "low"
    case medium = "medium"
    case high = "high"
}

public enum SeriesType: String {
    case time = "time"
    case distance = "distance"
}

public class Stream: StravaObject {
    var type: StreamType?
    var data: AnyObject?
    var seriesType: StreamType = .time
    var originalSize: Int = 0
    var resolution: Resolution?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        type <- map["type"]
        data <- map["data"]
        seriesType <- map["series_type"]
        originalSize <- map["original_size"]
        resolution <- map["resolution"]
    }
}
