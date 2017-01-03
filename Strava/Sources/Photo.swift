//
//  Photo.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 14/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public class Photo: StravaObject {
    var activityId: Int64?
    var urls: [Int: String]? //map of requested size (the “size” parameter) to a URL for the photo resource
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
