//
//  Photo.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 14/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper

public class Photo: StravaObject {
    var activityId: Int64?
    var urls: AnyObject?
    var caption: String?
    var source: PhotoSource?
    var uploadedAt: Date?
    var createdAt: Date?
    var location: GeoCoordinate?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        activityId <- map["activity_id"]
        urls <- map["urls"]
        caption <- map["caption"]
        source <- map["source"]
        uploadedAt <- map["uploaded_at"]
        createdAt <- map["created_at"]
        location <- map["location"]
    }
}
