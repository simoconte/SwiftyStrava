//
//  Announcement.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 26/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper

open class Announcement: StravaObject {
    
    var clubId: Int = 0
    var createdAt: Date?
    var athlete: AthleteSummary?
    var message: String = ""
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        clubId <- map["club_id"]
        createdAt <- map["created_at"]
        athlete <- map["athlete"]
        message <- map["message"]
    }

}
