//
//  ClubSummary.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 07/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public enum SportType: String {
    case cycling = "cycling"
    case running = "running"
    case triathlon = "triathlon"
    case other = "other"
}

public class ClubSummary: StravaObject {
    var name: String?
    var profileMedium: String? // URL to a 60x60 pixel profile picture
    var profile: String? // URL to a 124x124 pixel profile picture
    var coverPhoto: String? // URL to a ~1185x580 pixel cover photo
    var coverPhotoSmall: String? // URL to a ~360x176 pixel cover photo
    var sportType: SportType = .other
    var city: String?
    var state: String?
    var country: String?
    var isPrivate: Bool = true
    var memberCount: Int = 0
    var featured: Bool = false
    var verified: Bool = false
    var url: String? // Vanity club URL slug
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        profileMedium <- map["profile_medium"]
        profile <- map["profile"]
        coverPhoto <- map["cover_photo"]
        coverPhotoSmall <- map["cover_photo_small"]
        sportType <- map["sport_type"]
        city <- map["city"]
        state <- map["state"]
        country <- map["country"]
        isPrivate <- map["private"]
        memberCount <- map["member_count"]
        featured <- map["featured"]
        verified <- map["verified"]
        url <- map["url"]
    }
}
