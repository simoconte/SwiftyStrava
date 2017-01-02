//
//  Bike.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 06/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

public enum FrameType: Int {
    case MTB = 1
    case Cross
    case Road
    case TT
}

public class Bike: Gear {
    var frameType: FrameType?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        frameType <- map["frame_type"]
    }
}
