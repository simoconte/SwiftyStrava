//
//  ActivityZone.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 10/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper
import AlamofireObjectMapper

public enum ActivityZoneType: String {
    case heartrate = "heartrate"
    case power = "power"
}

public typealias DistributionBucket = (min: Int, max: Int, time: TimeInterval)

public class ActivityZone: Mappable {
    public var score: Int = 0
    public var type: ActivityZoneType?
    public var isSensorBased: Bool = false
    public var points: Int = 0
    public var isCustomZones: Bool?
    public var max: Int = 0
    public var resourceState: Int = -1
    public var distributionBuckets = [DistributionBucket]()
    
    required public init?(map: Map){ }
    
    public func mapping(map: Map) {
        resourceState <- map["resource_state"]
        score <- map["score"]
        type <- map["type"]
        isSensorBased <- map["sensor_based"]
        points <- map["points"]
        isCustomZones <- map["custom_zones"]
        max <- map["max"]
        distributionBuckets <- map["distribution_buckets"]
    }
    
}
