//
//  InstagramPhoto.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 06/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public class InstagramPhoto: Photo {
    var ref: String?
    var uid: String?
    var type: String = "InstagramPhoto" // Photo source, currently only InstagramPhoto
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        ref <- map["ref"]
        uid <- map["uid"]
        type <- map["uid"]
    }
}
