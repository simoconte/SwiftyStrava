//
//  Stream.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 26/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper

public enum StreamType: String {
    case Time = "time"
    case Coordinate = "latlng"
    case Distance = "distance"
    case Altitude = "altitude"
    case VelocitySmooth = "velocity_smooth"
    case HeartRate = "heartrate"
    case Cadence = "cadence"
    case Watts = "watts"
    case Temp = "temp"
    case Moving = "moving"
    case GradeSmooth = "grade_smooth"
}

public enum Resolution: String {
    case Low = "low"
    case Medium = "medium"
    case High = "high"
}

public enum SeriesType: String {
    case time = "time"
    case distance = "distance"
}

open class Stream: StravaObject {
    var type: StreamType?
    var data: AnyObject?
    var seriesType: StreamType = .Time
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
