//
//  InstagramPhoto.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 06/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper

public class InstagramPhoto: Photo {
    var ref: String?
    var uid: String?
    var type: String = "InstagramPhoto"
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        ref <- map["ref"]
        uid <- map["uid"]
        type <- map["uid"]
    }
}
