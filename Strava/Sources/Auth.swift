//
//  Auth.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 06/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

open class Auth {
    var accessToken: String = ""
    var athlete: Athlete?
    
    required public init?(map: Map){}
}

extension Auth: Mappable {
    public func mapping(map: Map) {
        accessToken <- map["access_token"]
        athlete <- map["athlete"]
    }
}
