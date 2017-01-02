//
//  Club.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 06/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public enum ClubType: String {
    case casualClub = "casual_club"
    case racingTeam = "racing_team"
    case shop = "shop"
    case company = "company"
    case other = "other"
}

public enum MembershipStatus: String {
    case member = "member"
    case pending = "pending"
}

public class Club: ClubSummary {
    var description: String?
    var clubType: ClubType = .other
    var membership: MembershipStatus? // Membership status of the requesting athlete "member", "pending", null (not a member and have not requested join)
    var admin: Bool = false // `true` only if the requesting athlete is a club admin
    var owner: Bool = false // `true` only if the requesting athlete is the club owner
    var followingCount: Int = 0 // Total number of members the authenticated user is currently following
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        description <- map["description"]
        clubType <- map["club_type"]
        membership <- map["membership"]
        admin <- map["admin"]
        owner <- map["owner"]
        followingCount <- map["following_count"]
    }
}
