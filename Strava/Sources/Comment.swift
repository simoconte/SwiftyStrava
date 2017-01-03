//
//  Comment.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 05/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper

public class Comment: StravaObject {
    
    var activityId: Int64?
    var text: String?
    var athlete: AthleteSummary?
    var createdAt: Date?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        activityId <- map["activity_id"]
        text <- map["text"]
        athlete <- map["athlete"]
        createdAt <- (map["created_at"], StravaDateTransform())
    }
}
