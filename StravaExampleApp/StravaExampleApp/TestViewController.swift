//
//  TestViewController.swift
//  FaceWind
//
//  Created by Oleksandr Glagoliev on 09/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import UIKit
import ObjectMapper

class TestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var data: [(key: String, cases: [(String, () -> ())])]?
    var lastResponse: String = "Sorry, no response!" {
        didSet {
            print(lastResponse)
        }
    }

    // MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Test UI"
        
        data = [
            (key: "Auth",
             cases: [
                ("Auth", {
                    StravaClient.instance.authorize { authResponse in
                        self.showResponse(authResponse)
                    }
                }),
                ("Deauth", {
                    StravaClient.instance.deauthorize { deauthResponse in
                        self.showResponse(deauthResponse)
                    }
                }),
            ]),
            (key: "Athlete",
             cases: [
                ("Get current Athlete", {
                    StravaClient.instance.retrieveAthlete { athleteResponse in
                        self.showResponse(athleteResponse)
                    }
                }),
                ("Get another Athlete", {
                    StravaClient.instance.retrieveAthlete(athleteId: 9208179) { athleteResponse in
                        self.showResponse(athleteResponse)
                    }
                }),
                ("List current Athletes Friends", {
                    StravaClient.instance.listAthletesFriends(page: 1, perPage: 4) { friendsResponse in
                        self.showResponse(friendsResponse)
                    }
                }),
                ("List current Athletes Followers", {
                    StravaClient.instance.listAthletesFollowers(page: 1, perPage: 4) { friendsResponse in
                        self.showResponse(friendsResponse)
                    }
                }),
                ("List current Athletes BothFollowing", {
                    StravaClient.instance.listAthletesBothFollowing(athleteId: 4243694, page: 1, perPage: 4) { friendsResponse in
                        self.showResponse(friendsResponse)
                    }
                }),
                ("List another Athletes Friends", {
                    StravaClient.instance.listAthletesFriends(athleteId: 9208179, page: 1, perPage: 4) { friendsResponse in
                        self.showResponse(friendsResponse)
                    }
                }),
                ("List another Athletes Followers", {
                    StravaClient.instance.listAthletesFollowers(athleteId: 9208179, page: 1, perPage: 4) { friendsResponse in
                        self.showResponse(friendsResponse)
                    }
                }),
                ("List another Athletes BothFollowing", {
                    StravaClient.instance.listAthletesFriends(athleteId: 9208179, page: 1, perPage: 4) { friendsResponse in
                        self.showResponse(friendsResponse)
                    }
                }),
                ("Update Athlete", {
                    StravaClient.instance.updateAthlete(city: "Tallinn", state: "Harju", sex: .Male, weight: 85) { athlete in
                        self.showResponse(athlete)
                    }
                }),
                ("List Athletes KOMs", {
                    StravaClient.instance.listAthletesKOMs(athleteId: 4243694) { koms in
                        self.showResponse(koms)
                    }
                }),
                ("Retrieve Athletes Zones", {
                    StravaClient.instance.retrieveAthletesZones { zones in
                        self.showResponse(zones)
                    }
                }),
                ("Retrieve Athletes Totals", {
                    StravaClient.instance.retrieveAthletesTotalsAndStats(athleteId: 4243694) { stats in
                        self.showResponse(stats)
                    }
                })
                ]
            ),
            (key: "Gear",
             cases: [
                ("Get Gear item", {
                    StravaClient.instance.retrieveGear(gearId: "g346160") { (gear: StravaResponse<Gear>) in
                        self.showResponse(gear)
                    }
                }),
            ]),
            (key: "Activities", cases: [
                ("List activity comments", {
                    StravaClient.instance.listActivityComments(activityId: "137989091", completionHandler: { (comments: StravaResponse<[Comment]>) in
                        self.showResponse(comments)
                    })
                }),
                ("List activity Kudoers", {
                    StravaClient.instance.listActivityKudoers(activityId: "137989091", completionHandler: { (kudoers: StravaResponse<[AthleteSummary]>) in
                        self.showResponse(kudoers)
                    })
                }),
                ("List activity Photos", {
                    StravaClient.instance.listActivityPhotos(activityId: "137989091", completionHandler: { (photos: StravaResponse<[Photo]>) in
                        self.showResponse(photos)
                    })
                }),
                ("Create an activity", {
                    StravaClient.instance.createAnActivity(name: "Amazing Ride",
                                                           activityType: .Canoeing,
                                                           startDate: Date(),
                                                           elapsedTime: 6300,
                                                           description: "Just an activity",
                                                           distance: 1000,
                                                           isPrivate: false,
                                                           isTrainer: true,
                                                           isCommute: false,
                                                           completionHandler: { (activity: StravaResponse<Activity>) in
                        self.showResponse(activity)
                    })
                }),
                ("Create an activity", {
                    StravaClient.instance.createAnActivity(name: "Amazing Ride",
                                                           activityType: .Canoeing,
                                                           startDate: Date(),
                                                           elapsedTime: 6300,
                                                           description: "Just an activity",
                                                           distance: 1000,
                                                           isPrivate: false,
                                                           isTrainer: true,
                                                           isCommute: false,
                                                           completionHandler: { (activity: StravaResponse<Activity>) in
                                                            self.showResponse(activity)
                    })
                }),
                ("Retrieve an activity", {
                    StravaClient.instance.retrieveAnActivity(activityId: 796245274, includeAllEfforts: false, completionHandler: { (activity: StravaResponse<Activity>) in
                        self.showResponse(activity)
                    })
                }),
                ("Update an activity", {
                    StravaClient.instance.updateAnActivity(activityId: 796245274,
                                                           name: "Amazing Super Ride",
                                                           activityType: .AlpineSki,
                                                           description: "Test name",
                                                           isPrivate: false,
                                                           isTrainer: true,
                                                           isCommute: false,
                                                           completionHandler: { (activity: StravaResponse<Activity>) in
                                                            self.showResponse(activity)
                    })
                }),
                ("Delete an activity", {
                    StravaClient.instance.deleteAnActivity(activityId: 797975722, completionHandler: { success, error in
                        self.showResponse(success: success, error: error)
                    })
                }),
                ("List athlete activities", {
                    StravaClient.instance.listAthletesActivities(afterDate: nil, beforeDate: Date(), completionHandler: { (activities: StravaResponse<[ActivitySummary]>) in
                        self.showResponse(activities)
                    })
                }),
                ("List related activities", {
                    StravaClient.instance.listRelatedActivities(activityId: 137989091, completionHandler: { (activities: StravaResponse<[ActivitySummary]>) in
                        self.showResponse(activities)
                    })
                }),
                ("List friends' activities", {
                    StravaClient.instance.listFriendsActivities(beforeDate: Date(), completionHandler: { (activities: StravaResponse<[ActivitySummary]>) in
                        self.showResponse(activities)
                    })
                }),
                ("List activity zones", {
                    StravaClient.instance.listActivityZones(activityId: 137989091, completionHandler: { (zones: StravaResponse<[ActivityZone]>) in
                        self.showResponse(zones)
                    })
                }),
                ("List activity laps", {
                    StravaClient.instance.listActivityLaps(activityId: 137989091, completionHandler: { (laps: StravaResponse<[Lap]>) in
                        self.showResponse(laps)
                    })
                }),
                ]
            ),
            (key: "Clubs",
             cases: [
                ("Retrieve a club", {
                    StravaClient.instance.retrieveAClub(clubId: "242636", completionHandler: { (club: StravaResponse<Club>) in
                        self.showResponse(club)
                    })
                }),
                ("List club announcements", {
                    StravaClient.instance.listClubAnnouncements(clubId: "242636", completionHandler:{ (clubAnnouncements: StravaResponse<[Announcement]>) in
                        self.showResponse(clubAnnouncements)
                    })
                }),
                ("List club group events", {
                        StravaClient.instance.listClubGroupEvents(clubId: "242636", completionHandler: { (clubGroupEvents: StravaResponse<[GroupEvent]>) in
                        self.showResponse(clubGroupEvents)
                    })
                }),
                ("List athlete clubs", {
                        StravaClient.instance.listAthleteClubs(completionHandler: { (athleteClubs: StravaResponse<[ClubSummary]>) in
                        self.showResponse(athleteClubs)
                    })
                }),
                ("List club members", {StravaClient.instance.listClubMembers(clubId: "242636", completionHandler: { (clubMembers: StravaResponse<[AthleteSummary]>) in
                    self.showResponse(clubMembers)
                    })
                }),
                ("List club admins", { StravaClient.instance.listClubAdmins(clubId: "242636", completionHandler: { (clubAdmins: StravaResponse<[AthleteSummary]>) in
                        self.showResponse(clubAdmins)
                    })
                }),
                ("List club activities", {
                    StravaClient.instance.listClubActivities(clubId: "242636", completionHandler: { (clubActivities: StravaResponse<[ActivitySummary]>) in
                        self.showResponse(clubActivities)
                    })
                }),
                ("Join a club", {StravaClient.instance.joinClub(clubId: "242636", completionHandler: { (clubMembership: StravaResponse<ClubMembership>) in
                    self.showResponse(clubMembership)
                    })
                }),
                ("Leave a club", {
                    StravaClient.instance.leaveAClub(clubId: "242636", completionHandler: { (clubMembership: StravaResponse<ClubMembership>) in
                        self.showResponse(clubMembership)
                    })
                }),
            ]),
            (key: "Routes",
             cases: [
                ("Retrieve a route", {
                    StravaClient.instance.retrieveARoute(routeId: 7179440, completionHandler: { route in
                        self.showResponse(route)
                    })
                }),
                ("List routes", {
                    StravaClient.instance.listRoutes(athleteId: 4243694, completionHandler: { routes in
                        self.showResponse(routes)
                    })
                })
            ]),
            (key: "Streams",
             cases: [
                ("Retrieve activity streams", {
                    StravaClient.instance.retrieveActivityStreams(activityId: 137989091, types: [.Cadence, .Coordinate], resolution: Resolution.Low, completionHandler: { streams in
                       self.showResponse(streams)
                    })
                })
            ]),
            (key: "Uploads",
             cases: [
                ("Upload activity", {
                    if let filepath = Bundle.main.path(forResource: "gpx", ofType: "gpx") {
                        do {
                            let contents = try String(contentsOfFile: filepath).data(using: .utf8)!
                            print(contents)
                            StravaClient.instance.uploadAnActivity(activityType: 4, isTrainer: true, isCommute: true, dataType: ActivityUploadType.gpx, externalId: "random", file: contents, completionHandler: { response in
                                print(response)
                            })
                        } catch {
                            // contents could not be loaded
                        }
                    } else {
                        // example.txt not found!
                    }
                    
                })
                ]),
        ]
    }
    
    func showResponse<Value>(_ response: StravaResponse<Value>) {
        switch response {
        case .Success(let value):
            if Value.self is Mappable.Type {
                lastResponse = "\((value as! Mappable).toJSON())"
            } else  {
                lastResponse = "-> \(response)"
            }
        case .Failure(let err):
            print("^ Error! \(err.message)")
        }
        performSegue(withIdentifier: "ResponseSegueId", sender: self)
    }
    
    func showResponse(success: Bool, error: StravaError?) {
        lastResponse = "\(success)"
        if let err = error {
            print("^ Error! \(err.message)")
        }
        performSegue(withIdentifier: "ResponseSegueId", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResponseSegueId" {
            let destination = segue.destination as! ResponseViewController
            destination.data = lastResponse
        }
    }
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return data!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data![section].cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseId = "RequestNameCellId"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId)!
        cell.textLabel?.text = data?[indexPath.section].cases[indexPath.row].0
        return cell
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data?[section].key
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        data?[indexPath.section].cases[indexPath.row].1()
    }
}

