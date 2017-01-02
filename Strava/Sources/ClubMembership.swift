//
//  ClubMembership.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 02/11/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public class ClubMembership: StravaObject {
    var success: Bool = false
    var active: Bool = false
    var membership: MembershipStatus?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        success <- map["success"]
        active <- map["active"]
        membership <- map["membership"]
    }
}
