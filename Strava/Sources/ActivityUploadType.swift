//
//  ActivityUploadType.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 20/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import Foundation

public enum ActivityUploadType: String {
    case fit = "fit"
    case fitZipped = "fit.gz"
    case tcx = "tcx"
    case tcxZipped = "tcx.gz"
    case gpx = "gpx"
    case gpxZipped = "gpx.gz"
}
