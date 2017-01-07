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
    
    fileprivate var callbackURL: String?
    fileprivate var authToken: String?
    fileprivate var clientId: Int64?
    fileprivate var accessScope: StravaAccessScope? = nil
    fileprivate var clientSecret: String?
    
    /// Configure `StravaClient`. It's important to call this method before `StravaClient` usage.
    ///
    /// - Parameters:
    ///   - clientId:     application’s ID, obtained during registration
    ///   - clientSecret: application’s secret, obtained during registration
    ///   - accessScope:  listed in `StravaAccessScope` enum. Comma delimited string of ‘view_private’ and/or ‘write’, leave blank for read-only permissions
    ///   - callbackURL:  URL Scheme value. [See more...](http://limlab.io)
    public func configure(clientId: Int64, clientSecret: String, accessScope: StravaAccessScope? = nil, callbackURL: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.callbackURL = callbackURL
        self.accessScope = accessScope
    }
}


public struct AccessCredentials {
    var clientId: Int64
    var clientSecret: String
    var code: String
}

public enum OAuthError: Error {
    case urlMalformed(url: String)
    case parameterMissing(paramterName: String)
    case notAuthorized(reason: String)
}

/*
 OAuth helpers
 */
public extension StravaClient {
    
    /// This URL should be used for OAuth authentication. You are responsible for
    /// showing internal web-view or web-browser window with Strava™ application access page
    ///
    /// Read more about Authentication process [here](http://limlab.io)
    ///
    /// - Returns: `URL` to be loaded by web-view
    /// - Throws: `OAuthError` in case of unexpected behavior
    public func oAuthURL() throws -> URL {
        guard let clientId = self.clientId else {
            throw OAuthError.parameterMissing(paramterName: "clientId")
        }
        
        guard let callbackURL = self.callbackURL else {
            throw OAuthError.parameterMissing(paramterName: "callbackURL")
        }
        
        var scope: String = ""
        if let accessScope = self.accessScope {
            scope = "&scope=" + accessScope.rawValue
        }
        
        let urlString = "https://www.strava.com/oauth/authorize?client_id=\(clientId)&response_type=code&redirect_uri=\(callbackURL)\(scope)&approval_prompt=force"
        guard let url = URL(string: urlString) else {
            throw OAuthError.urlMalformed(url: urlString)
        }
        
        return url
    }
    
    
    /// After user finishes his interaction with Strava™ application access page, 
    /// `application:openURL:options:` will be triggered in your app's `AppDelegate`. 
    /// `url` parameter contains url, from which we can extract needed auth data
    ///
    /// - Parameter url: url passed received from `AppDelegate`
    /// - Returns: `AccessCredentials` struct with authorization data or throws `OAuthError`
    /// - Throws: an `OAuthError` in case of unexpected behavior
    public func extractAccessCredentials(from url: URL) throws -> AccessCredentials {
        guard let comps = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw OAuthError.notAuthorized(reason: "Cannot resolve URL components for URL: \(url)")
        }
        
        guard let clientId = self.clientId else {
            throw OAuthError.parameterMissing(paramterName: "clientId")
        }
        
        guard let clientSecret = self.clientSecret else {
            throw OAuthError.parameterMissing(paramterName: "clientSecret")
        }
        
        guard let code = (comps.queryItems?.filter { $0.name == "code" })?.first?.value else {
            throw OAuthError.notAuthorized(reason: "Cannot retrieve `code` value from URL: \(url)")
        }
        
        return AccessCredentials(clientId: clientId, clientSecret: clientSecret, code: code)
    }
}

/*
 Authentication
 */
public extension StravaClient {
    /// Retrieves access token from Strava server. Access token is sent with every
    /// request that requires authorization to retrieve data
    ///
    /// - Parameters:
    ///   - credentials: `AccessCredentrials` object that was obtained by `extractAccessCredentials from:` method
    ///   - completion: The closure called when request is complete
    public func authorize(credentials: AccessCredentials, completion:@escaping (_ authResponse: StravaResponse<Auth>) -> Void) {
        var req = StravaRequest<Auth>()
        req.method = .post
        req.url = "https://www.strava.com/oauth/token"
        req.addParam("client_id", value: credentials.clientId)
        req.addParam("code", value: credentials.code)
        req.addParam("client_secret", value: credentials.clientSecret)
        req.requestObject { authResponse in
            switch authResponse {
            case .Success(let auth):
                self.authToken = auth.accessToken
            case .Failure:
                self.authToken = nil
            }
            completion(authResponse)
        }
    }
    
