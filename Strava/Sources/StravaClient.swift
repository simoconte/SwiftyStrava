//
//  StravaClient.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 11/08/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

public enum StravaAccessScope: String {
    case `public` = "public"
    case write = "write"
    case viewPrivate = "view_private"
    case full = "view_private,write"
}

public class StravaClient: NSObject {
    
    /// Singleton instantiation
    public static let instance = StravaClient()
    
    public static let baseURL: String = "https://www.strava.com/api/v3"
    
    fileprivate var callbackURL: String?// = "facewind://io.limlab.facewind"
    fileprivate var authToken: String?
    fileprivate var clientId: Int64?
    fileprivate var clientSecret: String?
    
    /// Configure `StravaClient`. It's important to call this method before `StravaClient` usage.
    ///
    /// - Parameters:
    ///   - clientId:     application’s ID, obtained during registration
    ///   - clientSecret: application’s secret, obtained during registration
    ///   - callbackURL:  URL Scheme value. [See more...](http://limlab.io)
    public func configure(clientId: Int64, clientSecret: String, callbackURL: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.callbackURL = callbackURL
    }
}

/*
 Authentication
 */
public typealias LoginCredentials = (clientId: String, clientSecret: String, code: String)

public extension StravaClient {
    public func oAuth() {
        guard let clientId = clientId else {
            print("Stava `clientId` is not set up!")
            return
        }
        
        guard let url = URL(string: "https://www.strava.com/oauth/authorize?client_id=\(clientId)&response_type=code&redirect_uri=\(callbackURL)&scope=\(StravaAccessScope.full.rawValue)&approval_prompt=force") else {
            print("Error: URL malformed!")
            return
        }
        
        UIApplication.shared.openURL(url)
//        StravaClient.instance.configure(clientId: <#T##Int64#>, clientSecret: <#T##String#>, callbackURL: <#T##String#>)
    }
    
    public func parseURL(_ url: URL) {
        guard let comps = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Error! App is not authorized! URL: \(url)")
            return
        }
        
        guard let clientId = clientId,
            let clientSecret = clientSecret,
            let code = (comps.queryItems?.filter { $0.name == "code" })?.first?.value else {
            print("Stava `clientId` or `clientSecret` is not set up!")
            return
        }
        
        // TODO (1): Make a callback for credentials saving. It should be up to developer
        UserDefaults.standard.setValue(clientSecret, forKey: "clientSecret")
        UserDefaults.standard.setValue(clientId, forKey: "clientId")
        UserDefaults.standard.setValue(code, forKey: "code")
        UserDefaults.standard.synchronize()
    }
    
    public func loginCredentials() -> LoginCredentials? {
        // TODO (1): Improve
        guard let clientId = UserDefaults.standard.value(forKey: "clientId") as? String,
            let clientSecret = UserDefaults.standard.value(forKey: "clientSecret") as? String,
            let code = UserDefaults.standard.value(forKey: "code") as? String else {
            print("Info: No available Login Credentials. Try to login via OAuth!")
            return nil
        }
        
        return (clientId: clientId, clientSecret: clientSecret, code: code)
    }
    
    public func authorize(completion:@escaping (_ authResponse: StravaResponse<Auth>) -> Void) {
        guard let credentials = loginCredentials() else {
            // TODO: return normal value
            return
        }
        
        var req = StravaRequest<Auth>()
        req.method = .post
        req.url = "https://www.strava.com/oauth/token"
        req.addParam("client_id", value: credentials.clientId)
        req.addParam("code", value: credentials.code)
        req.addParam("client_secret", value: credentials.clientSecret)
        req.requestObject { (response: StravaResponse<Auth>) in
            switch response {
            case .Success(let auth):
                self.authToken = auth.accessToken
            case .Failure(let err):
                print("^ \(err.message)")
            }
            completion(response)
        }
    }
    
    public func deauthorize(completion:@escaping (_ authResponse: StravaResponse<Deauth>) -> Void) {
        var req = StravaRequest<Deauth>()
        req.method = .post
        req.url = "https://www.strava.com/oauth/deauthorize"
        req.addToken(token: StravaClient.instance.authToken!)
        req.requestObject { (response: StravaResponse<Deauth>) in
            switch response {
            case .Success:
                self.authToken = nil
            case .Failure(let err):
                print("^ \(err.message)")
            }
            completion(response)
        }
    }
}


