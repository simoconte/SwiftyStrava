//
//  Utils.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 07/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import Foundation
import ObjectMapper

class StravaDateTransform: TransformType {
    typealias JSON = String
    typealias Object = Date
    
    func transformFromJSON(_ value: Any?) -> StravaDateTransform.Object? {
        guard let dateString = value as? String else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxx"
        return formatter.date(from: dateString)
    }
    
    func transformToJSON(_ value: StravaDateTransform.Object?) -> StravaDateTransform.JSON? {
        guard let date = value else { return nil }
        return date.toISO8601String()
    }
}


extension Date {
    func toISO8601String() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxx"
        return formatter.string(from: self)
    }
}
