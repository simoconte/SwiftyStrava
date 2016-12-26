//
//  ActivityUploadStatus.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 21/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

open class ActivityUploadStatus: Mappable {
    
    var id: Int64?
    var externalId: String?
    var error: String? = nil
    var status: String? = nil
    var activityId: Int64? = nil
    
    required public init?(map: Map){}
    
    public func mapping(map: Map) {
        id <- map["id"]
        externalId <- map["external_id"]
        error <- map["error"]
        status <- map["status"]
        activityId <- map["activity_id"]
    }
}
