//
//  PhotoSummary.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 06/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

open class PhotoSummary: Mappable {
    var count: UInt8 = 1 // Total number of photos (Instagram + nativ
    var primary: PrimaryPhoto?
    
    required public init?(map: Map){}
    
    public func mapping(map: Map) {
        count <- map["count"]
        primary <- map["primary"]
    }
}
