//
//  SegmentSummary.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 12/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper
import AlamofireObjectMapper

public enum AgeGroup: String {
    case ag024 = "0_24"
    case ag2534 = "25_34"
    case ag3544 = "35_44"
    case ag4554 = "45_54"
    case ag5564 = "55_64"
    case ag65Plus = "65_plus"
}

public enum WeightClass: String {
    case lb0_124 = "0_124"
    case lb125_149 = "125_149"
    case lb150_164 = "150_164"
    case lb165_179 = "165_179"
    case lb180_199 = "180_199"
    case lb200_plus = "200_plus"
    
    case kg0_54 = "0_54"
    case kg55_64 = "55_64"
    case kg65_74 = "65_74"
    case kg75_84 = "75_84"
    case kg85_94 = "85_94"
    case kg95_plus = "95_plus"
}

public enum DateRange: String {
    case thisYear = "this_year"
    case thisMonth = "this_month"
    case thisWeek = "this_week"
    case today = "today"
}

public struct Bounds {
    var swLat: Float!
    var swLng: Float!
    var neLat: Float!
    var neLng: Float!
    var s: Float!
    var w: Float!
    var n: Float!
    var e: Float!
    
    func toString() -> String {
        return [swLat, swLng, neLat, neLng, s, w, n, e].map {"\($0)"}.joined(separator: ",")
    }
}

public typealias ClimbCategory = Int

open class SegmentSummary: StravaObject {
    var name: String = ""
    var activityType: ActivityType = .ride
    var distance: Float = 0
    var averageGrade: Float = 0 // Percent
    var maximumGrade: Float = 0 // Percent
    var elevationHigh: Float = 0
    var elevationLow: Float = 0
    var startCoordinate: GeoCoordinate?
    var endCoordinate: GeoCoordinate?
    var climbCategory: ClimbCategory = 0
    var city: String = ""
    var state: String = ""
    var country: String = ""
    var isPrivate: Bool = false
    var starred: Bool = false
    var hazardous: Bool = true
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        activityType <- map["activity_type"]
        distance <- map["distance"]
        averageGrade <- map["average_grade"]
        maximumGrade <- map["maximum_grade"]
        elevationHigh <- map["elevation_high"]
        elevationLow <- map["elevation_low"]
        startCoordinate <- map["start_latlng"]
        endCoordinate <- map["end_latlng"]
        climbCategory <- map["climb_category"]
        city <- map["city"]
        state <- map["state"]
        country <- map["country"]
        isPrivate <- map["private"]
        starred <- map["starred"]
        hazardous <- map["hazardous"]
    }
}
