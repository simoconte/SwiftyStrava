//
//  RunningRaceSummary.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 19/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

enum RunningRaceType: Int {
    case road
    case trail
    case track
    case xc
}

public class RunningRaceSummary: StravaObject {
    var name: String = ""
    var runningRaceType: RunningRaceType = .road
    var distance: Float = 0
    var startDateLocal: Date?
    var city: String?
    var state: String?
    var country: String?
    var measurementPreference: MeasurementPreference = .meters
    var url: String?
    
    override public func mapping(map: Map) {
        name <- map["name"]
        runningRaceType <- map["running_race_type"]
        distance <- map["distance"]
        startDateLocal <- map["start_date_local"]
        city <- map["city"]
        state <- map["state"]
        country <- map["country"]
        measurementPreference <- map["measurement_preference"]
        url <- map["url"]
    }
}
