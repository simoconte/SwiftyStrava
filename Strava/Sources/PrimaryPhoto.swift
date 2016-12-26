//
//  PrimaryPhoto.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 06/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper

public enum PhotoSource: UInt8 {
    case strava = 1
    case instagram
}

open class PrimaryPhoto: Mappable {
    var id:	Int64?
    var source: PhotoSource?
    var uniqueId: String?
    var urls: AnyObject?
    
    required public init?(map: Map){}
    
    public func mapping(map: Map) {
        id <- map["id"]
        source <- map["source"]
        uniqueId <- map["unique_id"]
        urls <- map["urls"]
    }
}
