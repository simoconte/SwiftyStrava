//
//  AthleteSummary.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 07/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public enum Gender: String {
    case Male = "M"
    case Female = "F"
}

public enum FollowingStatus: String {
    case Pending = "pending"
    case Accepted = "accepted"
    case Blocked = "blocked"
}
    
open class AthleteSummary: StravaObject {
    // Profile
    var firstName: String = ""
    var lastName: String = ""
    var profileMedium: String? // URL to a 62x62 pixel profile picture
    var profile: String? // URL to a 124x124 pixel profile picture
    var city: String?
    var state: String?
    var country: String?
    var sex: Gender?
    var friend: FollowingStatus? // The authenticated athlete’s following status of this athlete
    var follower: FollowingStatus? // This athlete’s following status of the authenticated athlete
    var premium: Bool = false
    var createdAt: Date?
    var updatedAt: Date?
    
    override public func mapping(map: Map) {
        firstName <- map["firstname"]
        lastName <- map["lastname"]
        profileMedium <- map["profile_medium"]
        profile <- map["profile"]
        city <- map["city"]
        state <- map["state"]
        country <- map["country"]
        sex <- map["sex"]
        friend <- map["friend"]
        follower <- map["follower"]
        premium <- map["premium"]
        createdAt <- (map["created_at"], StravaDateTransform())
        updatedAt <- (map["updated_at"], StravaDateTransform())
    }
}
