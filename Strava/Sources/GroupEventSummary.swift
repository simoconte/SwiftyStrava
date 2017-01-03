//
//  GroupEventSummary.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 26/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public enum SkillLevel: Int {
    case casual = 1
    case tempo
    case hammerfast = 4
}

public enum Terrain: Int {
    case mostlyFlat
    case rollingHills
    case killerClimbs
}

public class GroupEventSummary: StravaObject {
    var title: String?
    var description: String?
    var club: StravaObject? // `Club` meta representation
    var organizingAthlete: AthleteSummary? // Athlete summary representation, may be null
    var activityType: ActivityType = .ride
    var createdAt: Date?
    var route: RouteMeta? // Route meta representation, overview of the route with map
    var womanOnly: Bool = false
    var isPrivate: Bool = false
    var skillLevels: SkillLevel = .casual
    var terrain: Terrain?
    var upcomingOccurrences: [String] = []
    var address: String?
    var zone: String? // Event timezone
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["title"]
        description <- map["description"]
        club <- map["club"]
        organizingAthlete <- map["organizing_athlete"]
        activityType <- map["activity_type"]
        createdAt <- (map["created_at"], StravaDateTransform())
        route <- map["route"]
        womanOnly <- map["woman_only"]
        isPrivate <- map["private"]
        skillLevels <- map["skill_levels"]
        terrain <- map["terrain"]
        upcomingOccurrences <- map["upcoming_occurrences"]
        address <- map["address"]
        zone <- map["zone"]
    }
}
