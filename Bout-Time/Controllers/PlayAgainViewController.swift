//
//  PlayAgainViewController.swift
//  Bout-Time
//
//  Created by Cristian Sedano Arenas on 22/07/2019.
//  Copyright © 2019 Cristian Sedano Arenas. All rights reserved.
//

import UIKit

class PlayAgainViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

       scoreLabel.text = score
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        performSegue(withIdentifier: "goBack", sender: nil)
    }
}
