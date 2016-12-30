//
//  ResponseViewController.swift
//  FaceWind
//
//  Created by Oleksandr Glagoliev on 29/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import UIKit

class ResponseViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var data: String = ""
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.text = data
    }

}
