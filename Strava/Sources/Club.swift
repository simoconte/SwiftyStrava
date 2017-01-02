//
//  Club.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 06/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public enum ClubType: String {
    case CasualClub = "casual_club"
    case RacingTeam = "racing_team"
    case Shop = "shop"
    case Company = "company"
    case Other = "other"
}

public enum MembershipStatus: String {
    case Member = "member"
    case Pending = "pending"
}

public class Club: ClubSummary {
    var description: String?
    var clubType: ClubType = .Other
    var membership: MembershipStatus? // Membership status of the requesting athlete "member", "pending", null (not a member and have not requested join)
    var admin: Bool = false // `true` only if the requesting athlete is a club admin
    var owner: Bool = false // `true` only if the requesting athlete is the club owner
    var followingCount: Int? // Total number of members the authenticated user is currently following
    
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
