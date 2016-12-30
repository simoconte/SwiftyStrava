//
//  LoginViewController.swift
//  FaceWind
//
//  Created by Oleksandr Glagoliev on 11/08/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var stravaButton: UIButton!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        stravaButton.alpha = 0
//        let credentials = StravaClient.instance.loginCredentials()
//        if credentials == nil {
//            UIView.animate(withDuration: 0.5){
//                self.stravaButton.alpha = 1
//            }
//        } else {
//            StravaClient.instance.authorize { auth in
//                switch auth {
//                case .Success:
//                    self.showTestView()
//                case .Failure(let err):
//                    print("^ Error! \(err.message)")
//                }
//            }
//        }
    }
    
    private func showTestView() {
        performSegue(withIdentifier: "TestSegueId", sender: nil)
    }

    @IBAction func loginWithStrava(_ sender: AnyObject) {
//        StravaClient.instance.oAuth()
    }

}