    /// Deauthorizes user and invalidates current `accessToken`
    ///
    /// - Parameter completion: The closure called when request is complete
    public func deauthorize(completion:@escaping (_ authResponse: StravaResponse<Deauth>) -> Void) {
        var req = StravaRequest<Deauth>()
        req.method = .post
        req.url = "https://www.strava.com/oauth/deauthorize"
        req.addToken(token: StravaClient.instance.authToken!)
        req.requestObject { deauthResponse in
            switch deauthResponse {
            case .Success:
                self.authToken = nil
            default: break
            }
            completion(deauthResponse)
        }
    }
}


/*
 Athletes
 */
public extension StravaClient {
    
    /// This request is used to retrieve information about any athlete on Strava if `athleteId` is `nil` - returns current athlete.
    /// Returns a summary representation of the athlete even if the indicated athlete matches the authenticated athlete
    ///
    /// - Parameters:
    ///   - athleteId: needed athlete's id (leave blank in case of retrieving current athlete info)
    ///   - completion: the closure called when request is complete
    func retrieveAthlete(athleteId: Int? = nil, completion: @escaping (StravaResponse<Athlete>) -> Void) {
        var req = StravaRequest<Athlete>()
        if let id = athleteId {
            req.pathComponent = "/athletes/\(id)"
        } else {
            req.pathComponent = "/athlete"
        }
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completion)
    }
    
    
    /// Friends are users the current athlete is following. The activities owned by these users will appear in the current athlete’s activity feed.
    /// There are two types of requests, one for the authenticated athlete and another for any athlete specified by an ID. 
    /// In the second case, if the indicated athlete has blocked the authenticated athlete, the result will be an empty array. Pagination is supported.
    ///
    /// - Parameters:
    ///   - athleteId: integer required depending on request type
    ///   - page: start page
    ///   - perPage: num records per page
    ///   - completion: the closure called when request is complete
    /// 
    /// [Read about pagination...](http://strava.github.io/api/#pagination)
    func listAthletesFriends(athleteId: Int? = nil,
                             page: Int = 0,
                             perPage: Int = 0,
                             completion: @escaping (StravaResponse<[AthleteSummary]>) -> Void) {
        var req = StravaRequest<AthleteSummary>()
        if let id = athleteId {
            req.pathComponent = "/athletes/\(id)/friends"
        } else {
            req.pathComponent = "/athlete/friends"
        }
        
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("perPage", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }

    /// There are two types of requests, one for the authenticated athlete and another for any athlete specified by an ID.
    /// In the second case, if the indicated athlete has blocked the authenticated athlete, the result will be an empty array.
    /// Pagination is supported.
    /// 
    /// - Parameters:
    ///   - id: integer required depending on request type
    ///   - page: integer optional
    ///   - perPage: integer optional
    ///   - completion: the closure called when request is complete
    ///
    /// [Read about pagination...](http://strava.github.io/api/#pagination)
    func listAthletesFollowers(athleteId: Int? = nil,
                               page: Int = 0,
                               perPage: Int = 0,
                               completion: @escaping (StravaResponse<[AthleteSummary]>) -> Void) {
        var req = StravaRequest<AthleteSummary>()
        if let id = athleteId {
            req.pathComponent = "/athletes/\(id)/followers"
        } else {
            req.pathComponent = "/athlete/followers"
        }
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("perPage", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }

    /// Retrieve the athletes who both the authenticated user and the indicated athlete are following. Pagination is supported.
    /// 
    /// - Parameters:
    ///   - id: integer required
    ///   - page: integer optional
    ///   - perPage: integer optional
    ///   - completion: the closure called when request is complete
    ///
    /// [Read about pagination...](http://strava.github.io/api/#pagination)   
    func listAthletesBothFollowing(athleteId: Int,
                                   page: Int = 0,
                                   perPage: Int = 0,
                                   completion: @escaping (StravaResponse<[AthleteSummary]>) -> Void) {
        var req = StravaRequest<AthleteSummary>()
        req.pathComponent = "/athletes/\(athleteId)/both-following"
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("perPage", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    /// Returns the heart rate and power zones of the requesting athlete
    /// The min for Zone 1 is always 0 and the max for Zone 5 is always -1
    ///
    /// Heart rate
    ///     custom_zones: boolean - true if athlete has set their own custom heart rate zones
    ///     zones: array - array of athlete’s heart rate zones
    /// Power
    ///     Premium members who have set a functional threshold power (ftp) will see their power zones
    ///     Power zones are a Premium-only feature. Free members will not see the power part of this endpoint
    ///
    /// -Parameters:
    ///   - completion: the closure called when request is complete
    func retrieveAthletesZones(completion: @escaping (StravaResponse<Zones>) -> Void) {
        var req = StravaRequest<Zones>()
        req.pathComponent = "/athlete/zones"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completion)
    }
    
    /// Returns recent (last 4 weeks), year to date and all time stats for a given athlete
    /// Only available for the authenticated athlete. This is the recommended endpoint when polling for athlete upload events
    /// 
    /// - Parameters:
    ///   - id: integer required must match the authenticated athlete
    ///   - completion: the closure called when request is complete
    func retrieveAthletesTotalsAndStats(athleteId: Int,
                                        completion: @escaping (StravaResponse<Stats>) -> Void) {
        var req = StravaRequest<Stats>()
        req.pathComponent = "/athlete/stats"
        req.method = .get
        req.addParam("id", value: athleteId)
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completion)
    }
    
    /// Returns an array of segment efforts representing Overall KOMs/QOMs and course records held by the given athlete
    /// Yearly KOMs are not included. Results are sorted by date, newest first. Pagination is supported
    /// 
    /// - Parameters:
    ///   - id: integer required
    ///   - page: integer optional
    ///   - perPage: integer optional
    ///   - completion: the closure called when request is complete
    ///
    /// [Read about pagination...](http://strava.github.io/api/#pagination)
    func listAthletesKOMs(athleteId: Int,
                          page: Int = 0,
                          perPage: Int = 0,
                          completion: @escaping (StravaResponse<[SegmentEffortSummary]>) -> Void) {
        var req = StravaRequest<SegmentEffortSummary>()
        req.pathComponent = "/athletes/\(athleteId)/koms"
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("perPage", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    /// Requires write permissions, as requested during the authorization process
    /// 
    /// - Parameters:
    ///   - city: string
    ///   - state: string
    ///   - country: string
    ///   - sex: string ‘M’ or ‘F’, any other value will set to null and displayed as "rather not say"
    ///   - weight: float kilograms
    ///   - completion: the closure called when request is complete
    func updateAthlete(city: String? = nil,
                       state: String? = nil,
                       country: String? = nil,
                       sex: Gender? = nil,
                       weight: Float? = nil,
                       completion: @escaping (StravaResponse<Athlete>) -> Void) {
        var req = StravaRequest<Athlete>()
        req.pathComponent = "/athlete"
        req.method = .put
        req.addParam("city", value: city)
        req.addParam("state", value: state)
        req.addParam("country", value: country)
        req.addParam("sex", value: sex)
        req.addParam("weight", value: weight)
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completion)
    }
}

/*
 Activities
 */
public extension StravaClient {
    
    /// The number of comments is included in the activity summary and detail responses. 
    /// Use this endpoint to retrieve a list of comments left on a given activity.
    /// Pagination is supported
    /// 
    /// - Parameters:
    ///   - id: integer required
    ///   - page: integer optional
    ///   - perPage: integer optional
    ///   - completion: the closure called when request is complete
    /// 
    /// [Read about pagination...](http://strava.github.io/api/#pagination)
    func listActivityComments(activityId: String,
                              page: Int = 0,
                              perPage: Int = 0,
                              completion: @escaping (StravaResponse<[Comment]>) -> Void) {
        var req = StravaRequest<Comment>()
        req.pathComponent = "/activities/\(activityId)/comments"
        
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("perPage", value: perPage)
        }
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    /// The number of kudos is included in the activity summary and detailed representations.
    /// This endpoint is for retrieving more detailed information on the athletes who’ve left
    /// kudos and can only be accessed by the owner of the activity. Pagination is supported.
    /// 
    /// - Parameters:
    ///   - id: integer required
    ///   - page: integer optional
    ///   - perPage: integer optional
    ///   - completion: the closure called when request is complete
    /// 
    /// [Read about pagination...](http://strava.github.io/api/#pagination)
    func listActivityKudoers(activityId: String,
                              page: Int = 0,
                              perPage: Int = 0,
                              completion: @escaping (StravaResponse<[AthleteSummary]>) -> Void) {
        var req = StravaRequest<AthleteSummary>()
        req.pathComponent = "/activities/\(activityId)/kudos"
        
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("perPage", value: perPage)
        }
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    /// The number of photos is included in the activity summary and detail responses.
    /// Use this endpoint to retrieve a list of photos associated with this activity.
    /// This endpoint can only be accessed by the owner of the activity.
    /// 
    /// - Parameters:
    ///   - id: integer required
    ///   - photoSources: boolean required always use true
    ///   - size: integer optional
    ///           the requested size of the activity’s photos.
    ///           URLs for the photos will be returned that best match the requested size.
    ///           If not included, the smallest size is returned.
    ///   - completion: the closure called when request is complete
    func listActivityPhotos(activityId: String, completion: @escaping (StravaResponse<[Photo]>) -> Void) {
        var req = StravaRequest<Photo>()
        req.pathComponent = "/activities/\(activityId)/photos?photoSources=true"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    /// This API endpoint is for creating manually entered activities.
    /// To upload a FIT, TCX or GPX file see the
    /// [Upload Documentation](http://strava.github.io/api/v3/uploads/)
    ///
    /// Requires write permissions, as requested during the authorization process.
    ///
    /// - Parameters:
    ///   - name: string required
    ///   - type: string required, case insensitive
    ///     ‘Ride’, ‘Run’, ‘Swim’, etc. See above for all possible types.
    ///   - startDateLocal: datetime required
    ///     ISO 8601 formatted date time, see Dates for more information
    ///   - elapsedTime: integer required
    ///     seconds
    ///   - description: string optional
    ///   - distance: float optional
    ///     meters
    ///   - private: integer optional
    ///     set to 1 to mark the resulting activity as private,
    ///     ‘view_private’ permissions will be necessary to view the activity
    ///   - trainer: integer optional
    ///     set to 1 to mark as a trainer activity
    ///   - commute: integer optional
    ///     set to 1 to mark as commute
    ///   - completion: the closure called when request is complete
    func createAnActivity(name: String,
                          activityType: ActivityType,
                          startDate: Date,
                          elapsedTime: TimeInterval,
                          description: String?,
                          distance: Float?,
                          isPrivate: Bool,
                          isTrainer: Bool,
                          isCommute: Bool?,
                          completion: @escaping (StravaResponse<Activity>) -> Void) {
        var req = StravaRequest<Activity>()
        req.pathComponent = "/activities"
        req.method = .post
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.addParam("name", value: name)
        req.addParam("type", value: activityType.rawValue)
        req.addParam("startDateLocal", value: startDate.toISO8601String())
        req.addParam("elapsedTime", value: elapsedTime)
        req.addParam("description", value: description)
        req.addParam("distance", value: distance)
        req.addParam("private", value: isPrivate)
        req.addParam("trainer", value: isTrainer)
        if let isCommute = isCommute {
            req.addParam("commute", value: isCommute ? 1 : 0)
        }
        
        req.requestObject(completion)
    }
    
    /// Returns a detailed representation if the activity is owned by the requesting athlete.
    /// Returns a summary representation for all other requests.
    /// Activity details, including segment efforts, splits and best efforts,
    /// are only available to the owner of the activity. By default, only "important" efforts are included.
    /// "Importance" is based on a number of factors and its value may change over time.
    /// Factors considered include: segment age, views and stars,
    /// if the user has hidden/shown the segment and if the effort was a PR.
    /// Note, if two activities cover the same segment, it is possible that for one activity
    /// the associated effort is "important" but not for the other.
    ///
    /// Note that effort ids may exceed the max value for 32-bit integers. A 'long integer' type should be used.
    ///
    /// - Parameters:
    ///   - id: integer required
    ///   - includeAllEfforts: boolean optional
    ///     used to include all segment efforts in the result
    ///     Each segment effort will have a hidden attribute indicating if it is "important" or not.
    ///   - completion: the closure called when request is complete
    ///
    /// - Achievements:
    ///   Each segment effort and best effort will have an achievements attribute
    ///   containing an array of achievements for the effort.
    ///   This array is empty if there are no achievements.
    ///   Each achievement object contains a type id, a type, and a rank.
    ///
    ///   - type_id: integer
    ///     achievement type
    ///   - type: string
    ///     string identifier for achievement type
    ///   - rank: integer
    ///     rank for achievement type
    ///     
    ///     Achievement Types
    ///     type_id    type           description
    ///     2          ‘overall’       Overall Leaderboard Rank
    ///     3          ‘pr’            Athlete PR Rank
    ///     5          ‘year_overall’  Annual Leaderboard Rank
    ///
    /// Achievements are computed at time of upload and reflect ranks at that point in time.
    /// They are not dynamically updated at any point thereafter and should not be used to infer leaderboard state.
    /// For example, a segment effort achievement with a type_id of 3 and rank of 2
    /// would indicate that the effort was the athlete’s second best all-time performance on the segment
    /// at the time the activity was uploaded.
    func retrieveAnActivity(activityId: Int64, includeAllEfforts: Bool = false, completion: @escaping (StravaResponse<Activity>) -> Void) {
        var req = StravaRequest<Activity>()
        req.pathComponent = "/activities/\(activityId)"
        req.method = .get
        req.addParam("includeAllEfforts", value: includeAllEfforts)
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completion)
    }
    
    /// Requires write permissions, as requested during the authorization process.
    ///
    /// - Parameters:
    ///   - name: string optional
    ///   - type: string optional
    ///   - private: boolean optional
    ///     defaults to false
    ///   - commute: boolean optional
    ///     defaults to false
    ///   - trainer: boolean optional
    ///     defaults to false
    ///   - gearId: string optional
    ///     ‘none’ clears gear from activity
    ///   - description: string optional
    ///   - completion: the closure called when request is complete
    func updateAnActivity(activityId: Int64,
                          name: String,
                          activityType: ActivityType?,
                          description: String?,
                          isPrivate: Bool = false,
                          isTrainer: Bool = false,
                          isCommute: Bool = false,
                          gearId: String? = nil, //‘none’ clears gear from activity
                          completion: @escaping (StravaResponse<Activity>) -> Void) {
        var req = StravaRequest<Activity>()
        req.pathComponent = "/activities/\(activityId)"
        req.method = .put
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.addParam("name", value: name)
        req.addParam("type", value: activityType?.rawValue)
        req.addParam("description", value: description)
        req.addParam("gearId", value: gearId)
        req.addParam("private", value: isPrivate)
        req.addParam("trainer", value: isTrainer)
        req.addParam("commute", value: isCommute ? 1 : 0)
        
        req.requestObject(completion)
    }
    
    /// Requires write permissions, as requested during the authorization process.
    ///
    /// - Parameters:
    ///   - id: integer required
    ///   - completion: the closure called when request is complete
    func deleteAnActivity(activityId: Int64, completion: @escaping (Bool, StravaError?) -> Void) {
        var req = StravaRequest<StravaObject>()
        req.pathComponent = "/activities/\(activityId)"
        req.method = .delete
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestWithSuccessConfirmation(completion)
    }
    
    /// This endpoint returns a list of activities for the authenticated user.
    ///
    /// - Parameters:
    ///   - before: integer optional
    ///     seconds since UNIX epoch, result will start with activities whose start_date is before this value
    ///   - after: integer optional
    ///     seconds since UNIX epoch, result will start with activities whose start_date is after this value,
    ///     sorted oldest first
    ///   - page: integer optional
    ///   - perPage: integer optional
    ///     before, after or page can not be used in combination.
    ///     They are independent ways of indicating where in the list of activities to begin the results.
    ///   - completion: the closure called when request is complete
    func listAthletesActivities(afterDate: Date?,
                                beforeDate: Date?,
                                page: Int = 0,
                                perPage: Int = 0,
                                completion: @escaping (StravaResponse<[ActivitySummary]>) -> Void) {
        var req = StravaRequest<ActivitySummary>()
        req.pathComponent = "/athlete/activities"
        req.method = .get
        
        req.addParam("before", value: beforeDate?.timeIntervalSince1970)
        req.addParam("after", value: afterDate?.timeIntervalSince1970)
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("perPage", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    /// Returns the activities that were matched as “with this group”. The number equals activity.athlete_count-1.
    /// Pagination is supported.
    ///
    /// - Parameters:
    ///   - id: integer required
    ///   - page: integer optional
    ///   - perPage: integer optional
    ///   - completion: the closure called when request is complete
    ///
    /// [Read about pagination...](http://strava.github.io/api/#pagination)
    func listRelatedActivities(activityId: Int64,
                               page: Int = 0,
                               perPage: Int = 0,
                               completion: @escaping (StravaResponse<[ActivitySummary]>) -> Void) {
        var req = StravaRequest<ActivitySummary>()
        req.pathComponent = "/activities/\(activityId)/related"
        req.method = .get
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("perPage", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    /// List the recent activities performed by the current athlete and those they are following.
    /// Pagination is supported. However, results are limited to the last 200 total activities.
    ///
    /// - Parameters:
    ///   - before: integer optional
    ///     seconds since UNIX epoch, result will start with activities whose start_date is before this value
    ///   - page: integer optional
    ///   - perPage: integer optional
    ///     before and page can not be used in combination.
    ///     They are independent ways of indicating where in the list of activities to begin the results.
    ///   - completion: the closure called when request is complete
    ///
    /// [Read about pagination...](http://strava.github.io/api/#pagination)
    func listFriendsActivities(beforeDate: Date?,
                                page: Int = 0,
                                perPage: Int = 0,
                                completion: @escaping (StravaResponse<[ActivitySummary]>) -> Void) {
        var req = StravaRequest<ActivitySummary>()
        req.pathComponent = "/activities/following"
        req.method = .get
        
        req.addParam("before", value: beforeDate?.timeIntervalSince1970)
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("perPage", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    /// Heartrate and power zones are set by the athlete. This endpoint returns the time (seconds) in each zone.
    /// The distribution is not customizable. Requires an access token associated with the owner of the activity
    /// and the owner must be a premium user.
    ///
    /// - Parameters:
    ///   - id: integer required
    ///   - completion: the closure called when request is complete
    func listActivityZones(activityId: Int64,
                           completion: @escaping (StravaResponse<[ActivityZone]>) -> Void) {
        var req = StravaRequest<ActivityZone>()
        req.pathComponent = "/activities/\(activityId)/zones"
        req.method = .get
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    /// This resource will return all laps for an activity.
    /// Laps are triggered by athletes using their respective devices, such as Garmin watches.
    /// Note that pace zones are only populated for runs, and are based on the athlete’s user-submitted race times.
    ///
    /// - Parameters:
    ///   - id: integer required
    ///   - completion: the closure called when request is complete
    func listActivityLaps(activityId: Int64,
                           completion: @escaping (StravaResponse<[Lap]>) -> Void) {
        var req = StravaRequest<Lap>()
        req.pathComponent = "/activities/\(activityId)/laps"
        req.method = .get
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
}

/*
 Clubs
 */
public extension StravaClient {
    func retrieveAClub(clubId: String, completion: @escaping (StravaResponse<Club>) -> Void) {
        var req = StravaRequest<Club>()
        req.pathComponent = "/clubs/\(clubId)"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completion)
    }
    
    func listClubAnnouncements(clubId: String, completion: @escaping (StravaResponse<[Announcement]>) -> Void) {
        var req = StravaRequest<Announcement>()
        req.pathComponent = "/clubs/\(clubId)/announcements"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    func listClubGroupEvents(clubId: String, completion: @escaping (StravaResponse<[GroupEventSummary]>) -> Void) {
        var req = StravaRequest<GroupEventSummary>()
        req.pathComponent = "/clubs/\(clubId)/group_events"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    func listAthleteClubs(completion: @escaping (StravaResponse<[ClubSummary]>) -> Void) {
        var req = StravaRequest<ClubSummary>()
        req.pathComponent = "/athlete/clubs"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    func listClubMembers(clubId: String, page: Int = 0, perPage: Int = 0, completion: @escaping (StravaResponse<[AthleteSummary]>) -> Void) {
        var req = StravaRequest<AthleteSummary>()
        req.pathComponent = "/clubs/\(clubId)/members"
        req.method = .get
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("perPage", value: perPage)
        }
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    func listClubAdmins(clubId: String, page: Int = 0, perPage: Int = 0, completion: @escaping (StravaResponse<[AthleteSummary]>) -> Void) {
        var req = StravaRequest<AthleteSummary>()
        req.pathComponent = "/clubs/\(clubId)/admins"
        req.method = .get
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("perPage", value: perPage)
        }
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    func listClubActivities(clubId: String, before: Date? = nil, page: Int = 0, perPage: Int = 0, completion: @escaping (StravaResponse<[ActivitySummary]>) -> Void) {
        var req = StravaRequest<ActivitySummary>()
        req.pathComponent = "/clubs/\(clubId)/activities"
        req.method = .get
        if let before = before {
            req.addParam("before", value: "\(before.timeIntervalSince1970)")
        }
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("perPage", value: perPage)
        }
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    func joinClub(clubId: String, completion: @escaping (StravaResponse<ClubMembership>) -> Void) {
        var req = StravaRequest<ClubMembership>()
        req.pathComponent = "/clubs/\(clubId)/join"
        req.method = .post
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completion)
    }
    
    func leaveAClub(clubId: String, completion: @escaping (StravaResponse<ClubMembership>) -> Void) {
        var req = StravaRequest<ClubMembership>()
        req.pathComponent = "/clubs/\(clubId)/leave"
        req.method = .post
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completion)
    }
    
}

/*
 Gear
 */
public extension StravaClient {
    func retrieveGear<T: Gear>(gearId: String, completion: @escaping (StravaResponse<T>) -> Void) {
        var req = StravaRequest<T>()
        req.pathComponent = "/gear/\(gearId)"
        req.method = .get
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completion)
    }
}

/* 
 Routes
 */
public extension StravaClient {
    func retrieveARoute(routeId: Int64, completion: @escaping (StravaResponse<Route>) -> Void) {
        var req = StravaRequest<Route>()
        req.pathComponent = "/routes/\(routeId)"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completion)
    }
    
    func listRoutes(athleteId: Int64, completion: @escaping (StravaResponse<[RouteSummary]>) -> Void) {
        var req = StravaRequest<RouteSummary>()
        req.pathComponent = "/athletes/\(athleteId)/routes"
        req.method = .get
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
}

/*
 Running Races
 */
public extension StravaClient {
    func listRoutes(year: Int? = nil, completion: @escaping (StravaResponse<[RunningRaceSummary]>) -> Void) {
        var req = StravaRequest<RunningRaceSummary>()
        req.pathComponent = "/running_races"
        req.method = .get
        
        req.addParam("year", value: year)
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    func retrieveRaceDetails(raceId: Int64, completion: @escaping (StravaResponse<RunningRace>) -> Void) {
        var req = StravaRequest<RunningRace>()
        req.pathComponent = "/running_races/\(raceId)"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completion)
    }
}

/*
 Segments
 */
public extension StravaClient {
    func retrieveASegment(segmentId: Int64, completion: @escaping (StravaResponse<Segment>) -> Void) {
        var req = StravaRequest<Segment>()
        req.pathComponent = "/segments/\(segmentId)"
        req.method = .get
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completion)
    }
    
    func listStarredSegments(page: Int = 0, perPage: Int = 0, completion: @escaping (StravaResponse<[SegmentSummary]>) -> Void) {
        var req = StravaRequest<SegmentSummary>()
        req.pathComponent = "/segments/starred"
        req.method = .get
        
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("perPage", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    func starASegment(segmentId: Int64, starred: Bool, completion: @escaping (StravaResponse<Segment>) -> Void) {
        var req = StravaRequest<Segment>()
        req.pathComponent = "/segments/\(segmentId)/starred"
        req.method = .put
        req.addParam("starred", value: starred)
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completion)
    }
    
    func listEfforts(segmentId: Int64,
                     athleteId: Int64,
                     startDateLocal: Date?,
                     endDateLocal: Date?,
                     page: Int = 0,
                     perPage: Int = 0,
                     completion: @escaping (StravaResponse<[ActivitySummary]>) -> Void) {
        var req = StravaRequest<ActivitySummary>()
        req.pathComponent = "/segments/\(segmentId)/all_efforts"
        req.method = .get
        
        req.addParam("id", value: athleteId)
        req.addParam("start_date_local", value: startDateLocal?.toISO8601String())
        req.addParam("end_date_local", value: endDateLocal?.toISO8601String())
        if page > 0 && perPage > 0 {
            req.addParam("page", value: page)
            req.addParam("perPage", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
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
                     completion: @escaping (StravaResponse<[ActivitySummary]>) -> Void) {
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
            req.addParam("perPage", value: perPage)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    func segmentExplorer(bounds: Bounds,
                         activityType: ActivityType? = .ride,
                         minClimbCategory: ClimbCategory? = nil,
                         maxClimbCategory: ClimbCategory? = nil,
                         completion: @escaping (StravaResponse<[SegmentSummary]>) -> Void) {
        var req = StravaRequest<SegmentSummary>()
        req.pathComponent = "/segments/explore"
        req.method = .get
        
        req.addParam("bounds", value: bounds.toString())
        req.addParam("activity_type", value: activityType?.rawValue)
        req.addParam("min_cat", value: minClimbCategory)
        req.addParam("max_cat", value: maxClimbCategory)
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
}

/*
 Segment Efforts
 */
public extension StravaClient {
    func retrieveASegmentEffort(effortId: Int64, completion: @escaping (StravaResponse<SegmentEffort>) -> Void) {
        var req = StravaRequest<SegmentEffort>()
        req.pathComponent = "/segment_efforts/\(effortId)"
        req.method = .get
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completion)
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
                                 completion: @escaping (StravaResponse<[Stream]>) -> Void) {
        let strTypes = types.map { $0.rawValue }
        var req = StravaRequest<Stream>()
        req.pathComponent = "/activities/\(activityId)/streams/\(strTypes.joined(separator: ","))"
        req.method = .get
        
        if let resolution = resolution {
            req.addParam("resolution", value: resolution.rawValue)
            req.addParam("series_type", value: seriesType?.rawValue)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    func retrieveEffortStreams(effortId: Int64,
                                 types: [StreamType],
                                 resolution: Resolution? = nil,
                                 seriesType: SeriesType? = nil,
                                 completion: @escaping (StravaResponse<[Stream]>) -> Void) {
        let strTypes = types.map { $0.rawValue }
        var req = StravaRequest<Stream>()
        req.pathComponent = "/segment_efforts/\(effortId)/streams/\(strTypes.joined(separator: ","))"
        req.method = .get
        
        if let resolution = resolution {
            req.addParam("resolution", value: resolution.rawValue)
            req.addParam("series_type", value: seriesType?.rawValue)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    func retrieveSegmentStreams(segmentId: Int64,
                               types: [StreamType],
                               resolution: Resolution? = nil,
                               seriesType: SeriesType? = nil,
                               completion: @escaping (StravaResponse<[Stream]>) -> Void) {
        let strTypes = types.map { $0.rawValue }
        var req = StravaRequest<Stream>()
        req.pathComponent = "/segment_efforts/\(segmentId)/streams/\(strTypes.joined(separator: ","))"
        req.method = .get
        
        if let resolution = resolution {
            req.addParam("resolution", value: resolution.rawValue)
            req.addParam("series_type", value: seriesType?.rawValue)
        }
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
    }
    
    func retrieveRouteStreams(routeId: Int64, completion: @escaping (StravaResponse<[Stream]>) -> Void) {
        var req = StravaRequest<Stream>()
        req.pathComponent = "/routes/\(routeId)/streams/"
        req.method = .get
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestArray(completion)
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
                          completion: @escaping (StravaResponse<ActivityUploadStatus>) -> Void) {
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
    
    func checkUploadStatus(id: Int64, completion: @escaping (StravaResponse<ActivityUploadStatus>) -> Void) {
        var req = StravaRequest<ActivityUploadStatus>()
        req.pathComponent = "/uploads/\(id)"
        req.method = .get
        
        req.addToken(token: StravaClient.instance.authToken!)
        
        req.requestObject(completion)
    }
}

/*
 Webhook Events
 */
public extension StravaClient {
// Not applicable for iOS
}
