//
//  Leaderboard.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 18/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper

open class Leaderboard: Mappable {
    required public init?(map: Map){}
    
    var entryCount = 0
    var entries = [LeaderboardEntry]()
    
    public func mapping(map: Map) {
        entryCount <- map["entry_count"]
        entries <- map["entries"]
    }
}
