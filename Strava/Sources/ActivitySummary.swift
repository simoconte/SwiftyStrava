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
    case ride = "Ride"
    case run = "Run"
    case swim = "Swim"
    case hike = "Hike"
    case walk = "Walk"
    case alpineSki = "AlpineSki"
    case backcountrySki = "BackcountrySki"
    case canoeing = "Canoeing"
    case crossfit = "Crossfit"
    case eBikeRide = "EBikeRide"
    case elliptical = "Elliptical"
    case iceSkate = "IceSkate"
    case inlineSkate = "InlineSkate"
    case kayaking = "Kayaking"
    case kitesurf = "Kitesurf"
    case nordicSki = "NordicSki"
    case rockClimbing = "RockClimbing"
    case rollerSki = "RollerSki"
    case rowing = "Rowing"
    case snowboard = "Snowboard"
    case snowshoe = "Snowshoe"
    case stairStepper = "StairStepper"
    case standUpPaddling = "StandUpPaddling"
    case surfing = "Surfing"
    case virtualRide = "VirtualRide"
    case weightTraining = "WeightTraining"
    case windsurf = "Windsurf"
    case workout = "Workout"
}

public enum WorkoutType: Int {
    case defaultRun = 0
    case runRace
    case long
    case defaultRide = 10
    case rideRace
    case workout
}

public typealias GeoCoordinate = (lat: Double, long: Double)

public class ActivitySummary: StravaObject {
    var externalId: String? // Provided at upload
    var uploadId: Int64?
    var athlete: AthleteSummary?
    var name: String?
    var distance: Float = 0 // Meters
    var movingTime: Int = 0 // Seconds
    var elapsedTime: Int = 0 // Seconds
    var totalElevationGain: Float = 0 // Meters
    var elevationHigh: Float = 0 // Meters
    var elevationLow: Float = 0 // Meters
    var type: ActivityType = .ride
    var startDate: Date?
    var startDateLocal: Date?
    var timeZone: String?
    var startCoordinate: GeoCoordinate?
    var endCoordinate: GeoCoordinate?
    var achievementCount: Int = 0
    var kudosCount: Int = 0
    var commentsCount: Int = 0
    var athleteCount: Int = 1 // Number of athletes taking part in this “group activity”.
    var instagramPhotoCount: Int = 0 // Number of Instagram photos
    var totalPhotoCount: Int = 0 // Total number of photos (Instagram and Strava)
    var route: Route? // Detailed representation of the route
    var isTrainer: Bool = false
    var isCommute: Bool = false
    var isManual: Bool = false
    var isPrivate: Bool = false
    var flagged: Bool = false
    var workoutType: WorkoutType?
    var gearId: String? // Corresponds to a bike or pair of shoes included in
    var averageSpeed: Float = 0 // Meters per second
    var maxSpeed: Float = 0 // Meters per second
    var averageCadence: Float? // RPM
    var averageTemperature: Float? // Degrees Celsius
    var averageWatts: Float? // Rides only
    var maxWatts: Int? // Rides only
    var weightedAverageWatts: Int? // Rides with power meter data only similar to xPower or Normalized Power
    var kiloJoules: Float = 0 // Rides only uses estimated power if necessary
    var deviceWatts: Bool = false // `true` if the watts are from a power meter, false if estimated
    var hasHeartrate: Bool = false // `true` if recorded with heartrate
    var averageHeartrate: Float = 0 // Only if recorded with heartrate average over moving portion
    var maxHeartrate: Int? // Only if recorded with heartrate
    var sufferScore: Int? // A measure of heartrate intensity, available on premium users’ activities only
    var hasKudoed: Bool = false // `true` if the authenticated athlete has kudoed this activity
    
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
