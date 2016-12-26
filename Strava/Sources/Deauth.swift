//
//  Deauth.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 12/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import ObjectMapper

open class Deauth {
    var accessToken: String = ""
    
    required public init?(map: Map){}
}

extension Deauth: Mappable {
    public func mapping(map: Map) {
        accessToken <- map["access_token"]
    }
}
