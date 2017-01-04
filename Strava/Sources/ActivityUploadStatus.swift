//
//  ActivityUploadStatus.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 21/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public class ActivityUploadStatus: Mappable {
    
    var id: Int64?
    var externalId: String?
    /// If there was an error during processing, this will contain a human a human readable error message that may include escaped HTML
    var error: String? = nil
    /// Describes the error, possible values: ‘Your activity is still being processed.’, ‘The created activity has been deleted.’, ‘There was an error processing your activity.’, ‘Your activity is ready.’
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
