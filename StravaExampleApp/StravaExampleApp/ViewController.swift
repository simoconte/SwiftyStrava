//
//  ViewController.swift
//  StravaExampleApp
//
//  Created by Oleksandr Glagoliev on 27/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import UIKit
import Strava

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let url = try? StravaClient.instance.oAuthURL() {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url) { _ in }
            } else {
                print("Cannot open URL \(url)")
            }
        } else {
            print("No URL!")
        }
    }


}

