//
//  GroupEvent.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 26/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper

public enum SkillLevel: Int {
    case Casual = 1
    case Tempo
    case Hammerfast
}

public class GroupEvent: StravaObject {
    var title: String = ""
    var description: String = ""
    var clubId: Int = 0
    var organizingAthlete: AthleteSummary?
    var activityType: ActivityType = .run
    var createdAt: Date?
    var routeId: Int?
    var womanOnly: Bool = false
    var isPrivate: Bool = false
    var skillLevels: SkillLevel = .Casual
    var upcomingOccurrences: [String] = []
    var address: String = ""
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["title"]
        description <- map["description"]
        clubId <- map["club_id"]
        organizingAthlete <- map["organizing_athlete"]
        activityType <- map["activity_type"]
        createdAt <- map["created_at"]
        routeId <- map["route_id"]
        womanOnly <- map["woman_only"]
        isPrivate <- map["private"]
        skillLevels <- map["skill_levels"]
        upcomingOccurrences <- map["upcoming_occurrences"]
        address <- map["address"]
    }
}
