//
//  Activity.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 13/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public class Activity: ActivitySummary {
    
    var calories: Float = 0 // Kilocalories, uses kilojoules for rides and speed/pace for runs
    var description: String?
    var gear: GearSummary?
    var segmentEfforts: [SegmentEffortSummary]?
    var splitsMetric: [SplitSummary]? // Running activities only
    var splitsStandard: [SplitSummary]? // Running activities only
    var bestEfforts: [SegmentEffortSummary]? // Running activities only
    var deviceName: String? // The name of the device used to record the activity.
    var embedToken: String? // The token used to embed a Strava activity in the form www.strava.com/activities/[activity_id]/embed/[embed_token].
    var photos: [Photo]?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        calories <- map["calories"]
        description <- map["description"]
        gear <- map["gear"]
        segmentEfforts <- map["segment_efforts"]
        splitsMetric <- map["splits_metric"]
        splitsStandard <- map["splits_standard"]
        bestEfforts <- map["best_efforts"]
        deviceName <- map["device_name"]
        embedToken <- map["embed_token"]
        photos <- map["photos"]
    }
}
