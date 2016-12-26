//
//  ActivitySummary.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 13/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper

public enum ActivityType: String {
    case Ride = "Ride"
    case Run = "Run"
    case Swim = "Swim"
    case Hike = "Hike"
    case Walk = "Walk"
    case AlpineSki = "AlpineSki"
    case BackcountrySki = "BackcountrySki"
    case Canoeing = "Canoeing"
    case Crossfit = "Crossfit"
    case EBikeRide = "EBikeRide"
    case Elliptical = "Elliptical"
    case IceSkate = "IceSkate"
    case InlineSkate = "InlineSkate"
    case Kayaking = "Kayaking"
    case Kitesurf = "Kitesurf"
    case NordicSki = "NordicSki"
    case RockClimbing = "RockClimbing"
    case RollerSki = "RollerSki"
    case Rowing = "Rowing"
    case Snowboard = "Snowboard"
    case Snowshoe = "Snowshoe"
    case StairStepper = "StairStepper"
    case StandUpPaddling = "StandUpPaddling"
    case Surfing = "Surfing"
    case VirtualRide = "VirtualRide"
    case WeightTraining = "WeightTraining"
    case Windsurf = "Windsurf"
    case Workout = "Workout"
}

public enum WorkoutType: Int {
    case defaultRun = 0
    case runRace
    case long
    case defaultRide = 10
    case rideRace
    case workout
}

typealias GeoCoordinate = (lat: Double, long: Double)

open class ActivitySummary: StravaObject {
    var externalId: String?
    var uploadId: Int = 0
    var athlete: AthleteSummary?
    var name: String?
    var distance: Float = 0
    var movingTime: Int = 0
    var elapsedTime: Int = 0
    var totalElevationGain: Float = 0
    var elevationHigh: Float = 0
    var elevationLow: Float = 0
    var type: ActivityType = .Ride
    var startDate: Date?
    var startDateLocal: Date?
    var timeZone: String?
    var startCoordinate: GeoCoordinate?
    var endCoordinate: GeoCoordinate?
    var achievementCount: Int = 0
    var kudosCount: Int = 0
    var commentsCount: Int = 0
    var athleteCount: Int = 1
    var instagramPhotoCount: Int = 0
    var totalPhotoCount: Int = 0
    var route: Route?
    var isTrainer: Bool = false
    var isCommute: Bool = false
    var isManual: Bool = false
    var isPrivate: Bool = false
    var flagged: Bool = false
    var workoutType: WorkoutType?
    var gearId: String?
    var averageSpeed: Float = 0 // Meters per second
    var maxSpeed: Float = 0 // Meters per second
    var averageCadence: Float? // RPM
    var averageTemperature: Float? // Degrees Celsius
    var averageWatts: Float? // Rides only
    var maxWatts: Int? // Rides only
    var weightedAverageWatts: Int? // Rides with power meter data only similar to xPower or Normalized Power
    var kiloJoules: Float = 0 // Rides only uses estimated power if necessary
    var deviceWatts: Bool = false
    var hasHeartrate: Bool = false
    var averageHeartrate: Float = 0
    var maxHeartrate: Int?
    var sufferScore: Int? // A measure of heartrate intensity, available on premium users’ activities only
    var hasKudoed: Bool = false
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        externalId <- map["external_id"]
        uploadId <- map["upload_id"]
        athlete <- map["athlete"]
        name <- map["name"]
        distance <- map["distance"]
        movingTime <- map["moving_time"]
        elapsedTime <- map["elapsed_time"]
        totalElevationGain <- map["total_elevation_gain"]
        elevationHigh <- map["elevation_high"]
        elevationLow <- map["elevation_low"]
        type <- map["type"]
        startDate <- map["start_date"]
        startDateLocal <- map["start_date_local"]
        timeZone <- map["timezone"]
        startCoordinate <- map["start_latlng"]
        endCoordinate <- map["end_latlng"]
        achievementCount <- map["achievement_count"]
        kudosCount <- map["kudos_count"]
        commentsCount <- map["comment_count"]
        athleteCount <- map["athlete_count"]
        instagramPhotoCount <- map["photo_count"]
        totalPhotoCount <- map["total_photo_count"]
        route <- map["map"]
        isTrainer <- map["trainer"]
        isCommute <- map["commute"]
        isManual <- map["manual"]
        isPrivate <- map["private"]
        flagged <- map["flagged"]
        workoutType <- map["workout_type"]
        gearId <- map["gear_id"]
        averageSpeed <- map["average_speed"]
        maxSpeed <- map["max_speed"]
        averageCadence <- map["average_cadence"]
        averageTemperature <- map["average_temp"]
        averageWatts <- map["average_watts"]
        maxWatts <- map["max_watts"]
        weightedAverageWatts <- map["weighted_average_watts"]
        kiloJoules <- map["kilojoules"]
        deviceWatts <- map["device_watts"]
        hasHeartrate <- map["has_heartrate"]
        averageHeartrate <- map["average_heartrate"]
        maxHeartrate <- map["max_heartrate"]
        sufferScore <- map["suffer_score"]
        hasKudoed <- map["has_kudoed"]
    }
    
}