/*
 Athletes
 */
public extension StravaClient {
    func retrieveAthlete(athleteId: Int? = nil,
                         completionHandler: @escaping (StravaResponse<Athlete>) -> Void) {
        var req = StravaRequest<Athlete>()
        if let id = athleteId {
            req.pathComponent = "/athletes/\(id)"
        } else {
            req.pathComponent = "/athlete"
        }
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completionHandler)
    }
    
    func listAthletesFriends(athleteId: Int? = nil,
                             page: Int = 0,
                             perPage: Int = 0,
                             completionHandler: @escaping (StravaResponse<[AthleteSummary]>) -> Void) {
        var req = StravaRequest<AthleteSummary>()
        if let id = athleteId {
            req.pathComponent = "/athletes/\(id)/friends"
        } else {
            req.pathComponent = "/athlete/friends"
        }
        
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("per_page", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func listAthletesFollowers(athleteId: Int? = nil,
                               page: Int = 0,
                               perPage: Int = 0,
                               completionHandler: @escaping (StravaResponse<[AthleteSummary]>) -> Void) {
        var req = StravaRequest<AthleteSummary>()
        if let id = athleteId {
            req.pathComponent = "/athletes/\(id)/followers"
        } else {
            req.pathComponent = "/athlete/followers"
        }
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("per_page", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func listAthletesBothFollowing(athleteId: Int,
                                   page: Int = 0,
                                   perPage: Int = 0,
                                   completionHandler: @escaping (StravaResponse<[AthleteSummary]>) -> Void) {
        var req = StravaRequest<AthleteSummary>()
        req.pathComponent = "/athletes/\(athleteId)/both-following"
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("per_page", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func retrieveAthletesZones(completionHandler: @escaping (StravaResponse<Zones>) -> Void) {
        var req = StravaRequest<Zones>()
        req.pathComponent = "/athlete/zones"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completionHandler)
    }
    
    func retrieveAthletesTotalsAndStats(athleteId: Int,
                                        completionHandler: @escaping (StravaResponse<Stats>) -> Void) {
        var req = StravaRequest<Stats>()
        req.pathComponent = "/athlete/stats"
        req.method = .get
        req.addParam("id", value: athleteId)
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completionHandler)
    }
    
    func listAthletesKOMs(athleteId: Int,
                          page: Int = 0,
                          perPage: Int = 0,
                          completionHandler: @escaping (StravaResponse<[SegmentEffortSummary]>) -> Void) {
        var req = StravaRequest<SegmentEffortSummary>()
        req.pathComponent = "/athletes/\(athleteId)/koms"
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("per_page", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    
    func updateAthlete(city: String? = nil,
                       state: String? = nil,
                       sex: Gender? = nil,
                       weight: Float? = nil,
                       completionHandler: @escaping (StravaResponse<Athlete>) -> Void) {
        var req = StravaRequest<Athlete>()
        req.pathComponent = "/athlete"
        req.method = .put
        req.addParam("city", value: city)
        req.addParam("state", value: state)
        req.addParam("sex", value: sex)
        req.addParam("weight", value: weight)
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completionHandler)
    }
}

/*
 Activities
 */
public extension StravaClient {
    
    // Comments
    func listActivityComments(activityId: String,
                              page: Int = 0,
                              perPage: Int = 0,
                              completionHandler: @escaping (StravaResponse<[Comment]>) -> Void) {
        var req = StravaRequest<Comment>()
        req.pathComponent = "/activities/\(activityId)/comments"
        
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("per_page", value: perPage)
        }
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    // Kudoers
    func listActivityKudoers(activityId: String,
                              page: Int = 0,
                              perPage: Int = 0,
                              completionHandler: @escaping (StravaResponse<[AthleteSummary]>) -> Void) {
        var req = StravaRequest<AthleteSummary>()
        req.pathComponent = "/activities/\(activityId)/kudos"
        
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("per_page", value: perPage)
        }
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    // Kudoers
    func listActivityPhotos(activityId: String, completionHandler: @escaping (StravaResponse<[Photo]>) -> Void) {
        var req = StravaRequest<Photo>()
        req.pathComponent = "/activities/\(activityId)/photos?photo_sources=true"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func createAnActivity(name: String,
                          activityType: ActivityType,
                          startDate: Date,
                          elapsedTime: TimeInterval,
                          description: String?,
                          distance: Float?,
                          isPrivate: Bool,
                          isTrainer: Bool,
                          isCommute: Bool?,
                          completionHandler: @escaping (StravaResponse<Activity>) -> Void) {
        var req = StravaRequest<Activity>()
        req.pathComponent = "/activities"
        req.method = .post
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.addParam("name", value: name)
        req.addParam("type", value: activityType.rawValue)
        req.addParam("start_date_local", value: startDate.toISO8601String())
        req.addParam("elapsed_time", value: elapsedTime)
        req.addParam("description", value: description)
        req.addParam("distance", value: distance)
        req.addParam("private", value: isPrivate)
        req.addParam("trainer", value: isTrainer)
        if let isCommute = isCommute {
            req.addParam("commute", value: isCommute ? 1 : 0)
        }
        
        req.requestObject(completionHandler)
    }
    
    func retrieveAnActivity(activityId: Int64, includeAllEfforts: Bool = false, completionHandler: @escaping (StravaResponse<Activity>) -> Void) {
        var req = StravaRequest<Activity>()
        req.pathComponent = "/activities/\(activityId)"
        req.method = .get
        req.addParam("include_all_efforts", value: includeAllEfforts)
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completionHandler)
    }
    
    func updateAnActivity(activityId: Int64,
                          name: String,
                          activityType: ActivityType?,
                          description: String?,
                          isPrivate: Bool = false,
                          isTrainer: Bool = false,
                          isCommute: Bool = false,
                          gearId: String? = nil, //‘none’ clears gear from activity
                          completionHandler: @escaping (StravaResponse<Activity>) -> Void) {
        var req = StravaRequest<Activity>()
        req.pathComponent = "/activities/\(activityId)"
        req.method = .put
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.addParam("name", value: name)
        req.addParam("type", value: activityType?.rawValue)
        req.addParam("description", value: description)
        req.addParam("gear_id", value: gearId)
        req.addParam("private", value: isPrivate)
        req.addParam("trainer", value: isTrainer)
        req.addParam("commute", value: isCommute ? 1 : 0)
        
        req.requestObject(completionHandler)
    }
    
    func deleteAnActivity(activityId: Int64, completionHandler: @escaping (Bool, StravaError?) -> Void) {
        var req = StravaRequest<StravaObject>()
        req.pathComponent = "/activities/\(activityId)"
        req.method = .delete
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestWithSuccessConfirmation(completionHandler)
    }
    
    func listAthletesActivities(afterDate: Date?,
                                beforeDate: Date?,
                                page: Int = 0,
                                perPage: Int = 0,
                                completionHandler: @escaping (StravaResponse<[ActivitySummary]>) -> Void) {
        var req = StravaRequest<ActivitySummary>()
        req.pathComponent = "/athlete/activities"
        req.method = .get
        
        req.addParam("before", value: beforeDate?.timeIntervalSince1970)
        req.addParam("after", value: afterDate?.timeIntervalSince1970)
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("per_page", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func listRelatedActivities(activityId: Int64,
                               page: Int = 0,
                               perPage: Int = 0,
                               completionHandler: @escaping (StravaResponse<[ActivitySummary]>) -> Void) {
        var req = StravaRequest<ActivitySummary>()
        req.pathComponent = "/activities/\(activityId)/related"
        req.method = .get
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("per_page", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func listFriendsActivities(beforeDate: Date?,
                                page: Int = 0,
                                perPage: Int = 0,
                                completionHandler: @escaping (StravaResponse<[ActivitySummary]>) -> Void) {
        var req = StravaRequest<ActivitySummary>()
        req.pathComponent = "/activities/following"
        req.method = .get
        
        req.addParam("before", value: beforeDate?.timeIntervalSince1970)
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("per_page", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func listActivityZones(activityId: Int64,
                           completionHandler: @escaping (StravaResponse<[ActivityZone]>) -> Void) {
        var req = StravaRequest<ActivityZone>()
        req.pathComponent = "/activities/\(activityId)/zones"
        req.method = .get
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func listActivityLaps(activityId: Int64,
                           completionHandler: @escaping (StravaResponse<[Lap]>) -> Void) {
        var req = StravaRequest<Lap>()
        req.pathComponent = "/activities/\(activityId)/laps"
        req.method = .get
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
}

/*
 Clubs
 */
public extension StravaClient {
    func retrieveAClub(clubId: String, completionHandler: @escaping (StravaResponse<Club>) -> Void) {
        var req = StravaRequest<Club>()
        req.pathComponent = "/clubs/\(clubId)"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completionHandler)
    }
    
    func listClubAnnouncements(clubId: String, completionHandler: @escaping (StravaResponse<[Announcement]>) -> Void) {
        var req = StravaRequest<Announcement>()
        req.pathComponent = "/clubs/\(clubId)/announcements"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func listClubGroupEvents(clubId: String, completionHandler: @escaping (StravaResponse<[GroupEvent]>) -> Void) {
        var req = StravaRequest<GroupEvent>()
        req.pathComponent = "/clubs/\(clubId)/group_events"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func listAthleteClubs(completionHandler: @escaping (StravaResponse<[ClubSummary]>) -> Void) {
        var req = StravaRequest<ClubSummary>()
        req.pathComponent = "/athlete/clubs"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func listClubMembers(clubId: String, page: Int = 0, perPage: Int = 0, completionHandler: @escaping (StravaResponse<[AthleteSummary]>) -> Void) {
        var req = StravaRequest<AthleteSummary>()
        req.pathComponent = "/clubs/\(clubId)/members"
        req.method = .get
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("per_page", value: perPage)
        }
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func listClubAdmins(clubId: String, page: Int = 0, perPage: Int = 0, completionHandler: @escaping (StravaResponse<[AthleteSummary]>) -> Void) {
        var req = StravaRequest<AthleteSummary>()
        req.pathComponent = "/clubs/\(clubId)/admins"
        req.method = .get
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("per_page", value: perPage)
        }
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func listClubActivities(clubId: String, before: Date? = nil, page: Int = 0, perPage: Int = 0, completionHandler: @escaping (StravaResponse<[ActivitySummary]>) -> Void) {
        var req = StravaRequest<ActivitySummary>()
        req.pathComponent = "/clubs/\(clubId)/activities"
        req.method = .get
        if let before = before {
            req.addParam("before", value: "\(before.timeIntervalSince1970)")
        }
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("per_page", value: perPage)
        }
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func joinClub(clubId: String, completionHandler: @escaping (StravaResponse<ClubMembership>) -> Void) {
        var req = StravaRequest<ClubMembership>()
        req.pathComponent = "/clubs/\(clubId)/join"
        req.method = .post
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completionHandler)
    }
    
    func leaveAClub(clubId: String, completionHandler: @escaping (StravaResponse<ClubMembership>) -> Void) {
        var req = StravaRequest<ClubMembership>()
        req.pathComponent = "/clubs/\(clubId)/leave"
        req.method = .post
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completionHandler)
    }
    
}

/*
 Gear
 */
public extension StravaClient {
    func retrieveGear<T: Gear>(gearId: String, completionHandler: @escaping (StravaResponse<T>) -> Void) {
        var req = StravaRequest<T>()
        req.pathComponent = "/gear/\(gearId)"
        req.method = .get
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completionHandler)
    }
}

/* 
 Routes
 */
public extension StravaClient {
    func retrieveARoute(routeId: Int64, completionHandler: @escaping (StravaResponse<Route>) -> Void) {
        var req = StravaRequest<Route>()
        req.pathComponent = "/routes/\(routeId)"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completionHandler)
    }
    
    func listRoutes(athleteId: Int64, completionHandler: @escaping (StravaResponse<[RouteSummary]>) -> Void) {
        var req = StravaRequest<RouteSummary>()
        req.pathComponent = "/athletes/\(athleteId)/routes"
        req.method = .get
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
}

/*
 Running Races
 */
public extension StravaClient {
    func listRoutes(year: Int? = nil, completionHandler: @escaping (StravaResponse<[RunningRaceSummary]>) -> Void) {
        var req = StravaRequest<RunningRaceSummary>()
        req.pathComponent = "/running_races"
        req.method = .get
        
        req.addParam("year", value: year)
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func retrieveRaceDetails(raceId: Int64, completionHandler: @escaping (StravaResponse<RunningRace>) -> Void) {
        var req = StravaRequest<RunningRace>()
        req.pathComponent = "/running_races/\(raceId)"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completionHandler)
    }
}

/*
 Segments
 */
public extension StravaClient {
    func retrieveASegment(segmentId: Int64, completionHandler: @escaping (StravaResponse<Segment>) -> Void) {
        var req = StravaRequest<Segment>()
        req.pathComponent = "/segments/\(segmentId)"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completionHandler)
    }
    
    func listStarredSegments(page: Int = 0, perPage: Int = 0, completionHandler: @escaping (StravaResponse<[SegmentSummary]>) -> Void) {
        var req = StravaRequest<SegmentSummary>()
        req.pathComponent = "/segments/starred"
        req.method = .get
        
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("per_page", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func starASegment(segmentId: Int64, starred: Bool, completionHandler: @escaping (StravaResponse<Segment>) -> Void) {
        var req = StravaRequest<Segment>()
        req.pathComponent = "/segments/\(segmentId)/starred"
        req.method = .put
        req.addParam("starred", value: starred)
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completionHandler)
    }
    
    func listEfforts(segmentId: Int64,
                     athleteId: Int64,
                     startDateLocal: Date?,
                     endDateLocal: Date?,
                     page: Int = 0,
                     perPage: Int = 0,
                     completionHandler: @escaping (StravaResponse<[ActivitySummary]>) -> Void) {
        var req = StravaRequest<ActivitySummary>()
        req.pathComponent = "/segments/\(segmentId)/all_efforts"
        req.method = .get
        
        req.addParam("id", value: athleteId)
        req.addParam("start_date_local", value: startDateLocal?.toISO8601String())
        req.addParam("end_date_local", value: endDateLocal?.toISO8601String())
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("per_page", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func segmentLeaderboards(segmentId: Int64,
                     gender: Gender,
                     ageGroup: AgeGroup?,
                     weightClass: WeightClass? = nil,
                     isFollowing: Bool? = nil,
                     clubId: Int64? = nil,
                     dateRange: DateRange? = nil,
                     contextEntries: Int = 2,
                     page: Int = 0,
                     perPage: Int = 0,
                     completionHandler: @escaping (StravaResponse<[ActivitySummary]>) -> Void) {
        var req = StravaRequest<ActivitySummary>()
        req.pathComponent = "/segments/\(segmentId)/all_efforts"
        req.method = .get
        
        req.addParam("id", value: segmentId)
        req.addParam("gender", value: gender.rawValue)
        req.addParam("age_group", value: ageGroup?.rawValue)
        req.addParam("weight_class", value: weightClass?.rawValue)
        req.addParam("following", value: isFollowing)
        req.addParam("club_id", value: clubId)
        req.addParam("date_range", value: dateRange?.rawValue)
        req.addParam("context_entries", value: contextEntries)
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("per_page", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func segmentExplorer(bounds: Bounds,
                         activityType: ActivityType? = .ride,
                         minClimbCategory: ClimbCategory? = nil,
                         maxClimbCategory: ClimbCategory? = nil,
                         completionHandler: @escaping (StravaResponse<[SegmentSummary]>) -> Void) {
        var req = StravaRequest<SegmentSummary>()
        req.pathComponent = "/segments/explore"
        req.method = .get
        
        req.addParam("bounds", value: bounds.toString())
        req.addParam("activity_type", value: activityType?.rawValue)
        req.addParam("min_cat", value: minClimbCategory)
        req.addParam("max_cat", value: maxClimbCategory)
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
}

/*
 Segment Efforts
 */
public extension StravaClient {
    func retrieveASegmentEffort(effortId: Int64, completionHandler: @escaping (StravaResponse<SegmentEffort>) -> Void) {
        var req = StravaRequest<SegmentEffort>()
        req.pathComponent = "/segment_efforts/\(effortId)"
        req.method = .get
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completionHandler)
    }
}

/*
 Streams
 */
public extension StravaClient {
    func retrieveActivityStreams(activityId: Int64,
                                 types: [StreamType],
                                 resolution: Resolution? = nil,
                                 seriesType: SeriesType? = nil,
                                 completionHandler: @escaping (StravaResponse<[Stream]>) -> Void) {
        let strTypes = types.map { $0.rawValue }
        var req = StravaRequest<Stream>()
        req.pathComponent = "/activities/\(activityId)/streams/\(strTypes.joined(separator: ","))"
        req.method = .get
        
        if let resolution = resolution {
            req.addParam("resolution", value: resolution.rawValue)
            req.addParam("series_type", value: seriesType?.rawValue)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func retrieveEffortStreams(effortId: Int64,
                                 types: [StreamType],
                                 resolution: Resolution? = nil,
                                 seriesType: SeriesType? = nil,
                                 completionHandler: @escaping (StravaResponse<[Stream]>) -> Void) {
        let strTypes = types.map { $0.rawValue }
        var req = StravaRequest<Stream>()
        req.pathComponent = "/segment_efforts/\(effortId)/streams/\(strTypes.joined(separator: ","))"
        req.method = .get
        
        if let resolution = resolution {
            req.addParam("resolution", value: resolution.rawValue)
            req.addParam("series_type", value: seriesType?.rawValue)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func retrieveSegmentStreams(segmentId: Int64,
                               types: [StreamType],
                               resolution: Resolution? = nil,
                               seriesType: SeriesType? = nil,
                               completionHandler: @escaping (StravaResponse<[Stream]>) -> Void) {
        let strTypes = types.map { $0.rawValue }
        var req = StravaRequest<Stream>()
        req.pathComponent = "/segment_efforts/\(segmentId)/streams/\(strTypes.joined(separator: ","))"
        req.method = .get
        
        if let resolution = resolution {
            req.addParam("resolution", value: resolution.rawValue)
            req.addParam("series_type", value: seriesType?.rawValue)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
    
    func retrieveRouteStreams(routeId: Int64, completionHandler: @escaping (StravaResponse<[Stream]>) -> Void) {
        var req = StravaRequest<Stream>()
        req.pathComponent = "/routes/\(routeId)/streams/"
        req.method = .get
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completionHandler)
    }
}

/*
 Uploads
 */
public extension StravaClient {
    //Upload an activity
    //Check upload status 
    
    func uploadAnActivity(activityType: Int64,
                          name: String? = nil,
                          description: String? = nil,
                          isPrivate: Bool = false,
                          isTrainer: Bool,
                          isCommute: Bool,
                          dataType: ActivityUploadType,
                          externalId: String,
                          file: Data,
                          completionHandler: @escaping (StravaResponse<ActivityUploadStatus>) -> Void) {
        var req = StravaRequest<ActivityUploadStatus>()
        req.pathComponent = "/uploads"
        req.method = .post
        req.addParam("data_type", value: dataType.rawValue)
        req.addParam("external_id", value: externalId)
        req.addParam("trainer", value: isTrainer)
        req.addParam("commute", value: isCommute)
        req.addParam("description", value: description)
        req.addParam("name", value: name)
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.uploadRequest(data: file, { response in
            print(response)
        })
    }
    
    func checkUploadStatus(id: Int64, completionHandler: @escaping (StravaResponse<ActivityUploadStatus>) -> Void) {
        var req = StravaRequest<ActivityUploadStatus>()
        req.pathComponent = "/uploads/\(id)"
        req.method = .get
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completionHandler)
    }
}

/*
 Webhook Events
 */
public extension StravaClient {
// Not applicable for iOS
}
