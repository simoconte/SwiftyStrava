//
//  Athlete.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 05/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//
import ObjectMapper

public enum AthleteType: Int {
    case cyclist
    case runner
}

public enum MeasurementPreference: String {
    case feet = "feet"
    case meters = "meters"
}

open class Athlete: AthleteSummary {
    var followerCount: Int = 0
    var friendCount: Int = 0
    var mutualFriendCount: Int = 0
    var athleteType: AthleteType = .cyclist // Athlete’s default sport type: 0=cyclist, 1=runner
    var datePreference: String?
    var measurementPreference: MeasurementPreference = .meters
    var email: String = ""
    var ftp: Int = 0
    var weight: Float = 0.0 // Kilograms
    var clubs: [ClubSummary]? // Array of summary representations of the athlete’s clubs
    var bikes: [GearSummary]? // Array of summary representations of the athlete’s bikes
    var shoes: [GearSummary]? // Array of summary representations of the athlete’s shoes
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        followerCount <- map["follower_count"]
        friendCount <- map["friend_count"]
        mutualFriendCount <- map["mutual_friend_count"]
        athleteType <- map["athlete_type"]
        datePreference <- map["date_preference"]
        measurementPreference <- map["measurement_preference"]
        email <- map["email"]
        ftp <- map["ftp"]
        weight <- map["weight"]
        ftp <- map["bikes"]
        weight <- map["shoes"]
        clubs <- map["clubs"]
        bikes <- map["bikes"]
        shoes <- map["shoes"]
    }
}
