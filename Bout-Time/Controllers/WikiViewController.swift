//
//  WikiViewController.swift
//  Bout-Time
//
//  Created by Cristian Sedano Arenas on 22/07/2019.
//  Copyright © 2019 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import WebKit

class WikiViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    var wikipediaLink: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let wikiLinkURL = URL(string: wikipediaLink)
        let request = URLRequest(url: wikiLinkURL!)
        webView.load(request)
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
